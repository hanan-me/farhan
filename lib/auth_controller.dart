// import 'dart:js';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first/Dashborad.dart';
import 'package:first/Models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'user_dash.dart';
import 'auth/Login_Page.dart';
import 'auth/Signup_Page.dart';
import 'SplashScreen.dart';
import 'getStarted.dart';

class AuthController extends GetxController {
  //AuthController.instance..
  static AuthController instance = Get.find();
  //email, password, name ....
  late Rx<User?> _user;
  final auth = FirebaseAuth.instance;
  var verificationId = ''.obs;

  final cnics = <String>[];

  @override
  void onInit() {
    getAllCnic();
    super.onInit();
  }

  void getAllCnic() {
    cnics.clear();
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    ref.get().then((value) => {
          value.docs.forEach((element) {
            print("CNIC: ${element['cnic']}");
            cnics.add(element['cnic']);
          })
        });
  }
// Future<void> sendEmailVerification() async{
//     try{
//       await FirebaseAuth.instance.currentUser?.sendEmailVerification();
//     }on FirebaseAuthException catch(e){
//       // SnackBar(title: "Error", message: e.toString());
//     }catch(_){
//       // MLoaders.errorSnackBar(title: "Error", message: _.toString());
//     }
//   }

/// -- FORGET PASSWORD
  Future <void> sendPasswordResetEmail(String email) async{
    try{
      await auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      throw "Something went wrong!";
    }
  }


  //
  // Future<void> phone(String phoneNo) async {
  //   try {
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNo,
  //
  //       verificationCompleted: (credential) async {
  //         await auth.signInWithCredential(credential);
  //       },
  //       codeSent: (verificationId, resendToken) {
  //         print(phoneNo);
  //         this.verificationId.value = verificationId;
  //       },
  //       codeAutoRetrievalTimeout: (verificationId) {
  //         this.verificationId.value = verificationId;
  //       },
  //       verificationFailed: (e) {
  //         if (e.code == 'invalid-phone-number') {
  //           Get.snackbar('Error', 'The provided number is not valid');
  //         } else {
  //           print(phoneNo);
  //           Get.snackbar('Error', 'Verification failed. Please try again.');
  //         }
  //       },
  //     );
  //   } catch (e) {
  //     print("Firebase Phone Auth Error: $e");
  //     Get.snackbar('Error', 'Something went wrong. Please try again.');
  //   }
  // }

  //   Future<bool> verify(String otp) async{
  //   var credentials = await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId.value, smsCode: otp));
  //   return credentials.user != null ? true : false;
  // }
  void register(String email, String password, String fname, String lname,
      String nation, String num, String cnic) async {
    //validate the inputs
    if (fname.isEmpty ||
        lname.isEmpty ||
        nation.isEmpty ||
        num.isEmpty ||
        cnic.isEmpty) {
      Get.snackbar("About User", "message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "Fill all the fields",
          ));

      return;
    }
    if (cnics.contains(cnic.trim())) {
      Get.snackbar("About User", "message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "CNIC already exists!",
          ));

      return;
    }

    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                store(
                  fname,
                  lname,
                  nation,
                  num,
                  cnic,
                  email,
                  password,
                )
              });
    } catch (e) {
      Get.snackbar("About User", "message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Account creation failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: const Text(
            "Invalid Email or Password!",
          ));
    }
  }

  void store(
    String fname,
    String lname,
    String nation,
    String num,
    String cnic,
    String email,
    String password,
  ) async {
    var user = auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');

    // Modify this line to include all the registration data
    ref.doc(user!.uid).set({
      'first_name': fname,
      'last_name': lname,
      'nationality': nation,
      'cnic': cnic,
      'email': email,
      'phone_num': num,
      "status": "rejected",
      "verified": false,
    }).then((value) async {
      print("user details added");

      await logIn(email, password);
    }).catchError((onError) {
      print("Error adding user details");
    });
  }

  // getUserid(){
  //   authStateChanges = auth.authStateChanges();
  //   authStateChanges.listen((User? user) {
  //     _users.value = user;
  //     id = user!.uid;
  //     print("User id ${id}");
  //   });

  // }

  Future<void> logIn(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        if (auth.currentUser != null) {
          getCurrentUserDetails();
        }
      });

      // Get.offAll(() => const UserDash()
    } catch (e) {
      Get.snackbar("About Login", "message",
          backgroundColor: Colors.redAccent,
          snackPosition: SnackPosition.BOTTOM,
          titleText: const Text(
            "Login failed",
            style: TextStyle(color: Colors.white),
          ),
          messageText: Text(
            e.toString(),
          ));
    }
  }

//make an instance of the user model

  final currUser = Rxn<UserModel>();

  Future<void> getCurrentUserDetails() async {
    var user = auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('Users');
    ref
        .doc(user!.uid)
        .get()
        .then((value) => {
              if (value.data() != null)
                {
                  currUser.value = UserModel.fromJson(
                    value.data() as Map<String, dynamic>,
                  ),
                  print("Logged in User name ${currUser.value!.fname}"),
                },
            })
        .then((value) {
      Get.offAll(() => Home(
            title: currUser.value!.fname,
          ));
    });
  }

  void logOut() async {
    await auth.signOut();
  }
}
