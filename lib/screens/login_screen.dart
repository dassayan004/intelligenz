import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 66, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 140,
                height: 46.11,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Intelli',
                              style: GoogleFonts.secularOne(
                                color: Color(0xFFEB7813),
                                fontSize: 26.01,
                                height: 0.05,
                              ),
                            ),
                            TextSpan(
                              text: 'genZ',
                              style: GoogleFonts.secularOne(
                                color: Color(0xFF46BAD9),
                                fontSize: 26.01,
                                height: 0.05,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      left: 0.80,
                      top: 28.11,
                      child: Text(
                        'by Mirasys',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.secularOne(
                          color: Color(0xFF46BAD9),
                          fontSize: 14.86,
                          height: 0.08,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 89.89),
              const LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
