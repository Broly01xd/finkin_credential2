import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/pages/home_screen/account_screen.dart';
import 'package:finkin_credential/pages/home_screen/home_screen.dart';
import 'package:finkin_credential/pages/home_screen/loan_screen.dart';
import 'package:finkin_credential/repository/agent_repository/authentication_repository.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:finkin_credential/res/constants/enums/enums.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class UserNav extends StatefulWidget {
  final int initialIndex;

  const UserNav({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<UserNav> createState() => _UserNavState();
}

class _UserNavState extends State<UserNav> {
  late PageController _pageController;
  late int _currentIndex;
  late List<Widget> _screens;
  final LoginController loginController = Get.put(LoginController());
    final AuthenticationRepository auth = Get.put(AuthenticationRepository());
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);

    _screens = [
       
      const LoanScreen(
        title: 'Loan Tracking',
      ),
      const LoanScreen(
        title: 'Approved',
        status: LoanStatus.approved,
      ),
      const AccountScreen(),
    ];
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  SystemNavigator.pop();
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColor.textLight,
        bottomNavigationBar: CurvedNavigationBar(
          animationDuration: const Duration(milliseconds: 300),
          buttonBackgroundColor: AppColor.icon,
          backgroundColor: AppColor.textLight,
          height: 50,
          color: AppColor.primary,
          index: _currentIndex,
          items: const [
           
             
            Icon(
              Icons.content_paste_search,
              color: AppColor.textLight,
              size: 30,
            ),
            Icon(
              Icons.book,
              color: AppColor.textLight,
              size: 30,
            ),
            Icon(
              Icons.account_circle_outlined,
              color: AppColor.textLight,
              size: 30,
            ),
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.jumpToPage(index);
          },
        ),
        body: PageView(
          controller: _pageController,
          onPageChanged: (newIndex) {
            setState(() {
              _currentIndex = newIndex;
            });
          },
          children: _screens,
        ),
      ),
    );
  }
}
