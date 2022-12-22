import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/controller/auth_controller.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';
import 'package:wit_club_interview/view/auth/sign_up_screen.dart';
import 'package:wit_club_interview/view/dashboard/home_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authController = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // emailController.text = "romilmavani318@gmail.com";
    // passwordController.text = "Romil@123";

    return Scaffold(

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.10,
              ),
              Utils.commonText(
                  text: 'Login To Account',
                  fontSize: 22,
                  fontColor: AppColors.white,
                  fontWeight: FontWeight.bold),
              vSizedBox(),
              vSizedBox(),
              Utils.commonTextField(
                  textEditingController: emailController,
                  hintText: 'email',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                  validator: (String value) {
                    return !value.isEmail ? "Please enter valid email" : null;
                  }),
              vSizedBox(),
              Utils.commonTextField(
                  textEditingController: passwordController,
                  hintText: 'password',
                  validator: (String value) {
                    return value.isEmpty ? "Please enter valid password" : null;
                  }),
              SizedBox(
                height: Get.height * 0.05,
              ),

              vSizedBox(),
              Utils.commonButton(
                  buttonText: 'Login',
                  onTap: () {


                    if (_formKey.currentState!.validate()) {

                      authController.firebaseLogin(
                          email: emailController.text,
                          password: passwordController.text,
                          callBack: () {
                            Get.to(() => const HomeScreen());
                          },
                          context: context);

                    } else {

                    }
                  }),
              vSizedBox(),
              vSizedBox(),
              Center(
                  child: Utils.commonText(
                      text: 'login with',
                      fontWeight: FontWeight.bold,
                      fontColor: AppColors.white)),
              SizedBox(
                height: Get.height * 0.02,
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "New user?  ",
                      style: Utils.commonTextStyle()
                          .copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAll(() => const SignupScreen());

                              },
                            text: 'Create Account',
                            style: Utils.commonTextStyle().copyWith(
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                color: AppColors.blue))
                      ]),
                ),
              )
            ],
          ).paddingSymmetric(horizontal: 15, vertical: 20),
        ),
      ),
    );
  }

  vSizedBox() => SizedBox(
    height: Get.height * 0.02,
  );
}
