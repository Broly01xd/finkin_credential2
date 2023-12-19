import 'dart:io';

import 'package:finkin_credential/controller/agent_form_controller.dart';
import 'package:finkin_credential/models/agent_model/agent_model.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/login_controller.dart';

class AgentForm extends StatefulWidget {
  const AgentForm({Key? key, required String agentId}) : super(key: key);

  @override
  State<AgentForm> createState() => _AgentFormState();
}

class _AgentFormState extends State<AgentForm> {
  File? _selectedImage;
  final formKey = GlobalKey<FormState>();
  final AgentFormController controller = Get.put(AgentFormController());
  final LoginController loginController = Get.put(LoginController());
  bool isImageUploaded = false;
  String imageValidationError = '';
  final AgentFormController agentFormController = Get.find();

  Future<void> pickImageFromGallery() async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  bool isFormValid() {
    // Check if form details are filled and image is fetched
    return formKey.currentState?.validate() ?? false && isImageUploaded;
  }

  Future<bool> uploadImageToFirebase() async {
    if (_selectedImage != null) {
      try {
        final firebase_storage.Reference storageRef = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('agent_images/${DateTime.now().millisecondsSinceEpoch}.jpg');

        final firebase_storage.UploadTask uploadTask =
            storageRef.putFile(_selectedImage!);

        final firebase_storage.TaskSnapshot downloadSnapshot =
            await uploadTask.whenComplete(() => null);

        final String imageUrl = await downloadSnapshot.ref.getDownloadURL();

        setState(() {
          agentFormController.imageUrl.value = imageUrl;
          isImageUploaded = true;
          imageValidationError = '';
        });
        return true;
      } catch (e) {
        print('Error uploading image: $e');
        setState(() {
          imageValidationError = 'Error uploading image. Please try again.';
        });
        return false;
      }
    } else {
      setState(() {
        imageValidationError = 'Please select an image.';
      });
      return false; // Return false if no image is selected
    }
  }

  bool isButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          toolbarHeight: 125.0,
          backgroundColor: AppColor.textLight,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Here  To  Get \n Welcome!',
                style: TextStyle(
                  color: AppColor.primary,
                  fontSize: 26,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 90),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        InkWell(
                          onTap: () => pickImageFromGallery(),
                          child: CircleAvatar(
                            backgroundImage: (_selectedImage != null
                                    ? FileImage(_selectedImage!)
                                    : (agentFormController.imageUrl.isNotEmpty
                                        ? NetworkImage(
                                            agentFormController.imageUrl.value)
                                        : const AssetImage(
                                            'assets/images/image.png')))
                                as ImageProvider<Object>?,
                            radius: 40,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColor.textLight,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                LabeledTextField(
                  label: 'Agent Type',
                  hintText: 'Agent Type',
                  controller: TextEditingController(
                    text: agentFormController.selectedAgentType.value,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                LabeledTextField(
                  label: 'Enter First Name',
                  hintText: 'Enter First Name',
                  regexPattern: AgentFormController.nameRegex,
                  controller: controller.firstNameController,
                ),
                const SizedBox(
                  height: 5,
                ),
                LabeledTextField(
                  label: 'Enter Last Name',
                  hintText: 'Enter Last Name',
                  regexPattern: AgentFormController.nameRegex,
                  controller: controller.lastNameController,
                ),
                const SizedBox(
                  height: 5,
                ),
                LabeledTextField(
                  label: 'Enter Phone Number',
                  hintText: 'Enter Phone Number',
                  regexPattern: AgentFormController.phoneNumberRegex,
                  controller: controller.phoneNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                ),
                const SizedBox(
                  height: 5,
                ),
                LabeledTextField(
                  label: 'Enter Your Aadhar card Number',
                  hintText: 'Enter Your Aadhar card Number',
                  regexPattern: AgentFormController.aadharCardRegex,
                  controller: controller.aadharCardController,
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                ),
                const SizedBox(
                  height: 10,
                ),
                LabeledTextField(
                  label: 'Enter Your Pan card Number',
                  hintText: 'Enter Your Pan card Number',
                  regexPattern: AgentFormController.panCardRegex,
                  controller: controller.panCardController,
                ),
                const SizedBox(
                  height: 10,
                ),
                LabeledTextField(
                  label: 'Enter Your Email Id',
                  hintText: 'Enter Your Email Id',
                  regexPattern: AgentFormController.emailRegex,
                  controller: controller.emailController,
                ),
                const SizedBox(
                  height: 10,
                ),
                LabeledTextField(
                  label: 'Enter Your Address',
                  hintText: 'Enter Your Address',
                  regexPattern: AgentFormController.addressRegex,
                  controller: controller.addressController,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      backgroundColor: isButtonPressed
                          ? AppColor.textdivider
                          : AppColor.primary,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: AppColor.textLight,
                      ),
                      onPressed: () async {
                        if (!isButtonPressed) {
                          bool isFormValidated = isFormValid();
                          bool isImageSelected = _selectedImage != null;

                          if (isFormValidated && isImageSelected) {
                            isButtonPressed = true;
                            setState(() {});

                            bool isImageUploadSuccessful =
                                await uploadImageToFirebase();

                            if (isImageUploadSuccessful) {
                              const snackBar = SnackBar(
                                content: Text(
                                  'Submitting Form',
                                  style: TextStyle(color: AppColor.textLight),
                                ),
                                backgroundColor: AppColor.primary,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);

                              // Rest of your code for form submission
                              final agent = AgentModel(
                                name:
                                    controller.firstNameController.text.trim(),
                                phone: controller.phoneNumberController.text
                                    .trim(),
                                email: controller.emailController.text.trim(),
                                aadhar:
                                    controller.aadharCardController.text.trim(),
                                pan: controller.panCardController.text.trim(),
                                address:
                                    controller.addressController.text.trim(),
                                agentId: loginController.agentId.value,
                                agentType:
                                    controller.selectedAgentType.string.trim(),
                                isFormFilled: true,
                                imageUrl: agentFormController.imageUrl.value,
                              );

                              LoginController.instance.createAgent(agent);
                            } else {
                              SnackBar snackBar = const SnackBar(
                                content: Text(
                                  'Error uploading image. Please try again.',
                                  style: TextStyle(color: AppColor.textLight),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          } else {
                            if (!isImageSelected) {
                              SnackBar snackBar = const SnackBar(
                                content: Text(
                                  'Please Choose Image',
                                  style: TextStyle(color: AppColor.textLight),
                                ),
                                backgroundColor: Colors.red,
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
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
  // final TextInputType? keyboardType5;
  final TextInputType? keyboardType;
  final int? maxLength;
  final String? regexPattern;

  const LabeledTextField({
    required this.label,
    this.hintText,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.controller,
    this.regexPattern,
    //  this.keyboardType5,
    this.keyboardType,
    this.maxLength,
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
          readOnly: label == 'Agent Type',
          keyboardType: keyboardType,
          inputFormatters: [
            LengthLimitingTextInputFormatter(
                maxLength), // Set the maximum length
          ],
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
