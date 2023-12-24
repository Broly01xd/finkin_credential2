import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/controller/account_controller.dart';
import 'package:finkin_credential/controller/login_controller.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/repository/agent_repository/agent_repository.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../home_screen/user_nav.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final AccountController accountController = Get.put(AccountController());
  final LoginController loginController = Get.put(LoginController());
  final AgentRepository agentRepository = Get.put(AgentRepository());

  File? _selectedImage;

  Future<void> _uploadImageToFirestore(File imageFile, String docId) async {
    try {
      String imageName = basename(imageFile.path);
      String storagePath = 'Loan/$docId/$imageName';

      Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      await _updateFieldInFirestore('UserImage', imageUrl, docId: docId);

      print('Image uploaded successfully. Image URL: $imageUrl');
    } catch (e) {
      print('Error uploading image to Firestore: $e');
    }
  }

  void _openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      await _uploadImageToFirestore(
          _selectedImage!, loginController.agentId.value);

      print('Image selected and uploaded to Firestore');
    }
  }

  Future<List<String?>> _getAgentData(String docId) async {
    try {
      String? agentName = await getAgentName(docId);
      String? agentImage = await getAgentImage(docId);
      return [agentName, agentImage];
    } catch (e) {
      print('Error fetching agent data: $e');
      return ["Default Name", null];
    }
  }

  Future<String?> getAgentImage(String docId) async {
    try {
      print("Fetching agent image with ID: $docId");
      final LoanModel? loan = await agentRepository.getUserById(docId);
      print("Fetched agent: $loan");
      return loan?.userImage;
    } catch (e) {
      print('Error fetching agent image: $e');
      return null;
    }
  }

  Future<String?> getAgentName(String docId) async {
    try {
      print("Fetching agent with ID: $docId");
      final LoanModel? loan = await agentRepository.getUserById(docId);
      print("Fetched agent: $loan");
      return loan?.userName;
    } catch (e) {
      print('Error fetching agent name: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<List<String?>>(
          future: _getAgentData(loginController.agentId.value),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<String?> agentData = snapshot.data ?? ["Default Name", null];
              String agentName = agentData[0] ?? "Default Name";
              String? agentImage = agentData[1];

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _openGallery,
                    child: CircleAvatar(
                      radius: 100.0,
                      backgroundColor: Colors.transparent,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          _selectedImage != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(130.0),
                                  child: Image.file(
                                    _selectedImage!,
                                    width: 260.0,
                                    height: 260.0,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : (agentImage != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(130.0),
                                      child: Image.network(
                                        agentImage,
                                        width: 260.0,
                                        height: 260.0,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      width: 260.0,
                                      height: 260.0,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/money.jpg'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )),
                          const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Icon(
                              Icons.camera_alt,
                              size: 60.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    agentName,
                    style: const TextStyle(
                      color: AppColor.primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: const EdgeInsets.only(right: 16.0, top: 216.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserNav(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.primary,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            color: AppColor.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _updateFieldInFirestore(String fieldName, String value,
      {required String docId}) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Loan')
          .where('UserId', isEqualTo: docId)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocId = userQuerySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Loan')
            .doc(userDocId)
            .update({
          fieldName: value,
        });
        print("Field $fieldName updated in Firestore for agentId: $docId");
      } else {
        print("User with agentId $docId not found");
      }
    } catch (e) {
      print("Error updating field $fieldName in Firestore: $e");
    }
  }
}
