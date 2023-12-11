import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/pages/verification_screen/user_type.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerificationScreen extends StatelessWidget {
  final authController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.textLight,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Obx(() => authController.isOtpSent.value
                ? _buildVerifyOtpForm()
                : _buildGetOtpForm())
          ],
        ),
      ),
    );
  }

  Widget _buildGetOtpForm() {
    return SafeArea(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 4),
                child: Center(
                  child: Image.asset(
                    'assets/images/hill.jpg',
                    width: 400,
                    height: 210,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  " Sign in",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              UserTypeSelector(
                isUserSelected: authController.isUserSelected,
                onUserTypeChanged: (isSelected) {
                  authController.setIsUserSelected(isSelected);
                },
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.textLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Obx(() => Column(
                      children: [
                        TextFormField(
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          onChanged: (val) {
                            authController.phoneNo.value = val;
                            authController.showPrefix.value = val.length > 0;
                          },
                          onSaved: (val) => authController.phoneNo.value = val!,
                          validator: (val) => (val!.isEmpty || val.length < 10)
                              ? "Enter a valid number"
                              : null,
                          decoration: InputDecoration(
                            hintText: "Mobile Number",
                            labelText: "Mobile Number",
                            hintStyle:
                                const TextStyle(color: AppColor.textdivider),
                            labelStyle:
                                const TextStyle(color: AppColor.primary),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  const BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefix: authController.showPrefix.value
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      '(+91)',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                            suffixIcon: _buildSuffixIcon(),
                          ),
                          cursorColor: AppColor.textPrimary,
                        ),
                        const SizedBox(
                          height: 22,
                        ),
                        ElevatedButton(
                          onPressed: authController.isButtonClickable.value
                              ? () async {
                                  final form = _formKey.currentState;
                                  if (form!.validate()) {
                                    form.save();
                                    await authController.getOtp();

                                    // Display the message on the same page
                                    authController.statusMessage.value =
                                        "Sending..... OTP to +91${authController.phoneNo.value}.";
                                    authController.statusMessageColor.value =
                                        AppColor.textPrimary;
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: AppColor.textLight,
                            backgroundColor:
                                authController.isButtonClickable.value
                                    ? AppColor.primary
                                    : AppColor.textLight,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(14.0),
                            child: Text(
                              'Get OTP',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 10),
              Obx(
                () => Center(
                  child: Text(
                    authController.statusMessage.value,
                    style: TextStyle(
                      color: authController.statusMessageColor.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//////
  Widget _buildVerifyOtpForm() {
    List<TextEditingController> otpFieldsControler = [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController()
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  authController.isOtpSent.value = false;
                  Get.to(VerificationScreen());
                },
                child: const Icon(Icons.arrow_back,
                    size: 32, color: AppColor.textPrimary),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 40),
              child: Center(
                child: Image.asset(
                  'assets/images/caros.jpg',
                  width: 300,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Verification',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Enter your OTP code number",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 28,
            ),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: AppColor.textLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _textFieldOTP(
                          first: true,
                          last: false,
                          controller: otpFieldsControler[0]),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[1]),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[2]),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[3]),
                      _textFieldOTP(
                          first: false,
                          last: false,
                          controller: otpFieldsControler[4]),
                      _textFieldOTP(
                          first: false,
                          last: true,
                          controller: otpFieldsControler[5]),
                    ],
                  ),
                  Text(
                    authController.statusMessage.value,
                    style: TextStyle(
                        color: authController.statusMessageColor.value,
                        fontWeight: FontWeight.normal),
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        authController.otp.value = "";
                        otpFieldsControler.forEach((controller) {
                          authController.otp.value += controller.text;
                        });
                        authController.verifyOTP(
                            agentId: authController.agentId.value);
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(
                            AppColor.textLight),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(AppColor.primary),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Text(
                          'Verify',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              "Didn't receive any code?",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 18,
            ),
            Obx(
              () => TextButton(
                onPressed: () => authController.resendOTP.value
                    ? authController.resendOtp()
                    : null,
                child: Text(
                  authController.resendOTP.value
                      ? "Resend New Code"
                      : "Wait ${authController.resendAfter} seconds",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColor.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuffixIcon() {
    return AnimatedOpacity(
        opacity: authController.phoneNo?.value.length == 10 ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        child: const Icon(Icons.check_circle, color: AppColor.icon, size: 32));
  }

  Widget _textFieldOTP({bool first = true, last, controller}) {
    var height = (Get.width - 82) / 6;
    return SizedBox(
      height: height,
      child: AspectRatio(
        aspectRatio: 1,
        child: TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              Get.focusScope?.nextFocus();
            }
            if (value.length == 0 && first == false) {
              Get.focusScope?.previousFocus();
            }
          },
          showCursor: true,
          readOnly: false,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: height / 2, fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: AppColor.primary),
                borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 2, color: AppColor.primary),
                borderRadius: BorderRadius.circular(12)),
          ),
          cursorColor: AppColor.textPrimary,
        ),
      ),
    );
  }
}
