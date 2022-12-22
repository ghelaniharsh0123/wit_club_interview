import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/main.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/utils/loader.dart';

class HomeController extends GetxController{
  RecipeController recipeController=Get.put(RecipeController());
  RxList recipeList=[].obs;
  RxList recipeListLocal=[].obs;
  RxBool isDataAvailable=false.obs;
  String imageUrl="";
  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child(AppConstant.userMaster)
      .child(getStorage.read(AppConstant.userId));
  getData() async {

    final connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    print('result...$result');
    print('vvvv${ConnectivityResult.mobile}');
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi)
      {
        if(getStorage.read(AppConstant.localList)!=null){
          recipeListLocal.value=getStorage.read(AppConstant.localList);
        }
        print('recepi local;$recipeListLocal');
        isDataAvailable.value=false;
        await reference.child(AppConstant.recipeMaster).once().then((value) {
          recipeList.clear();
          DataSnapshot dataSnapshot = value.snapshot;
          for (var data in dataSnapshot.children) {
            Map? value = data.value as Map;
            recipeList.add(value);
            print('value:$value');
          }
        });
      }

    else
    {
      print('in else......');
      isDataAvailable.value=true;
      if(getStorage.read(AppConstant.localList)!=null){
        recipeListLocal.value=getStorage.read(AppConstant.localList);
      }
      print('recepi local;$recipeListLocal');
      print('recepi local;$recipeList');
    }

    isDataAvailable.value=true;

  }

  addLocalData() async {
    final connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      print('in.....');
      showProgressDialog();
      for (int k = 0; k < recipeListLocal.length; k++) {
        List ingredient = [];
        for (int i = 0; i <
            recipeListLocal[k][AppConstant.ingredients].length; i++) {
          ingredient.add({
            AppConstant.ingredients:
            recipeListLocal[k][AppConstant.ingredients][i][AppConstant
                .ingredients],
            AppConstant.qty: recipeListLocal[k][AppConstant
                .ingredients][i][AppConstant.qty],
            AppConstant.measure: recipeListLocal[k][AppConstant
                .ingredients][i][AppConstant.measure],
          });
        }
        List step = [];
        for (int i = 0; i < recipeListLocal[k][AppConstant.steps].length; i++) {
          step.add({
            AppConstant.steps: recipeListLocal[k][AppConstant
                .ingredients][i]['step'],
          });
        }
        Map data = {
          AppConstant.recipeName: recipeListLocal[k][AppConstant.recipeName],
          AppConstant.prepTime: recipeListLocal[k][AppConstant.prepTime],
          AppConstant.cookTime: recipeListLocal[k][AppConstant.cookTime],
          AppConstant.serve: recipeListLocal[k][AppConstant.serve],
          AppConstant.ingredients: ingredient,
          AppConstant.steps: step,


        };
        await recipeController.uploadImage(recipeListLocal[k][AppConstant.image]);
        if (recipeListLocal[k][AppConstant.isImage]) {
          data.addAll({AppConstant.image: imageUrl, AppConstant.isImage: true});
        }
        else {
          data.addAll(
              {AppConstant.image: imageUrl, AppConstant.isImage: false});
        }
print("data:::$data");
        await reference
            .child(AppConstant.recipeMaster)
            .push()
            .set(data);
      }
      hideProgressDialog();
      getStorage.write(AppConstant.localList, []);
      getData();
    }
  }
}