import 'dart:io';

import 'package:finkin_credential/controller/loan_form_controller.dart';
import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/agent_model/agent_model.dart';
import '../../repository/agent_repository/agent_repository.dart';
import 'companyworker_form.dart';

class LoanForm extends StatefulWidget {
  final String title;

  const LoanForm({Key? key, required this.title, required String agentId})
      : super(key: key);

  @override
  State<LoanForm> createState() => _LoanFormState();
}

class _LoanFormState extends State<LoanForm> {
  final formKey = GlobalKey<FormState>();
  final LoanFormController controller = Get.put(LoanFormController());
  final LoginController loginController = Get.put(LoginController());
  File? _selectedImage;
  String imageUrl = '';
  XFile? _pickedFile;
  XFile? _pickedFile2;
  DateTime? selectedDate;
  final LoanFormController loanFormController = Get.find();
  final AgentRepository agentRepository = Get.put(AgentRepository());
  get title => widget.title;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<String?> getAgentName(String agentId) async {
    try {
      print("Fetching agent with ID: $agentId");
      final AgentModel? agent = await agentRepository.getAgentById(agentId);
      print("Fetched agent: $agent");
      return agent?.name;
    } catch (e) {
      print('Error fetching agent name: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
      key: _scaffoldKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            title,
            style: const TextStyle(
              color: AppColor.textLight,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColor.primary,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Personal Information'),
                  const SizedBox(height: 20),
                  // _buildAgentSection(),
                  _buildNameNumberSection(),
                  _buildEmailNumberSection(),
                  _buildPhoneNumberSection(),
                  _buildVerificationCodeSection(),
                  _buildDateOfBirthSection(),
                  _buildAddressSection(),
                  _buildPinCodeAndNationalitySection(),
                  _buildAadharNumberSection(),
                  _buildAadharCardUploadSection(),
                  _builPanNumberSection(),
                  _buildPANCardUploadSection(),
                  _buildEmployeeTypeSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildNameNumberSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Full Name',
            hintText: 'Enter full name as per Aadhar card',
            regexPattern: LoanFormController.nameRegex,
            controller: controller.firstNameController,
          ),
        ),
      ],
    );
  }

  Widget _buildEmailNumberSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Email',
            regexPattern: LoanFormController.emailRegex,
            controller: controller.emailController,
          ),
        ),
      ],
    );
  }

  Widget _buildANameSection() {
    return const Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Agent Name',
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneNumberSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Phone Number',
            regexPattern: LoanFormController.phoneNumberRegex,
            controller: controller.phoneNumberController,
          ),
        ),
        const SizedBox(width: 10),
        _buildVerificationButton(),
      ],
    );
  }

  Widget _buildAadharNumberSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Enter Your Aadhar Number',
            regexPattern: LoanFormController.aadharCardRegex,
            controller: controller.aadharCardController,
          ),
        ),
      ],
    );
  }

  Widget _builPanNumberSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Enter Your PAN Number',
            regexPattern: LoanFormController.panCardRegex,
            controller: controller.panCardController,
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationButton() {
    return ElevatedButton(
      onPressed: () {
        // setState(() {
        //   isPhoneNumberVerified = true;
        // });
      },
      style: ElevatedButton.styleFrom(
        primary: AppColor.icon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Verify',
        style: TextStyle(color: AppColor.textLight),
      ),
    );
  }

  Widget _buildVerificationCodeSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Enter Verification Code',
            regexPattern: LoanFormController.pinCodeRegex,
            controller: controller.pinCodeController,
          ),
        ),
        const SizedBox(width: 10),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          setState(() {});
        }
      },
      style: ElevatedButton.styleFrom(
        primary: AppColor.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(color: AppColor.textLight),
      ),
    );
  }

  Widget _buildDateOfBirthSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            icon: Icons.calendar_month_outlined,
            iconColor: AppColor.textPrimary,
            label: 'Date of Birth',
            // regexPattern: LoanFormController.dateOfBirthRegex,
            controller: TextEditingController(
              text: selectedDate != null
                  ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                  : '',
            ),
            onTap: () => _selectDate(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Container(
      width: double.maxFinite,
      child: LabeledTextField(
        label: 'Address',
        regexPattern: LoanFormController.addressRegex,
        controller: controller.addressController,
      ),
    );
  }

  Widget _buildPinCodeAndNationalitySection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Enter PIN Code',
            regexPattern: LoanFormController.pinCodeRegex,
            controller: controller.pinController,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: LabeledTextField(
            label: 'Nationality',
            regexPattern: LoanFormController.nameRegex,
            controller: controller.nationalityController,
          ),
        ),
      ],
    );
  }

  Future<String> _uploadImageToFirestore(XFile pickedFile) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('aadhar_images/${DateTime.now().millisecondsSinceEpoch}');

      await storageReference.putFile(File(pickedFile.path));

      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<String> _uploadPanImageToFirestore(XFile pickedFile) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('pan_images/${DateTime.now().millisecondsSinceEpoch}');

      await storageReference.putFile(File(pickedFile.path));

      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Widget _buildAadharCardUploadSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Upload Your Aadhar Card Photo',
            suffixWidget: _buildChooseFileButton(_pickedFile, () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile != null) {
                String imageUrl = await _uploadImageToFirestore(pickedFile);

                loanFormController.updateAadharImageUrl(imageUrl);
                setState(() {
                  _pickedFile = pickedFile;
                });
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildPANCardUploadSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Upload Your PAN Card Photo',
            suffixWidget: _buildChooseFileButton(_pickedFile2, () async {
              final pickedFile2 =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile2 != null) {
                String imageUrl = await _uploadPanImageToFirestore(pickedFile2);

                loanFormController.updatePanImageUrl(imageUrl);
                setState(() {
                  _pickedFile2 = pickedFile2;
                });
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildChooseFileButton(XFile? pickedFile, VoidCallback onPressed) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(12),
            color: AppColor.subtext,
            child: const Text(
              'Choose File',
              style: TextStyle(
                color: AppColor.textLight,
              ),
            ),
          ),
        ),
        if (pickedFile != null)
          Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showImageDialog(pickedFile);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'View Image',
                    style: TextStyle(color: AppColor.textLight),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  pickedFile.name,
                  style: const TextStyle(
                    color: AppColor.textLight,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _showImageDialog(XFile pickedFile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.file(
                  File(pickedFile.path),
                  height: 500,
                  width: 500,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: AppColor.textLight),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmployeeTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Choose Type Of Employee",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                child:
                    _buildEmployeeTypeButton('Self Employed', AppColor.primary),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const BottomNavBar(),
                  //   ),
                  // );
                },
                child: _buildCompanyTypeButton(
                    'Company Worker ', AppColor.primary),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ],
    );
  }

  Widget _buildEmployeeTypeButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          Get.snackbar("Submitting", "Submitting the loan form...",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.1),
              colorText: Colors.green);
          _storeLoanFormData();
        }
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColor.textLight),
      ),
    );
  }

  void _storeLoanFormData() async {
    try {
      String id = loginController.agentId.value;
      String? agentName = await getAgentName(id);

      print(id);
      print('Agent name: $agentName');
      final LoanModel loan = LoanModel(
        userName: controller.firstNameController.text.trim(),
        phone: controller.phoneNumberController.text.trim(),
        email: controller.emailController.text.trim(),
        aadharNo: controller.aadharCardController.text.trim(),
        panNo: controller.panCardController.text.trim(),
        address: controller.addressController.text.trim(),
        panImg: loanFormController.panImg.value,
        userId: '',
        agentName: agentName ?? '',
        loanType: widget.title,
        aadharImg: loanFormController.aadharImg.value,
        image: loanFormController.image.value,
        date: DateTime.now(),
        agentId: loginController.agentId.value,
      );

      LoginController.instance.createLoan(loan);
    } catch (error) {
      print('Error storing loan data: $error');
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    }
  }

  Widget _buildCompanyTypeButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () {
        if (formKey.currentState!.validate()) {
          if (_pickedFile == null || _pickedFile2 == null) {
            const snackBar = SnackBar(
              content: Text(
                'Please select both Aadhar Card and PAN Card photos',
                style: TextStyle(color: AppColor.textLight),
              ),
              backgroundColor: AppColor.errorbar,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else {
            const snackBar = SnackBar(
              content: Text(
                'Submitting Form',
                style: TextStyle(color: AppColor.textLight),
              ),
              backgroundColor: AppColor.primary,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Companyworker()),
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: AppColor.textLight),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String? hintText;
  final VoidCallback? onTap;
  final Widget? suffixWidget;
  final TextEditingController? controller;
  final String? regexPattern;
  final Color? iconColor;
  final Color? backgroundColor;

  const LabeledTextField({
    required this.label,
    this.hintText,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.controller,
    this.regexPattern,
    this.iconColor,
    this.backgroundColor,
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
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColor.textdivider,
              ),
            ),
            suffixIcon: icon != null
                ? InkWell(
                    onTap: onTap,
                    child: Icon(
                      icon,
                      color: iconColor ?? Theme.of(context).iconTheme.color,
                    ),
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
