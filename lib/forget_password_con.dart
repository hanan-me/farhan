import 'package:flutter/material.dart';

import '../auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../password_reset_email_sent.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();

  /// Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      /// --any loader
      /// --check connection
      await AuthController.instance.sendPasswordResetEmail(email.text.trim());

      // Show snackbar to indicate that the email link has been sent
      Get.snackbar(
        'Email Sent',
        'Email Link Sent to Reset your Password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      /// -- Redirect
      Get.to(() => ResetPasswordEmailSentScreen(email: email.text.trim()));
    } catch (e) {
      // MLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      /// --any loader
      /// --check connection
      await AuthController.instance.sendPasswordResetEmail(email);

      // Show snackbar to indicate that the email link has been resent
      Get.snackbar(
        'Email Resent',
        'Email Link Sent Again to Reset your Password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // MLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
