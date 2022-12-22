import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wit_club_interview/controller/auth_controller.dart';
import 'package:wit_club_interview/utils/colors.dart';
import 'package:wit_club_interview/utils/utils.dart';
import 'package:wit_club_interview/view/auth/sign_in_screen.dart';
import 'package:wit_club_interview/view/dashboard/home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final authController = Get.put(AuthController());
  final fnameController = TextEditingController();
  final lnameController = TextEditingController();
  final emailController = TextEditingController();

  // RxString companynameController = "".obs;
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height * 0.10,
              ),
              Utils.commonText(
                  text: 'Create New Account',
                  fontSize: 22,
                  fontColor: AppColors.black,
                  fontWeight: FontWeight.bold),
              vSizedBox(),

              Utils.commonTextField(
                  textEditingController: emailController,
                  hintText: 'Email',
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.emailAddress,
                  validator: (String value) {
                    return !value.isEmail ? "Please enter valid email" : null;
                  }),
              vSizedBox(),
              Utils.commonTextField(
                  textEditingController: passwordController,
                  hintText: 'Password',
                  validator: (String? value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.isValidPassword()) {
                      return "Please enter valid password.";
                    }
                  }),

             SizedBox(height: 150,),
              Utils.commonButton(
                  buttonText: 'SignUp',
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      await authController.firebaseSignup(
                        email: emailController.text,
                        password: passwordController.text,
                      );
                    }
                  }),
              SizedBox(height: 20,),
              Center(
                child: RichText(
                  text: TextSpan(
                      text: "Already have Account  ",
                      style: Utils.commonTextStyle()
                          .copyWith(fontWeight: FontWeight.bold),
                      children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.offAll(() => const SignInScreen());

                              },
                            text: 'Login',
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
        height: 20,
      );
}
