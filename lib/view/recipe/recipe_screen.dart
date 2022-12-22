import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';
import 'package:wit_club_interview/view/recipe/ingredient_screen.dart';
import 'package:wit_club_interview/view/recipe/recipe_info_screen.dart';
import 'package:wit_club_interview/view/recipe/steps_screen.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {

  RecipeController recipeController = Get.put(RecipeController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recipeController.recipeNameController.clear();
    recipeController.serveController.clear();
    recipeController.preparationTimeController.clear();
    recipeController.cookTimeController.clear();
    recipeController.ingredientsList.clear();
    recipeController.ingredientsList.add({
      AppConstant.qty: TextEditingController(),
      AppConstant.ingredients: TextEditingController(),
      AppConstant.measure: "",
    });
    recipeController.steps.clear();
    recipeController.steps.add({
      'step': TextEditingController()
    });

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Utils.commonText(
              text: 'Create Recipe', fontSize: 22, fontWeight: FontWeight.bold),
        ),
        body: Container(
          child: Column(
            children: [
              TabBar(
                controller:recipeController.tabController,
                tabs: const [
                  Tab(text: 'recipe'),
                  Tab(text: 'Ingredients'),
                  Tab(text: 'steps')
                ],
                labelColor: AppColors.blue,
                indicatorSize: TabBarIndicatorSize.label,
                unselectedLabelColor: AppColors.grey,
              ),

               Expanded(
                child: TabBarView(
                  controller:recipeController.tabController,
                  children: const [
                    RecipeInfoScreen(),
                    IngredientScreen(),
                    StepsScreen()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
