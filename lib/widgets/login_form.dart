import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:intelligenz/core/services/auth/login_form_controller.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final LoginFormController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginFormController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    if (!controller.formKey.currentState!.validate()) return;

    final url = controller.urlController.text.trim();
    final email = controller.userIdController.text.trim();
    final password = controller.passwordController.text;

    await context.read<AuthCubit>().login(url, email, password);
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.dmSans(
        color: const Color(0xFF888888),
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Login successful!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Login to your account',
                  style: GoogleFonts.dmSans(
                    color: const Color(0xFF595959),
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),

                // URL
                TextFormField(
                  controller: controller.urlController,
                  decoration: _inputDecoration('URL'),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Enter URL';
                    final uriPattern = RegExp(
                      r'^https?:\/\/[\w.-]+(:\d+)?(\/)?$',
                    );
                    if (!uriPattern.hasMatch(value.trim())) {
                      return 'Enter a valid URL like https://example.com:port/';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // User ID
                TextFormField(
                  controller: controller.userIdController,
                  decoration: _inputDecoration('User ID'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter User ID' : null,
                ),
                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible,
                  decoration: _inputDecoration('Password').copyWith(
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          controller.togglePasswordVisibility(
                            () => setState(() {}),
                          );
                        });
                      },
                    ),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter password' : null,
                ),
                const SizedBox(height: 42),

                // Sign in Button
                SizedBox(
                  width: double.infinity,
                  height: 63,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _onLoginPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF43B6D6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32.35,
                        vertical: 17.03,
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Sign in',
                            style: GoogleFonts.dmSans(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
