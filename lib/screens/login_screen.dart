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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 60,
                    ), // Reduced from 89.89 for better spacing
                    LoginForm(),
                    // Add additional spacing if needed
                    SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
