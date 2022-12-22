
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/utils/loader.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/view/dashboard/home_screen.dart';
import '../main.dart';
class AuthController extends GetxController{
  DatabaseReference userMasterFirebaseDatabase = FirebaseDatabase.instance.ref().child(AppConstant.userMaster);
  firebaseSignup({
    required String email,
    required String password,
  }) async {
    try {
      showProgressDialog();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((userCredential) async {
        String? key = userMasterFirebaseDatabase.push().key;
        getStorage.write(AppConstant.userId, key);
        userMasterFirebaseDatabase.child(key!).set({

          'email': email,

          // AppTexts.password: password
        }).whenComplete((){
          hideProgressDialog();
          print('aaa');
          Get.offAll(()=>const HomeScreen());
        });

      });
    } on FirebaseAuthException catch (e) {
      hideProgressDialog();

    } catch (e) {
      hideProgressDialog();
      print(e);
    }
  }
  firebaseGetUserData(String email) async {

    await userMasterFirebaseDatabase.once().then((value) {
      DataSnapshot dataSnapshot = value.snapshot;
      for (var data in dataSnapshot.children) {
        Map? value = data.value as Map;
        if (value['email'] == email) {
         getStorage.write(AppConstant.userId,data.key);
        }
      }
    });
    // hideProgressDialog();
  }
  firebaseLogin({
    required String email,
    required String password,
    required BuildContext context,
    Function? callBack,
  }) async {
    showProgressDialog();
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
            await firebaseGetUserData(email);
        hideProgressDialog();
        if (callBack != null) {
          callBack();
        }

      });
    } on FirebaseAuthException catch (e) {
      hideProgressDialog();

    } catch (e) {
      hideProgressDialog();
    }
  }
}