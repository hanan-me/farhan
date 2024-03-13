import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'auth/Signup_Page.dart';
import 'new.dart';

class Phone_Verfication extends StatefulWidget {
  const Phone_Verfication({super.key});

  @override
  State<Phone_Verfication> createState() => _Phone_VerficationState();
}

class _Phone_VerficationState extends State<Phone_Verfication> {
  final phone = TextEditingController();
  @override
  void dispose() {
    phone.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: h * 0.1,
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: Lottie.asset(
                'animation/num.json',
                height: h * 0.3,
                repeat: true,
                reverse: true,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: w * 0.05, right: w * 0.05),
              child: SingleChildScrollView(
                reverse: true,
                physics: BouncingScrollPhysics(),
                child: Column(
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
                      "Sign into your account",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                    ),
                    SizedBox(
                      height: w * 0.07,
                    ),
                    SizedBox(
                      height: w * 0.04,
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
                          controller: phone,
                          decoration: InputDecoration(
                            hintText: "Phone",
                            prefixIcon:
                                Icon(Icons.phone, color: Colors.green[600]),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 1.0,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                    color: Colors.white, width: 1.0)),
                          ),
                        )),
                    SizedBox(
                      height: w * 0.07,
                    ),
                    GestureDetector(
                      onTap: () async {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phone.text,
                          verificationCompleted:
                              (PhoneAuthCredential credential) async {
                            await FirebaseAuth.instance
                                .signInWithCredential(credential);
                          },
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            }
                          },
                          codeSent:
                              (String verificationId, int? resendToken) async {
                            String smsCode = verificationId;
                            print(verificationId);
                            print(phone.text);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Get_Otp(
                                      verificationId: verificationId,
                                    )));
                            // Create a PhoneAuthCredential with the code
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: smsCode);
                            print(credential);

                            // Sign the user in (or link) with the credential
                            // await FirebaseAuth.instance.signInWithCredential(credential);
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      },
                      child: Container(
                          width: w * 0.35,
                          height: h * 0.06,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.green[600],
                          ),
                          child: Center(
                            child: Text(
                              "Get OTP",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          )),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
