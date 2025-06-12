import 'package:flutter/material.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/widgets/login_form.dart';
import 'package:intelligenz/widgets/reusable_app_bar.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: klBackgroundColor,
      appBar: const ReusableAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const SizedBox(height: 89.89), const LoginForm()],
          ),
        ),
      ),
    );
  }
}
