import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // This updates the AuthCubit state
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        BlocProvider.of<AuthCubit>(context).checkAuthStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFAEE3F7), Color(0xFFFEDDC8), Color(0xFFE7F4F5)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: size.height * 0.45,
              left: size.width * 0.25,
              right: size.width * 0.25,
              child: Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Intelli',
                        style: GoogleFonts.secularOne(
                          color: const Color(0xFFEC7914),
                          fontSize: 40.88,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'genZ',
                        style: GoogleFonts.secularOne(
                          color: const Color(0xFF46BAD9),
                          fontSize: 40.88,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Positioned(
              top: size.height * 0.52,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'by Mirasys',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.secularOne(
                    color: const Color(0xFF46BAD9),
                    fontSize: 23.36,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
