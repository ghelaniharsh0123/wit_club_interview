import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';
import 'package:wit_club_interview/view/recipe/steps_screen.dart';

class ViewRecipeScreen extends StatefulWidget {
  String? path;
  bool? isImage;
  bool? isNetwork;

  ViewRecipeScreen({Key? key, this.path, this.isImage, this.isNetwork = false})
      : super(key: key);

  @override
  State<ViewRecipeScreen> createState() => _ViewRecipeScreenState();
}

class _ViewRecipeScreenState extends State<ViewRecipeScreen> {
  RecipeController recipeController = Get.put(RecipeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('image:::${widget.path}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Utils.commonText(
            text: 'View Recipe', fontSize: 22, fontWeight: FontWeight.bold),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (widget.path != null)
                    ? (widget.isImage!)
                        ? SizedBox(
                            height: 100,
                            width: 100,
                            child: (widget.isNetwork!)
                                ? Image.network(widget.path!)
                                : Image.file(File(widget.path!))):
                      SizedBox(
                                height: 120,
                                width: 300,
                                child: VideoPlay(
                                  isNetwork: widget.isNetwork!,
                                  url: widget.path,
                                ),
                              )

                    : (recipeController.video.value.path != "")
                        ? SizedBox(
                            height: 120,
                            width: 300,
                            child: VideoPlay(
                              isNetwork: false,
                              url: recipeController.video.value.path,
                            ),
                          )
                        : SizedBox(
                            height: 100,
                            width: 100,
                            child: Image.file(
                                File(recipeController.photo.value.path)),
                          ),
                Utils.commonText(
                    text: 'Dish name', fontSize: 14, fontColor: AppColors.grey),
                Utils.commonText(
                    text: recipeController.recipeNameController.value.text,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.black),
                const SizedBox(
                  height: 20,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Utils.commonText(
                              text: 'Prep time',
                              fontSize: 14,
                              fontColor: AppColors.blue),
                          Utils.commonText(
                              text: recipeController
                                  .preparationTimeController.value.text,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontColor: AppColors.black),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Utils.commonText(
                              text: 'Cook time',
                              fontSize: 14,
                              fontColor: AppColors.blue),
                          Utils.commonText(
                              text: recipeController
                                  .preparationTimeController.value.text,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontColor: AppColors.black),
                        ],
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Utils.commonText(
                              text: 'Serve Person',
                              fontSize: 14,
                              fontColor: AppColors.blue),
                          Utils.commonText(
                              text: recipeController.serveController.value.text,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontColor: AppColors.black),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Utils.commonText(
                    text: 'Ingredients',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.blue),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipeController.ingredientsList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${index + 1}. ${recipeController.ingredientsList[index][AppConstant.ingredients].text} (${recipeController.ingredientsList[index][AppConstant.qty].text} ${recipeController.ingredientsList[index][AppConstant.measure]})'),
                            ],
                          ),
                        ),
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                Utils.commonText(
                    text: 'Steps',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontColor: AppColors.blue),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: recipeController.steps.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                            '${index + 1}${recipeController.steps[index]['step'].text}'),
                      );
                    }),
                SizedBox(
                  height: 30,
                ),
                (widget.path != null)
                    ? Container()
                    : Center(
                        child: Utils.commonButton(
                            buttonText: 'Add Recipe',
                            onTap: () {
                              recipeController.addData();
                            },
                            heights: 40,
                            width: 120),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
