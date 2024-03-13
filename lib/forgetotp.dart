// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:first/phone_verification.dart';
// import 'package:first/update.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// import 'package:lottie/lottie.dart';


// class Forget_Otp extends StatefulWidget {
//   final String verificationId;
//   const Forget_Otp({super.key , required this.verificationId});

//   @override
//   State<Forget_Otp> createState() => _Forget_OtpState();
// }

// class _Forget_OtpState extends State<Forget_Otp> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   final otpController = TextEditingController();


//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     var code="";
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(height: h*0.09,),
//           Container(
//             margin: const EdgeInsets.only(top: 0),
//             child: Lottie.asset(
//               'animation/otp.json',
//               height: h * 0.3,
//               repeat: true,
//               reverse: true,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Text(

//                   "OTP",
//                   style: TextStyle(
//                     fontSize: 40,
//                     color: Colors.black87,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: h * 0.01,),
//                 Text(
//                   "OTP Verification",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.black87,
//                   ),
//                 ),
//                 SizedBox(height: h * 0.05,),
//               ],
//             ),
//           ),
//           SizedBox(height: h * 0.04,),
//           OtpTextField(
//             numberOfFields: 6,
//             // controller: otpController.text,
//             fillColor: Colors.teal.withOpacity(0.1),
//             filled: true,
//             keyboardType: TextInputType.numberWithOptions(),
//             onCodeChanged: (value){
//               code = value;
//             },
//           ),
//           SizedBox(height: h * 0.05,),
//           GestureDetector(
//             onTap: () async {
//               //
//               // PhoneAuthCredential credential =
//               // PhoneAuthProvider.credential(
//               //     verificationId: widget.verificationId, smsCode: code);
//               // try {
//               //
//               //
//               //
//                 // await auth.signInWithCredential(credential);
//               //   Get.to(()=> basicDetails());
//               // }
//               // catch(e){
//               //   print("wrong otp");
//               // }
//               Get.to(()=> Create_Password());

//             },
//             child: Container(
//                 width: w * 0.4,
//                 height: h * 0.055,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(30),
//                   color: Colors.green[600],
//                 ),
//                 child: Center(
//                   child: Text(
//                     "Next",
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 )
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
