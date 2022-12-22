import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/controller/home_controller.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';
import 'package:wit_club_interview/view/auth/sign_in_screen.dart';
import 'package:wit_club_interview/view/recipe/recipe_screen.dart';
import 'package:wit_club_interview/view/recipe/view_receipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController homeController = Get.put(HomeController());
  RecipeController recipeController = Get.put(RecipeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    homeController.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 100,
              child: MaterialButton(
                onPressed: () {
                  homeController.addLocalData();
                },
                color: AppColors.white,
                child: Text(
                  'Add Data',
                  style: Utils.commonTextStyle().copyWith(color: AppColors.blue),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: (){
              Get.offAll(()=>const SignInScreen());
            },
            child: Container(
              height: 50,
              width: 50,
              child: Center(
                child: Text(
                  'Log out',
                  style: Utils.commonTextStyle().copyWith(color: AppColors.white),
                ),
              ),
            ),
          ),

        ],
        title: Utils.commonText(
            text: 'Recipe', fontSize: 18, fontWeight: FontWeight.bold),
        centerTitle: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GestureDetector(
        onTap: () {
          Get.to(() => const RecipeScreen());
        },
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: AppColors.blue, borderRadius: BorderRadius.circular(20)),
          child: Utils.commonText(
              text: 'Create Recipe',
              fontColor: AppColors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        return (homeController.isDataAvailable.value)
            ? Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    (homeController.recipeList.isNotEmpty ||
                            homeController.recipeListLocal.isNotEmpty)
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: homeController.recipeList.length,
                            itemBuilder: (context, index) {
                              var data = homeController.recipeList[index];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    recipeController.recipeNameController.text =
                                        data[AppConstant.recipeName];
                                    recipeController.preparationTimeController
                                        .text = data[AppConstant.prepTime];
                                    recipeController.cookTimeController.text =
                                        data[AppConstant.cookTime];
                                    recipeController.serveController.text =
                                        data[AppConstant.serve];
                                    recipeController.ingredientsList.clear();
                                    for (int i = 0;
                                        i <
                                            data[AppConstant.ingredients]
                                                .length;
                                        i++) {
                                      recipeController.ingredientsList.add({
                                        AppConstant.qty: TextEditingController(
                                            text: data[AppConstant.ingredients]
                                                [i][AppConstant.qty]),
                                        AppConstant.ingredients:
                                            TextEditingController(
                                                text: data[AppConstant
                                                        .ingredients][i]
                                                    [AppConstant.ingredients]),
                                        AppConstant.measure:
                                            data[AppConstant.ingredients][i]
                                                    [AppConstant.measure]
                                                .toString(),
                                      });
                                    }
                                    recipeController.steps.clear();
                                    for (int i = 0;
                                        i < data[AppConstant.steps].length;
                                        i++) {
                                      recipeController.steps.add({
                                        'step': TextEditingController(
                                            text: data[AppConstant.steps][i]
                                                [AppConstant.steps]),
                                      });
                                    }
                                    Get.to(() => ViewRecipeScreen(
                                          isImage: data[AppConstant.isImage],
                                          isNetwork: true,
                                          path: data[AppConstant.image],
                                        ));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: AppColors.grey,
                                          offset: const Offset(1, 2),
                                          blurRadius: 2)
                                    ], color: AppColors.white),
                                    child: Text(
                                      data[AppConstant.recipeName],
                                      style: Utils.commonTextStyle().copyWith(
                                          color: AppColors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : const Center(
                            child: Text('No Recipe Found'),
                          ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: homeController.recipeListLocal.length,
                        itemBuilder: (context, index) {
                          var data = homeController.recipeListLocal[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                recipeController.recipeNameController.text =
                                    data[AppConstant.recipeName];
                                recipeController.preparationTimeController
                                    .text = data[AppConstant.prepTime];
                                recipeController.cookTimeController.text =
                                    data[AppConstant.cookTime];
                                recipeController.serveController.text =
                                    data[AppConstant.serve];
                                recipeController.ingredientsList.clear();
                                for (int i = 0;
                                    i < data[AppConstant.ingredients].length;
                                    i++) {
                                  recipeController.ingredientsList.add({
                                    AppConstant.qty: TextEditingController(
                                        text: data[AppConstant.ingredients][i]
                                            [AppConstant.qty]),
                                    AppConstant.ingredients:
                                        TextEditingController(
                                            text: data[AppConstant.ingredients]
                                                [i][AppConstant.ingredients]),
                                    AppConstant.measure:
                                        data[AppConstant.ingredients][i]
                                                [AppConstant.measure]
                                            .toString(),
                                  });
                                }
                                recipeController.steps.clear();
                                for (int i = 0;
                                    i < data[AppConstant.steps].length;
                                    i++) {
                                  recipeController.steps.add({
                                    'step': TextEditingController(
                                        text: data[AppConstant.steps][i]
                                            [AppConstant.steps]),
                                  });
                                }
                                Get.to(() => ViewRecipeScreen(
                                      isImage: data[AppConstant.isImage],
                                      isNetwork: false,
                                      path: data[AppConstant.image],
                                    ));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                      color: AppColors.grey,
                                      offset: const Offset(1, 2),
                                      blurRadius: 2)
                                ], color: AppColors.white),
                                child: Text(
                                  data[AppConstant.recipeName],
                                  style: Utils.commonTextStyle().copyWith(
                                      color: AppColors.black, fontSize: 15),
                                ),
                              ),
                            ),
                          );
                        })
                  ],
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      }),
    );
  }
}
