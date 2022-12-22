import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wit_club_interview/main.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wit_club_interview/utils/connnectivity.dart';
import 'package:wit_club_interview/utils/loader.dart';
import 'package:wit_club_interview/view/dashboard/home_screen.dart';

class RecipeController extends GetxController {
  TabController? tabController;
  Map source = {ConnectivityResult.none: false};
  final MyConnectivity connectivity = MyConnectivity.instance;
  final _firebaseStorage = FirebaseStorage.instance;
  String imageUrl="";
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    connectivity.initialise();
    connectivity.myStream.listen((source) {
      print('source.....$source');
    });
  }

  DatabaseReference reference = FirebaseDatabase.instance
      .ref()
      .child(AppConstant.userMaster)
      .child(getStorage.read(AppConstant.userId));
  var recipeNameController = TextEditingController();
  var serveController = TextEditingController();
  var preparationTimeController = TextEditingController();
  var cookTimeController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  Rx<XFile> photo = XFile('').obs;
  Rx<XFile> video = XFile('').obs;

  pickImage() async {
    photo.value = (await picker.pickImage(source: ImageSource.gallery))!;
    Get.back();
  }

  pickVideo() async {
    video.value = (await picker.pickVideo(source: ImageSource.gallery))!;
    Get.back();
  }
uploadImage(String path) async {
    print('path:::$path');
  var snapshot = await _firebaseStorage.ref()
      .child('images/${DateTime.now()}')
      .putFile(File(path));
  var downloadUrl = await snapshot.ref.getDownloadURL();

    imageUrl = downloadUrl;

}
  addData() async {

    final connectivity = Connectivity();
    ConnectivityResult result = await connectivity.checkConnectivity();
    print('result::$result');
    showProgressDialog();
    List ingredient = [];
    for (int i = 0; i < ingredientsList.length; i++) {
      ingredient.add({
        AppConstant.ingredients:
        ingredientsList[i][AppConstant.ingredients].text,
        AppConstant.qty: ingredientsList[i][AppConstant.qty].text,
        AppConstant.measure: ingredientsList[i][AppConstant.measure],
      });
    }
    List step = [];
    for (int i = 0; i < steps.length; i++) {
      step.add({
        AppConstant.steps: steps[i]['step'].text,
      });
    }
    Map data = {
      AppConstant.recipeName: recipeNameController.value.text,
      AppConstant.prepTime: preparationTimeController.value.text,
      AppConstant.cookTime: cookTimeController.value.text,
      AppConstant.serve: serveController.value.text,
      AppConstant.ingredients: ingredient,
      AppConstant.steps: step,


    };

    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      await uploadImage((photo.value.path.isEmpty)?video.value.path:photo.value.path);
      if(photo.value.path.isNotEmpty){
        data.addAll({AppConstant.image: imageUrl,AppConstant.isImage:true});
      }
      else{
        data.addAll({AppConstant.image: imageUrl,AppConstant.isImage:false});
      }
      print('if.........$data');
      await reference
          .child(AppConstant.recipeMaster)
          .push()
          .set(data)
          .whenComplete(() {
            Get.offAll(()=>const HomeScreen());
        print('added......');
      });
    }
    else {
      if(photo.value.path.isNotEmpty){
        data.addAll({AppConstant.image: photo.value.path,AppConstant.isImage:true});
      }
      else{
        data.addAll({AppConstant.image: video.value.path,AppConstant.isImage:false});
      }
      print('else.........');
      List local = [];
      if (getStorage.read(AppConstant.localList) != null) {
        local = getStorage.read(AppConstant.localList);
      }

      local.add(data);
      getStorage.write(AppConstant.localList, local);
      Get.offAll(()=>const HomeScreen());
    }
    hideProgressDialog();
  }

  List measure = ['gm', 'kg', 'tsp', 'ml', 'cup'];
  RxList steps = [
    {'step': TextEditingController()}
  ].obs;
  RxList ingredientsList = [
    {
      AppConstant.qty: TextEditingController(),
      AppConstant.ingredients: TextEditingController(),
      AppConstant.measure: "",
    }
  ].obs;

}
