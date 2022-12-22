import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';

class IngredientScreen extends StatefulWidget {
  const IngredientScreen({Key? key}) : super(key: key);

  @override
  State<IngredientScreen> createState() => _IngredientScreenState();
}

class _IngredientScreenState extends State<IngredientScreen> {
  RecipeController recipeController = Get.put(RecipeController());

  void reorderData(int oldindex, int newindex) {

      if (newindex > oldindex) {
        newindex -= 1;
      }
      final items = recipeController.ingredientsList.removeAt(oldindex);
      recipeController.ingredientsList.insert(newindex, items);

  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            ReorderableListView(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              onReorder: reorderData,
              children: <Widget>[
                for (int i = 0; i < recipeController.ingredientsList.length; i++)
                  ingredients(recipeController.ingredientsList[i],i)
              ],
            ),


            Utils.commonButton(
                buttonText: 'Add',
                onTap: () {
                  recipeController.ingredientsList.add({
                    AppConstant.qty: TextEditingController(),
                    AppConstant.ingredients: TextEditingController(),
                    AppConstant.measure: "",
                  });
                },
                heights: 35,
                width: 80)
          ],
        ),
      );
    });
  }

  Widget ingredients(final key,int index) {
    return Padding(
      key: ValueKey(key),
      padding: const EdgeInsets.all(8.0),
      child: Container(

        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [const BoxShadow(color: Colors.grey,blurRadius: 2)]
        ),

        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('ingrdient'+(index+1).toString(),style:Utils.commonTextStyle().copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue) ,),
              ),
              SizedBox(height: 10,),
              Utils.commonTextField(
                  textEditingController: key[AppConstant.ingredients],
                  hintText: 'ingredients name',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                  validator: (String value) {
                    return !value.isNotEmpty
                        ? "Please enter ingredient name"
                        : null;
                  }),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                    child: Utils.commonTextField(
                        textEditingController: key[AppConstant.qty],
                        hintText: 'quantity',
                        textInputAction: TextInputAction.next,
                        textInputType: TextInputType.number,
                        validator: (String value) {
                          return !value.isNotEmpty
                              ? "Please enter ingredient name"
                              : null;
                        }),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      height: 58,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.black,
                          ),
                          borderRadius: BorderRadius.circular(15)),
                      child: DropdownButtonFormField(
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            hintText: 'select measure',
                            hintStyle: Utils.commonTextStyle().copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: AppColors.grey)),
                        items: const [
                          DropdownMenuItem(value: "gm", child: Text("gm")),
                          DropdownMenuItem(value: "kg", child: Text("kg")),
                          DropdownMenuItem(value: "ml", child: Text("ml")),
                          DropdownMenuItem(value: "l", child: Text("l")),
                          DropdownMenuItem(value: "tsp", child: Text("tsp")),
                          DropdownMenuItem(value: "cup", child: Text("cup")),
                        ],
                        onChanged: (String? value) {
                          if (value != null) {
                            key[AppConstant.measure] = "$value";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
