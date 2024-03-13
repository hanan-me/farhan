import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:first/auth/Login_Page.dart';
import 'package:first/forget_password_con.dart';
import 'package:first/auth_controller.dart';

class ResetPasswordEmailSentScreen extends StatelessWidget {
  const ResetPasswordEmailSentScreen({super.key, required this.email});

  final String email;
  @override
  Widget build(BuildContext context) {
    // final Color? backgroundColor;
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      /// --App Bar
      // appBar: AppBar(
      //   backgroundColor: Colors.teal,
      //   leading: IconButton(onPressed:()=> Get.back(),icon: const Icon(Icons.arrow_back, color: Colors.white)),
      //   title: Text("Profile"),
      //   actions: [IconButton(onPressed:(){AuthController.instance.logOut();},icon: const Icon(Icons.logout_outlined, color: Colors.white))],
      // ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        child: Column(
          children: [
            SizedBox(height: h * 0.15,),
            Container(
              margin: const EdgeInsets.only(left: 15),
              child: Lottie.asset(
                'animation/animation.json',
                height: h * 0.3,
                repeat: true,
                reverse: true,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20,top: 10),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Password Reset Email Sent",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "password reset email link on your email.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: h * 0.05,),
                ],
              ),
            ),
            SizedBox(height: h * 0.03,),
            GestureDetector(
              onTap: () {
                Get.offAll(()=> const LoginPage());
              },
              child: const Center(
                child: Text(
                  "Done",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            SizedBox(height: h * 0.03,),
            RichText(text: TextSpan(
                children: [
                  TextSpan(
                      text: "Resend Email",
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 15,
                      ),
                      recognizer: TapGestureRecognizer()..onTap =()=>
                          ForgetPasswordController.instance.resendPasswordResetEmail(email)
                  )
                ]
            )),
          ],
        ),
      ),
    );
  }
}
