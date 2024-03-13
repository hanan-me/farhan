import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final numberController = TextEditingController();
  final cnicController = TextEditingController();
  final nationalityController = TextEditingController();
  final lastnameController = TextEditingController();
  final firstnameController = TextEditingController();

  final user = Get.find<AuthController>().currUser.value;

  void prepareEdit() {
    firstnameController.text = user!.fname!;
    lastnameController.text = user!.lname!;
    nationalityController.text = user!.national!;
    cnicController.text = user!.cnic!;
    emailController.text = user!.email!;
    numberController.text = user!.phone!;
  }

  void clearFields() {
    firstnameController.clear();
    lastnameController.clear();
    nationalityController.clear();
    cnicController.clear();
    emailController.clear();
    numberController.clear();
  }

  void updateUser() {
    var user = FirebaseAuth.instance.currentUser;
    final ref = FirebaseFirestore.instance.collection('Users');

    // Modify this line to include all the registration data
    ref.doc(user!.uid).update({
      "first_name": firstnameController.text,
      "last_name": lastnameController.text,
      "nationality": nationalityController.text,
      "cnic": cnicController.text,
      "email": emailController.text,
      "phone_num": numberController.text,
    }).then((value) {
      Get.snackbar("About Login", "message",
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Succcess",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "User Updated",
          ));
      clearFields();
      Get.find<AuthController>().getCurrentUserDetails();
    }).catchError((onError) {
      Get.snackbar("About Login", "message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            onError.toString(),
          ));
    });
  }

  @override
  void initState() {
    prepareEdit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back, color: Colors.greenAccent)),
          title: const Text("Edit Profile")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.4),
                        )
                      ]),
                  child: TextField(
                    controller: firstnameController,
                    decoration: InputDecoration(
                      hintText: "First Name ",
                      prefixIcon: Icon(Icons.person, color: Colors.green[600]),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.4),
                        )
                      ]),
                  child: TextField(
                    controller: lastnameController,
                    decoration: InputDecoration(
                      hintText: "Last Name",
                      prefixIcon: Icon(Icons.person, color: Colors.green[600]),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.4),
                        )
                      ]),
                  child: TextField(
                    controller: nationalityController,
                    decoration: InputDecoration(
                      hintText: "Nationality ",
                      prefixIcon:
                          Icon(Icons.add_home, color: Colors.green[600]),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.4),
                        )
                      ]),
                  child: TextField(
                    controller: cnicController,
                    decoration: InputDecoration(
                      hintText: "CNIC",
                      prefixIcon:
                          Icon(Icons.numbers_sharp, color: Colors.green[600]),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                            color: Colors.white,
                            width: 1.0,
                          )),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(
                              color: Colors.white, width: 1.0)),
                    ),
                  ),
                ),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: const Offset(1, 1),
                            color: Colors.grey.withOpacity(0.4),
                          )
                        ]),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Your Email",
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.green[600]),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0)),
                      ),
                    )),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            spreadRadius: 7,
                            offset: const Offset(1, 1),
                            color: Colors.grey.withOpacity(0.4),
                          )
                        ]),
                    child: TextField(
                      controller: numberController,
                      decoration: InputDecoration(
                        hintText: "Your Phone",
                        prefixIcon:
                            Icon(Icons.phone_android, color: Colors.green[600]),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            )),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0)),
                      ),
                    )),
                SizedBox(
                  height: h * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          spreadRadius: 7,
                          offset: const Offset(1, 1),
                          color: Colors.grey.withOpacity(0.4),
                        )
                      ]),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    updateUser();
                  },
                  child: Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 4,
                              offset: const Offset(1, 1),
                              color: Colors.grey.withOpacity(0.5),
                            )
                          ],
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.green,
                              Colors.green,
                            ],
                          )
                          // image: DecorationImage(
                          //   image: AssetImage(
                          //       "img/btn.jpg"
                          //   ),
                          //   fit: BoxFit.cover,
                          // )
                          ),
                      child: const Center(
                        child: Text(
                          "Update",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
