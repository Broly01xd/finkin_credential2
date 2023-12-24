import 'package:finkin_credential/pages/home_screen/bottom_nav.dart';
import 'package:finkin_credential/pages/home_screen/user_nav.dart';
import 'package:finkin_credential/repository/agent_repository/authentication_repository.dart';
import 'package:finkin_credential/splash/splash_screen.dart';
import 'package:finkin_credential/utils/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'controller/login_controller.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((value) {
      final auth = Get.put(AuthenticationRepository());
      auth.onReady();
    });
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final loginController = Get.put(LoginController());
  final authController = AuthenticationRepository();
  @override
  Widget build(BuildContext context) {
    authController.onReady();
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: GoogleFonts.lato().fontFamily,
        primaryTextTheme: GoogleFonts.latoTextTheme(),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      // initialRoute: MyRoutes.splashscreen,
      home: Obx(() {
        if (authController.firebaseAgent.value == null) {
          return const SplashScreen();
        } else if (loginController.isUserSelected.value == true) {
          return const UserNav();
        } else {
          return const BottomNavBar();
        }
      }),
      onGenerateRoute: MyRoutes.generateRoute,
    );
  }
}
