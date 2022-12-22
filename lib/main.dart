import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wit_club_interview/utils/app_const.dart';
import 'package:wit_club_interview/view/auth/sign_in_screen.dart';
import 'package:wit_club_interview/view/auth/sign_up_screen.dart';
import 'package:wit_club_interview/view/dashboard/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const UserApp());
}
final getStorage = GetStorage();

class UserApp extends StatelessWidget {
  const UserApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: "Wit_Club",

      home: (getStorage.read(AppConstant.userId)==null)?const SignInScreen():const HomeScreen() ,
      // home: const BottomNavBar(),
    );
  }
}


