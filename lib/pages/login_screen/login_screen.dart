// import 'package:country_picker/country_picker.dart';
// import 'package:finkin_credential/pages/verification_screen/verification_screen.dart';
// import 'package:finkin_credential/res/app_color/app_color.dart';
// import 'package:finkin_credential/shared/widgets/custom_button.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../controller/login_controller.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({Key? key}) : super(key: key);
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   bool _isLoading = false;
//   final TextEditingController phoneController = TextEditingController();
//   LoginController controller = Get.find();
//   Country selectedCountry = Country(
//     phoneCode: "91",
//     countryCode: "IN",
//     e164Sc: 0,
//     geographic: true,
//     level: 1,
//     name: "India",
//     example: "India",
//     displayName: "India",
//     displayNameNoCountryCode: "IN",
//     e164Key: "",
//   );
//
//   @override
//   Widget build(BuildContext context) {
//     phoneController.selection = TextSelection.fromPosition(
//       TextPosition(
//         offset: phoneController.text.length,
//       ),
//     );
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
//               child: Column(
//                 children: [
//                   Container(
//                     width: 200,
//                     height: 200,
//                     padding: const EdgeInsets.all(20.0),
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.rectangle,
//                       color: AppColor.secondary,
//                     ),
//                     child: Image.asset(
//                       'assets/images/caros.jpg',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     "Register",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     "Add your phone number. We'll send you a verification code",
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: AppColor.textdivider,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 20),
//                   TextFormField(
//                     keyboardType: TextInputType.number,
//                     cursorColor: AppColor.primary,
//                     controller: phoneController,
//                     style: const TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColor.textPrimary,
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         phoneController.text = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: "Enter phone number",
//                       hintStyle: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 15,
//                         color: AppColor.textdivider,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                             const BorderSide(color: AppColor.textdivider),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:
//                             const BorderSide(color: AppColor.textdivider),
//                       ),
//                       prefixIcon: Container(
//                         padding: const EdgeInsets.all(12.0),
//                         child: InkWell(
//                           onTap: () {
//                             showCountryPicker(
//                               context: context,
//                               countryListTheme: const CountryListThemeData(
//                                 bottomSheetHeight: 550,
//                               ),
//                               onSelect: (value) {
//                                 setState(() {
//                                   selectedCountry = value;
//                                 });
//                               },
//                             );
//                           },
//                           child: Text(
//                             "${selectedCountry.flagEmoji} + ${selectedCountry.phoneCode}",
//                             style: const TextStyle(
//                               fontSize: 18,
//                               color: AppColor.textPrimary,
//                               fontWeight: FontWeight.w300,
//                             ),
//                           ),
//                         ),
//                       ),
//                       suffixIcon: phoneController.text.length > 9
//                           ? Container(
//                               height: 30,
//                               width: 30,
//                               margin: const EdgeInsets.all(10.0),
//                               decoration: const BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: AppColor.icon,
//                               ),
//                               child: const Icon(
//                                 Icons.done,
//                                 color: AppColor.textLight,
//                                 size: 20,
//                               ),
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: _isLoading
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                               color: AppColor.textLight,
//                             ),
//                           )
//                         : CustomButton(
//                             text: "Login",
//                             onPressed: () {
//                               controller.getOtp(phoneController.text);
//                               Get.to(VerificationScreen());
//                             }),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//agentform