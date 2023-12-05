import 'dart:io';
import 'package:finkin_credential/pages/home_screen/bottom_nav.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelfWorker extends StatefulWidget {
  const SelfWorker({Key? key}) : super(key: key);

  @override
  State<SelfWorker> createState() => _SelfWorkerState();
}
//agentform
class _SelfWorkerState extends State<SelfWorker> {
  bool isPhoneNumberVerified = false;
  XFile? _pickedFile;
  XFile? _pickedFile2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Employment Information'),
                const SizedBox(height: 20),
                const LabeledTextField(
                  label: 'Monthly Income',
                  label2: '',
                ),
                const SizedBox(height: 20),
                _buildAadharCardUploadSection(),
                const SizedBox(height: 10),
                _buildPANCardUploadSection(),
                const SizedBox(
                  height: 10,
                ),
                _buildSubmitButton(),
              ],
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

  Widget _buildAadharCardUploadSection() {
    return Row(
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: LabeledTextField(
            label2: 'Please Upload IT Return of  2 year',
            label: 'First Year',
            suffixWidget: _buildChooseFileButton(_pickedFile, () async {
              final pickedFile =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                _pickedFile = pickedFile;
              });
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
            label: 'Second Year',
            suffixWidget: _buildChooseFileButton(_pickedFile2, () async {
              final pickedFile2 =
                  await ImagePicker().pickImage(source: ImageSource.gallery);
              setState(() {
                _pickedFile2 = pickedFile2;
              });
            }),
            label2: '',
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
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChooseFileButton(XFile? pickedFile, VoidCallback onPressed) {
    return Row(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.all(21),
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
                  child: const Text('View Image'),
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

  Widget _buildSubmitButton() {
    return Center(
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BottomNavBar()),
            );
          },
          style: ElevatedButton.styleFrom(
            primary: AppColor.primary,
            padding: const EdgeInsets.symmetric(vertical: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: const Text('Submit', style: TextStyle(fontSize: 16,color: AppColor.textLight)),
        ),
      ),
    );
  }
}

class LabeledTextField extends StatelessWidget {
  final IconData? icon;
  final String label;
  final String label2;
  final VoidCallback? onTap;
  final Widget? suffixWidget;
  final TextEditingController? controller;

  const LabeledTextField({
    required this.label,
    this.onTap,
    this.icon,
    this.suffixWidget,
    this.controller,
    required this.label2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label2,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
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
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
