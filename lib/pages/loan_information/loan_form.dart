import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/controller/loan_form_controller.dart';
import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/pages/home_screen/bottom_nav.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/agent_model/agent_model.dart';
import '../../repository/agent_repository/agent_repository.dart';

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
  XFile? _pickedFile3;
  XFile? _pickedFile4;
  XFile? _pickedFile5;
  XFile? _pickedFile6;
  DateTime? selectedDate;
  bool isVerified = false;
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
                  // _buildANameSection(),
                  _buildDateOfBirthSection(),
                  _buildAddressSection(),
                  _buildPinCodeAndNationalitySection(),
                  _buildAadharNumberSection(),
                  _buildAadharCardUploadSection(),
                  _builPanNumberSection(),
                  _buildPANCardUploadSection(),
                  _buildEmployeeTypeSection(),
                  _buildSubmitButton(),
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
            label2: '',
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
            label2: '',
          ),
        ),
      ],
    );
  }

  // Widget _buildANameSection() {
  //   return const ListTile(
  //     title: TextField(
  //       decoration: InputDecoration(
  //         labelStyle: TextStyle(color: Colors.black),
  //         focusedBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.black),
  //         ),
  //         enabledBorder: OutlineInputBorder(
  //           borderSide: BorderSide(color: Colors.transparent),
  //         ),
  //       ),
  //       style: TextStyle(color: Colors.white),
  //       cursorColor: Colors.white,
  //     ),
  //   );
  // }

  Widget _buildPhoneNumberSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Phone Number',
            regexPattern: LoanFormController.phoneNumberRegex,
            controller: controller.phoneNumberController,
            label2: '',
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
            label2: '',
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
            label2: '',
          ),
        ),
      ],
    );
  }

  Widget _buildVerificationButton() {
    return ElevatedButton(
      onPressed: () {
        // Add your verification logic here
        // Once verification is successful, set isVerified to true
        setState(() {
          isVerified = true;
          loanFormController.updatePermissionGranted(
              !loanFormController.getPermissionGranted());
        });
      },
      style: ElevatedButton.styleFrom(
        primary: AppColor.icon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isVerified)
            const Icon(
              Icons.check,
              color: AppColor.textLight,
            ),
          Text(
            isVerified ? 'Verified' : 'Give Access',
            style: TextStyle(color: AppColor.textLight),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCodeSection() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Permission Granted',
            controller: TextEditingController(
                text: loanFormController.getPermissionGranted().toString()),
            label2: '',
          ),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            Get.snackbar("Submitting", "Submitting the loan form...",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green.withOpacity(0.1),
                colorText: Colors.green);
            _storeLoanFormData();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNavBar(),
              ),
            );
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
            onTap: () => _selectDate(context), label2: '',
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
        label2: '',
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
            label2: '',
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
            label2: '',
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

  Future<String> _uploadItImgImageToFirestore(XFile pickedFile) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('ItImg_images/${DateTime.now().millisecondsSinceEpoch}');

      await storageReference.putFile(File(pickedFile.path));

      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<String> _uploadItImg2ImageToFirestore(XFile pickedFile) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('ItImg_images/${DateTime.now().millisecondsSinceEpoch}');

      await storageReference.putFile(File(pickedFile.path));

      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<String> _uploadForm16ImgImageToFirestore(XFile pickedFile) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('ItImg_images/${DateTime.now().millisecondsSinceEpoch}');

      await storageReference.putFile(File(pickedFile.path));

      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  Future<String> _uploadBankImgImageToFirestore(XFile pickedFile) async {
    try {
      final firebase_storage.Reference storageReference = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('ItImg_images/${DateTime.now().millisecondsSinceEpoch}');

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
            label2: '',
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
            label2: '',
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
              child: Row(
                children: [
                  Radio(
                    value: 'Self Employed',
                    groupValue: controller.employeeType.value,
                    onChanged: (value) {
                      setState(() {
                        controller.employeeType.value = value as String? ?? '';
                      });
                    },
                  ),
                  Text('Self Employed'),
                ],
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Row(
                children: [
                  Radio(
                    value: 'Company Worker',
                    groupValue: controller.employeeType.value,
                    onChanged: (value) {
                      setState(() {
                        controller.employeeType.value = value as String? ?? '';
                      });
                    },
                  ),
                  Text('Company Worker'),
                ],
              ),
            ),
          ],
        ),
        Visibility(
          visible: controller.employeeType.value == 'Company Worker',
          child: Column(
            children: [
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Monthly Income',
                label2: '',
                controller: controller.incomeController,
              ),
              _buildCompanyUploadSection(),
              _buildCompanyUpload2Section(),
            ],
          ),
        ),
        Visibility(
          visible: controller.employeeType.value == 'Self Employed',
          child: Column(
            children: [
              // Add the widgets you want to display for 'Self Employed'
              // For example:
              const SizedBox(height: 20),
              LabeledTextField(
                label: 'Monthly Income',
                label2: '',
                controller: controller.income2Controller,
              ),
              _buildSelfEmployUploadSection(),
              _buildSelfEmployUpload2Section(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyUpload2Section() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Upload Your Bank Statement (6 Months - 1 Year)',
            suffixWidget: _buildChooseFileButton(_pickedFile6, () async {
              final pickedFile6 =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile6 != null) {
                String imageUrl =
                    await _uploadBankImgImageToFirestore(pickedFile6);

                loanFormController.updateBankImgImageUrl(imageUrl);
                setState(() {
                  _pickedFile6 = pickedFile6;
                });
              }
            }),
            label2: '',
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyUploadSection() {
    return Row(
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: LabeledTextField(
            label2: '',
            label: 'Please Upload Your Form 16',
            suffixWidget: _buildChooseFileButton(_pickedFile5, () async {
              final pickedFile5 =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile5 != null) {
                String imageUrl =
                    await _uploadForm16ImgImageToFirestore(pickedFile5);

                loanFormController.updateForm16ImgImageUrl(imageUrl);
                setState(() {
                  _pickedFile5 = pickedFile5;
                });
              }
            }),
          ),
        ),
      ],
    );
  }

//self employ
  Widget _buildSelfEmployUploadSection() {
    return Row(
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: LabeledTextField(
            label2: 'Please Upload IT Return of  2 year',
            label: 'Please Upload IT Return of  2 year \n First Year',
            suffixWidget: _buildChooseFileButton(_pickedFile3, () async {
              final pickedFile3 =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile3 != null) {
                String imageUrl =
                    await _uploadItImgImageToFirestore(pickedFile3);

                loanFormController.updateItImgImageUrl(imageUrl);
                setState(() {
                  _pickedFile3 = pickedFile3;
                });
              }
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSelfEmployUpload2Section() {
    return Row(
      children: [
        Expanded(
          child: LabeledTextField(
            label: 'Second Year',
            suffixWidget: _buildChooseFileButton(_pickedFile4, () async {
              final pickedFile4 =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              if (pickedFile4 != null) {
                String imageUrl =
                    await _uploadItImg2ImageToFirestore(pickedFile4);

                loanFormController.updateItImg2ImageUrl(imageUrl);
                setState(() {
                  _pickedFile4 = pickedFile4;
                });
              }
            }),
            label2: '',
          ),
        ),
      ],
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
        isGranted: loanFormController.getPermissionGranted(),
        form16img: loanFormController.form16Img.value,
        bankImg: loanFormController.bankImg.value,
        income: controller.incomeController.text.trim(),
        itReturnImg: loanFormController.itImg.value,
        secondImg: loanFormController.itImg2.value,
        monthlyIncome: controller.income2Controller.text.trim(),
      );
      await FirebaseFirestore.instance
          .collection('phoneNumberCollection')
          .doc(controller.phoneNumberController.text.trim())
          .set(
        {
          'phoneNumber': controller.phoneNumberController.text.trim(),
        },
        SetOptions(merge: true),
      );

      LoginController.instance.createLoan(loan);
      setState(() {
        _pickedFile = null;
        _pickedFile2 = null;
        _pickedFile3 = null;
        _pickedFile4 = null;
        _pickedFile5 = null;
        _pickedFile6 = null;
      });
      controller.firstNameController.clear();
      controller.phoneNumberController.clear();
      controller.emailController.clear();
      controller.aadharCardController.clear();
      controller.panCardController.clear();
      controller.addressController.clear();
      controller.pinController.clear();
      controller.nationalityController.clear();
      controller.incomeController.clear();
      controller.income2Controller.clear();
    } catch (error) {
      print('Error storing loan data: $error');
      Get.snackbar("Error", "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
    }
  }
}

class LabeledTextField extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String label2;
  final String? hintText;
  final VoidCallback? onTap;
  final Widget? suffixWidget;
  final TextEditingController? controller;
  final String? regexPattern;
  final Color? iconColor;
  final Color? backgroundColor;
  final ValueChanged<String>? onChanged;

  const LabeledTextField({
    required this.label,
    required this.label2,
    this.hintText,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.controller,
    this.regexPattern,
    this.iconColor,
    this.backgroundColor,
    this.onChanged,
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
          onChanged: onChanged,
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
