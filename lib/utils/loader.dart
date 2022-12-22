import 'package:flutter/material.dart';
import 'package:get/get.dart';
void showProgressDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
    // FeedListController.to.isFetching.value = true;
  }
  if (Get.isSnackbarOpen) {
    Get.closeCurrentSnackbar();
  }
  Get.dialog(
      WillPopScope(
        onWillPop: () => Future.value(false),
        child: const Center(
          child: CircularProgressIndicator()
        ),
      ),
      barrierDismissible: false);
}
void hideProgressDialog() {
  if (Get.isDialogOpen ?? false) {
    Get.back();
    // FeedListController.to.isFetching.value = false;
  }
}