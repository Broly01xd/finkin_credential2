import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horizontal_stepper_flutter/horizontal_stepper_flutter.dart';

import '../../controller/info_controller.dart';
import '../../controller/login_controller.dart';

class InfoDisplay extends StatefulWidget {
  const InfoDisplay({Key? key}) : super(key: key);

  @override
  State<InfoDisplay> createState() => _InfoDisplayState();
}

class _InfoDisplayState extends State<InfoDisplay> {
  bool isPersonalDetailsSelected = true;
  final UserInfoController userInfoController = Get.put(UserInfoController());
  final LoginController loginController = Get.put(LoginController());
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    String id = loginController.agentId.value;
    // Fetch user details when the screen is initialized
    userInfoController.fetchUserDetails(id);
    // Update the UI by calling setState

    print("Image URL: ${userInfoController.userid.value}");
  }

  ImageProvider _buildImageProvider(String imageUrl) {
    try {
      return NetworkImage(imageUrl);
    } catch (e) {
      print("Error loading image: $e");
      // You can return a placeholder image or handle the error in a way that fits your application.
      // For example, return AssetImage('path/to/placeholder_image.jpg') or an empty AssetImage.
      return AssetImage('assets/images/contact.svg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (userInfoController.isLoading.value) {
          // Show a loading indicator while data is being fetched
          return Center(child: CircularProgressIndicator());
        } else {
          // Continue with your existing UI code
          return CustomScrollView(
            slivers: [
              const SliverAppBar(
                title:
                    Text('Loan', style: TextStyle(color: AppColor.textLight)),
                backgroundColor: AppColor.primary,
                centerTitle: true,
                automaticallyImplyLeading: false,
                pinned: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      color: AppColor.textLight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: CircleAvatar(
                                    backgroundImage: _buildImageProvider(
                                        userInfoController.imageUrl.value),
                                    radius: 50,
                                    backgroundColor: AppColor.secondary,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  userInfoController.fullName.value,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "USER-${userInfoController.userid.value}",
                                  style: TextStyle(
                                    color: AppColor.textdivider,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 180,
                                  width: 345,
                                  decoration: BoxDecoration(
                                    color: AppColor.textLight,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: AppColor.textPrimary,
                                      width: 0.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColor.textdivider
                                            .withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      const Align(
                                        alignment: Alignment.topCenter,
                                        child: Text(
                                          "Application Tracking ID : HM-BS-8741550",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColor.primary,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: FlutterHorizontalStepper(
                                          titleStyle: const TextStyle(
                                              color: AppColor.primary),
                                          steps: const [
                                            "Application sent",
                                            "Approval Pending",
                                            "Loan Approved",
                                          ],
                                          radius: 45,
                                          currentStep: userInfoController
                                              .currentStep.value,
                                          currentStepColor: AppColor.secondary,
                                          child: const [
                                            Icon(Icons.bookmark_add_sharp),
                                            Icon(Icons.hourglass_top_sharp),
                                            Icon(Icons.check_rounded, size: 32),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isPersonalDetailsSelected = true;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          fixedSize: const Size(140, 60),
                                          backgroundColor:
                                              isPersonalDetailsSelected
                                                  ? AppColor.primary
                                                  : AppColor.subtext,
                                        ),
                                        child: const Text(
                                          'Personal Details',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.textLight),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            isPersonalDetailsSelected = false;
                                          });
                                        },
                                        style: TextButton.styleFrom(
                                          fixedSize: const Size(140, 60),
                                          backgroundColor:
                                              isPersonalDetailsSelected
                                                  ? AppColor.subtext
                                                  : AppColor.primary,
                                        ),
                                        child: const Text(
                                          'Other Details',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColor.textLight),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            color: AppColor.textLight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: isPersonalDetailsSelected
                                ? Column(
                                    children: [
                                      LabeledTextField2(
                                        label: 'Full Name',
                                        hintText:
                                            userInfoController.fullName.value,
                                      ),
                                      SizedBox(height: 10),
                                      LabeledTextField2(
                                        label: 'Email',
                                        hintText:
                                            userInfoController.email.value,
                                      ),
                                      SizedBox(height: 10),
                                      LabeledTextField2(
                                        label: 'Phone ',
                                        hintText:
                                            userInfoController.phone.value,
                                      ),
                                      SizedBox(height: 10),
                                      LabeledTextField2(
                                        label: 'Date Of Birth ',
                                        hintText:
                                            userInfoController.phone.value,
                                      ),
                                      SizedBox(height: 10),
                                      LabeledTextField2(
                                        label: 'Address',
                                        hintText:
                                            userInfoController.address.value,
                                      ),
                                    ],
                                  )
                                : Column(
                                    children: [
                                      const LabeledTextField2(
                                        label: 'Pincode',
                                        hintText: '521707',
                                      ),
                                      const SizedBox(height: 10),
                                      const LabeledTextField2(
                                        label: 'Nationality :',
                                        hintText: 'Indian',
                                      ),
                                      const SizedBox(height: 10),
                                      const LabeledTextField2(
                                        label: 'Aadhar Card Number ',
                                        hintText: '9535 0352 1502',
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Aadhar Card Photo',
                                            style: TextStyle(
                                              color: AppColor.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(90, 46),
                                              primary: AppColor.primary,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'View Image',
                                              style: TextStyle(
                                                  color: AppColor.textLight),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const LabeledTextField2(
                                        label: 'Pan Card Number',
                                        hintText: 'BNFPS7312J',
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Pan Card Photo',
                                            style: TextStyle(
                                              color: AppColor.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(90, 46),
                                              primary: AppColor.primary,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'View Image',
                                              style: TextStyle(
                                                  color: AppColor.textLight),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      const LabeledTextField2(
                                        label: 'Monthly Income ',
                                        hintText: '20,000',
                                      ),
                                      const Text(
                                        'IT Return of Two Years',
                                        style: TextStyle(
                                          color: AppColor.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'First Year',
                                            style: TextStyle(
                                              color: AppColor.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: Size(90, 46),
                                              primary: AppColor.primary,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'View Image',
                                              style: TextStyle(
                                                  color: AppColor.textLight),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Second Year',
                                            style: TextStyle(
                                              color: AppColor.textPrimary,
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {},
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: const Size(90, 46),
                                              primary: AppColor.primary,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 15),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            child: const Text(
                                              'View Image',
                                              style: TextStyle(
                                                  color: AppColor.textLight),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}

class LabeledTextField2 extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? hintText;
  final VoidCallback? onTap;
  final Widget? suffixWidget;
  final TextEditingController? controller;
  final String? regexPattern;

  const LabeledTextField2({
    required this.label,
    this.hintText,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.controller,
    this.regexPattern,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColor.textdivider),
            ),
            suffixIcon: icon != null
                ? InkWell(
                    onTap: onTap,
                    child: Icon(icon),
                  )
                : suffixWidget,
          ),
          cursorColor: AppColor.textPrimary,
          validator: (value) {
            if (regexPattern != null && value != null) {
              final RegExp regex = RegExp(regexPattern!);
              if (!regex.hasMatch(value)) {
                return 'Invalid format';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
