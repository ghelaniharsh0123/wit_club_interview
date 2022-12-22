import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/utils/utils.dart';

class RecipeInfoScreen extends StatefulWidget {
  const RecipeInfoScreen({Key? key}) : super(key: key);

  @override
  State<RecipeInfoScreen> createState() => _RecipeInfoScreenState();
}

class _RecipeInfoScreenState extends State<RecipeInfoScreen> {
  RecipeController recipeController = Get.put(RecipeController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width,
      child:
      Form(
        key: formKey,
        child: Column(
          children: [
            Expanded(

              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ListView(
                  children: [
                    Utils.commonTextField(
                        textEditingController: recipeController.recipeNameController,
                        hintText: 'Recipe Name',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.name,
                        validator: (String value) {
                          return !value.isNotEmpty
                              ? "Please enter recipe name"
                              : null;
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    Utils.commonTextField(
                        textEditingController: recipeController.serveController,
                        hintText: 'serve to person',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.number,
                        validator: (String value) {
                          return !value.isNotEmpty ? "Please enter serve" : null;
                        }),
                    const SizedBox(height: 15,),
                    Utils.commonTextField(
                        textEditingController: recipeController.preparationTimeController,
                        hintText: 'preparation time',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        validator: (String value) {
                          return !value.isNotEmpty
                              ? "Please enter preparation time"
                              : null;
                        }),
                    const SizedBox(height: 15,),
                    Utils.commonTextField(
                        textEditingController: recipeController.cookTimeController,
                        hintText: 'cook time',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.text,
                        validator: (String value) {
                          return !value.isNotEmpty ? "Please enter cook time" : null;
                        }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
