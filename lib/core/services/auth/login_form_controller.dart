import 'package:flutter/material.dart';

class LoginFormController {
  final TextEditingController urlController = TextEditingController();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  void togglePasswordVisibility(VoidCallback onChanged) {
    isPasswordVisible = !isPasswordVisible;
    onChanged();
  }

  void dispose() {
    urlController.dispose();
    userIdController.dispose();
    passwordController.dispose();
  }
}
