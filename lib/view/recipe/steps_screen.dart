import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:wit_club_interview/controller/reccipe_controller.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';
import 'package:wit_club_interview/view/recipe/view_receipe_screen.dart';

class StepsScreen extends StatefulWidget {
  const StepsScreen({Key? key}) : super(key: key);

  @override
  State<StepsScreen> createState() => _StepsScreenState();
}

class _StepsScreenState extends State<StepsScreen> {
  RecipeController recipeController = Get.put(RecipeController());

  void reorderData(int oldindex, int newindex) {
    if (newindex > oldindex) {
      newindex -= 1;
    }
    final items = recipeController.steps.removeAt(oldindex);
    recipeController.steps.insert(newindex, items);
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 100),() {
      recipeController.photo.value=XFile('');
      recipeController.video.value=XFile('');
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              ReorderableListView(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                onReorder: reorderData,
                children: <Widget>[
                  for (int i = 0; i < recipeController.steps.length; i++)

                    // for (final items in recipeController.steps)
                    steps(recipeController.steps[i], i)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Utils.commonButton(
                  buttonText: 'Add step',
                  onTap: () {
                    recipeController.steps
                        .add({'step': TextEditingController()});
                  },
                  heights: 35,
                  width: 80),
              const SizedBox(
                height: 20,
              ),
              (recipeController.video.value.path == "" &&
                      recipeController.photo.value.path == "")
                  ? InkWell(
                      onTap: () {
                        Get.bottomSheet(bottomSheet());
                      },
                      child: Container(
                        height: 80,
                        width: 200,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.grey,
                                  blurRadius: 2,
                                  offset: Offset(-1, 3))
                            ]),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.add,
                                color: AppColors.grey,
                              ),
                              Text('Add Video Or Photo',
                                  style: Utils.commonTextStyle().copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.grey)),
                            ],
                          ),
                        ),
                      ),
                    )
                  : (recipeController.photo.value.path != "")
                      ? Container(
                          height: 100,
                          width: 100,
                          child: Image.file(
                              File(recipeController.photo.value.path)),
                        )
                      : Container(
                width: 300,
                        height: 100,
                        child: VideoPlay(
                            isNetwork: false,
                            url: recipeController.video.value.path),
                      ),
              SizedBox(
                height: 15,
              ),
              Utils.commonButton(
                  buttonText: 'View Recipe',
                  onTap: () {
                    Get.to(()=>ViewRecipeScreen());
                  },
                  heights: 40,
                  width: 100)
            ],
          ),
        ),
      );
    });
  }

  Widget steps(final key, int index) {
    return Padding(
      key: ValueKey(key),
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 2)]),
        child: Utils.commonTextField(
            textEditingController: key['step'],
            hintText: 'step ${index + 1}',
            textInputAction: TextInputAction.next,
            textInputType: TextInputType.name,
            validator: (String value) {
              return !value.isNotEmpty ? "Please enter Steps" : null;
            }),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      color: Colors.white,
      height: 200,
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              recipeController.pickImage();
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: AppColors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.image,
                    color: AppColors.white,
                  ),
                  Text(
                    'Photo',
                    style: Utils.commonTextStyle()
                        .copyWith(color: AppColors.white),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 100,
          ),
          InkWell(
            onTap: () {
              recipeController.pickVideo();
            },
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: AppColors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.video_camera_back_outlined,
                    color: Colors.white,
                  ),
                  Text('Video',
                      style: Utils.commonTextStyle()
                          .copyWith(color: AppColors.white))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VideoPlay extends StatefulWidget {
  bool? isNetwork;
  String? url;

  VideoPlay({Key? key, this.isNetwork, this.url}) : super(key: key);

  @override
  _VideoPlayState createState() => _VideoPlayState();
}

class _VideoPlayState extends State<VideoPlay> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.isNetwork!) {
      _controller = VideoPlayerController.network(widget.url!)
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    } else {
      _controller = VideoPlayerController.file(File(widget.url!))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Center(
          child: _controller.value.isInitialized
              ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              : Container(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
