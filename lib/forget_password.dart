import 'package:first/forget_password_con.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';

import 'forgetotp.dart';
import 'new.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Form(
        child: Column(
          children: [
            SizedBox(
              height: h * 0.1,
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: Lottie.asset(
                'animation/otp.json',
                height: h * 0.3,
                repeat: true,
                reverse: true,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Forget Password",
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Enter your email below.",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(
                    height: h * 0.05,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 7,
                              offset: Offset(1, 1),
                              color: Colors.grey.withOpacity(0.4),
                            )
                          ]),
                      child: TextField(
                        controller: controller.email,
                        decoration: InputDecoration(
                          hintText: "Your Email",
                          prefixIcon: Icon(Icons.phone_android,
                              color: Colors.green[600]),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              )),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 1.0)),
                        ),
                      )),
                  SizedBox(
                    height: h * 0.02,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.sendPasswordResetEmail(),
                child: const Text('Next'),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom)),
            // SizedBox(
            //   height: h * 0.03,
            // ),
            // GestureDetector(
            //   onTap: () {
            //     Get.to(() => Forget_Otp(verificationId: '',));
            //   },
            //   // child: Container(
            //   //     width: w * 0.4,
            //   //     height: h * 0.055,
            //   //     decoration: BoxDecoration(
            //   //         borderRadius: BorderRadius.circular(30),
            //   //         color: Colors.green[600]),
            //   //     child: Center(
            //   //       child: Text(
            //   //         "Next",
            //   //         style: TextStyle(
            //   //           fontSize: 22,
            //   //           color: Colors.white,
            //   //         ),
            //   //       ),
            //   //     )),
            // ),
          ],
        ),
      ),
    );
  }
}
