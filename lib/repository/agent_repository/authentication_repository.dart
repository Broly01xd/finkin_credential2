import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/pages/home_screen/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../splash/splash_screen.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final loginController = Get.put(LoginController());

  final _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseAgent;

  get firebaseUser => null;

  @override
  void onReady() {
    firebaseAgent = Rx<User?>(_auth.currentUser);
    firebaseAgent.bindStream(_auth.userChanges());
    print('djgfhdf');

    ever(firebaseAgent, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    firebaseAgent.value = user;
    loginController.isUserExist(user?.phoneNumber?.substring(3) ?? '123');
    // user == null
    //     ? Get.offAll(() => const SplashScreen())
    //     : Get.toEnd(() => const BottomNavBar());
  }
}
