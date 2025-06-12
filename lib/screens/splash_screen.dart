import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});
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
                          color: klAccentColor,
                          fontSize: 40.88,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: 'genZ',
                        style: GoogleFonts.secularOne(
                          color: klPrimaryColor,
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
                    color: klPrimaryColor,
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
