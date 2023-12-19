import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finkin_credential/models/agent_model/agent_model.dart';
import 'package:finkin_credential/models/loan_model/loan_model.dart';
import 'package:finkin_credential/repository/agent_repository/agent_repository.dart';
import 'package:finkin_credential/res/app_color/app_color.dart';
import 'package:finkin_credential/res/image_asset/image_asset.dart';
import 'package:finkin_credential/shared/widgets/Account_Tracking_Widget/accout_track.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/account_controller.dart';
import '../../controller/login_controller.dart';
import '../verification_screen/verification_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});
  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _auth = FirebaseAuth.instance;
  File? _selectedImage;
  final AccountController accountController = Get.put(AccountController());
  final LoginController loginController = Get.put(LoginController());
  final AgentRepository agentRepository = Get.put(AgentRepository());
  @override
  void initState() {
    super.initState();
    final id = loginController.agentId.value;
    (loginController.isUserSelected
        ? accountController.fetchUserDetails
        : accountController.fetchAgentDetails)(id);
  }

  Future<void> _uploadImageToFirestore(File imageFile, String agentId) async {
    try {
      String imageName = basename(imageFile.path);
      String storagePath = 'Agents/$agentId/$imageName';

      Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();
      await _updateFieldInFirestore('ImageUrl', imageUrl, agentId: agentId);

      print('Image uploaded successfully. Image URL: $imageUrl');
    } catch (e) {
      print('Error uploading image to Firestore: $e');
    }
  }

  Future<void> _uploadUserImageToFirestore(
      File imageFile, String userId) async {
    try {
      String imageName = basename(imageFile.path);
      String storagePath = 'Loan/$userId/$imageName';

      Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
      String imageUrl = await taskSnapshot.ref.getDownloadURL();

      await _updateUserFieldInFirestore('UserImage', imageUrl, userId: userId);

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
      final agentId = loginController.agentId.value;
      await (loginController.isUserSelected
          ? _uploadUserImageToFirestore(_selectedImage!, agentId)
          : _uploadImageToFirestore(_selectedImage!, agentId));
      print('Image selected and uploaded to Firestore');
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

  Future<List<String?>> _getAgentData(String agentId) async {
    try {
      String? agentName = await getAgentName(agentId);
      String? agentImage = await getAgentImage(agentId);
      return [agentName, agentImage];
    } catch (e) {
      print('Error fetching agent data: $e');
      return ["Default Name", null];
    }
  }

  Future<String?> getAgentImage(String agentId) async {
    try {
      print("Fetching agent image with ID: $agentId");
      final AgentModel? agent = await agentRepository.getAgentById(agentId);
      print("Fetched agent: $agent");
      return agent?.imageUrl;
    } catch (e) {
      print('Error fetching agent image: $e');
      return null;
    }
  }

//user
  Future<String?> getUserName(String agentId) async {
    try {
      print("Fetching agent with ID: $agentId");
      final LoanModel? loan = await agentRepository.getUserById(agentId);
      print("Fetched agent: $loan");
      return loan?.userName;
    } catch (e) {
      print('Error fetching agent name: $e');
      return null;
    }
  }

  Future<List<String?>> _getUserData(String agentId) async {
    try {
      String? agentName = await getUserName(agentId);
      String? agentImage = await getUserImage(agentId);
      return [agentName, agentImage];
    } catch (e) {
      print('Error fetching agent data: $e');
      return ["Default Name", null];
    }
  }

  Future<String?> getUserImage(String agentId) async {
    try {
      print("Fetching agent image with ID: $agentId");
      final LoanModel? Loan = await agentRepository.getUserById(agentId);
      print("Fetched agent: $Loan");
      return Loan?.userImage;
    } catch (e) {
      print('Error fetching agent image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.infinity,
        color: AppColor.textLight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 14,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                child: Container(
                  color: AppColor.textLight,
                  child: SingleChildScrollView(
                    child: FutureBuilder<List<String?>>(
                        future: loginController.isUserSelected == false
                            ? _getAgentData(loginController.agentId.value)
                            : _getUserData(loginController.agentId.value),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            String agentName =
                                snapshot.data?[0] ?? "Default Name";
                            String? agentImage = snapshot.data?[1];

                            return Column(
                              children: [
                                Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    GestureDetector(
                                      onTap: _openGallery,
                                      child: Container(
                                        child: agentImage != null
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    _selectedImage != null
                                                        ? FileImage(
                                                                _selectedImage!)
                                                            as ImageProvider
                                                        : NetworkImage(
                                                            agentImage),
                                                radius: 80,
                                              )
                                            : const CircleAvatar(
                                                backgroundImage:
                                                    AssetImage(ImageAsset.pop),
                                                radius: 80,
                                              ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _openGallery,
                                      child: const Padding(
                                        padding: EdgeInsets.all(11.0),
                                        child: Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.black,
                                          size: 40.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 25),
                                Text(
                                  agentName,
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Column(
                                    children: [
                                      Accounttrack(
                                        icon: ImageAsset.user,
                                        text: "My Account",
                                        press: () {
                                          _showAccountInfoBottomSheet(context);
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      Accounttrack(
                                          icon: ImageAsset.settings,
                                          text: "Settings",
                                          press: () {
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //     builder: (context) =>
                                            //         const settingPage(),
                                            //   ),
                                            // );
                                          }),
                                      const SizedBox(height: 10),
                                      Accounttrack(
                                        icon: ImageAsset.contact,
                                        text: "Contact Us",
                                        press: () {
                                          _showContactInfoBottomSheet(context);
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      Accounttrack(
                                        icon: ImageAsset.logout,
                                        text: "Log Out",
                                        press: () {
                                          _showLogoutConfirmationDialog(
                                              context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print("User signed out");
      Get.offAll(VerificationScreen());
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Logout Confirmation",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("Do you want to Log Out?"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: AppColor.primary,
                      ),
                      child: const Text("No"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: AppColor.primary,
                      ),
                      child: const Text("Yes"),
                      onPressed: () {
                        _signOut();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAccountInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [AppColor.combination, AppColor.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Container(
                        height: 5,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    title: TextField(
                      controller: TextEditingController(
                          text: accountController.fullName.value),
                      onChanged: (value) {
                        accountController.fullName.value = value;
                        _updateFieldInFirestore('Name', value,
                            agentId: loginController.agentId.value);
                      },
                      decoration: const InputDecoration(
                        labelText: "Full Name",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                    title: TextField(
                      controller: TextEditingController(
                          text: accountController.location.value),
                      onChanged: (value) {
                        accountController.location.value = value;
                        _updateFieldInFirestore('Address', value,
                            agentId: loginController.agentId.value);
                      },
                      decoration: const InputDecoration(
                        labelText: "Location",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.white),
                    title: TextField(
                      controller: TextEditingController(
                          text: accountController.email.value),
                      onChanged: (value) {
                        accountController.email.value = value;
                        _updateFieldInFirestore('Email', value,
                            agentId: loginController.agentId.value);
                      },
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.credit_card,
                      color: Colors.white,
                    ),
                    title: TextField(
                      controller: TextEditingController(
                          text: accountController.aadharCardNumber.value),
                      onChanged: (value) {
                        accountController.aadharCardNumber.value = value;
                        _updateFieldInFirestore('Aadhar', value,
                            agentId: loginController.agentId.value);
                      },
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Aadhar Card Number",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.description,
                      color: Colors.white,
                    ),
                    title: TextField(
                      controller: TextEditingController(
                          text: accountController.panCardNumber.value),
                      onChanged: (value) {
                        // Update the value in the GetX controller
                        accountController.panCardNumber.value = value;
                        // Update the corresponding field in Firestore
                        _updateFieldInFirestore('Pan', value,
                            agentId: loginController.agentId.value);
                      },
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Pan Card Number",
                        labelStyle: TextStyle(color: Colors.white),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white),
                      cursorColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showContactInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        double screenHeight = MediaQuery.of(context).size.height;
        return SingleChildScrollView(
          child: Container(
            height: screenHeight * 0.9,
            // height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.transparent,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                gradient: LinearGradient(
                  colors: [AppColor.combination, AppColor.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      height: 5,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/education.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                "Address",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "Beeri, Mangalore 581707",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Icon(
                                Icons.email,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                "Email",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 30),
                        child: Text(
                          "sadiyaayub16@gmai.com",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.textLight,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColor.textdivider,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(
                                "Contact Us",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.person_2_outlined,
                                color: AppColor.primary,
                              ),
                              title: const Text(
                                "8217696772",
                                style: TextStyle(color: AppColor.textdivider),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.message,
                                      color: AppColor.primary,
                                    ),
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.phone_outlined,
                                      color: AppColor.primary,
                                    ),
                                    onTap: () {
                                      _makePhoneCall("6363052051");
                                    },
                                  ),
                                ],
                              ),
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.person_2_outlined,
                                color: AppColor.primary,
                              ),
                              title: const Text(
                                "6363052051",
                                style: TextStyle(color: AppColor.textdivider),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.chat,
                                      color: AppColor.primary,
                                    ),
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    child: const Icon(
                                      Icons.phone_outlined,
                                      color: AppColor.primary,
                                    ),
                                    onTap: () {
                                      _makePhoneCall("6363052051");
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _makePhoneCall(String phoneNumber) async {
    try {
      Uri url = Uri.parse("tel:+91$phoneNumber");
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        print("Could not launch $url");
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _updateFieldInFirestore(String fieldName, String value,
      {required String agentId}) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Agents')
          .where('AgentId', isEqualTo: agentId)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocId = userQuerySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Agents')
            .doc(userDocId)
            .update({
          fieldName: value,
        });
        print("Field $fieldName updated in Firestore for agentId: $agentId");
      } else {
        print("User with agentId $agentId not found");
      }
    } catch (e) {
      print("Error updating field $fieldName in Firestore: $e");
    }
  }

  Future<void> _updateUserFieldInFirestore(String fieldName, String value,
      {required String userId}) async {
    try {
      final userQuerySnapshot = await FirebaseFirestore.instance
          .collection('Loan')
          .where('UserId', isEqualTo: userId)
          .get();

      if (userQuerySnapshot.docs.isNotEmpty) {
        final userDocId = userQuerySnapshot.docs.first.id;
        await FirebaseFirestore.instance
            .collection('Loan')
            .doc(userDocId)
            .update({
          fieldName: value,
        });
        print("Field $fieldName updated in Firestore for agentId: $userId");
      } else {
        print("User with agentId $userId not found");
      }
    } catch (e) {
      print("Error updating field $fieldName in Firestore: $e");
    }
  }
}
