import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/constants/color_constant.dart';
import 'package:intelligenz/core/constants/router_constant.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const ReusableAppBar({super.key, this.title});

  @override
  Size get preferredSize => const Size.fromHeight(120);

  bool _canPop(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    const noBackButtonRoutes = [
      AppRouterConstant.splash,
      AppRouterConstant.login,
      AppRouterConstant.analytics,
      AppRouterConstant.home,
    ];

    return !noBackButtonRoutes.contains(location);
  }

  @override
  Widget build(BuildContext context) {
    final showBackButton = _canPop(context);

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // Android
        statusBarBrightness: Brightness.light, // iOS
      ),
      elevation: 0,
      flexibleSpace: Container(
        height: 120,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF6E0), Color(0xFFD7EFFD)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 50.0, 24.0, 21.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Align items vertically
            children: [
              // Left Back Button or Logo
              if (showBackButton)
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context
                            .pop(); // ✅ go back to previous screen in GoRouter
                      } else {
                        context.goNamed(AppRouteName.home.name);
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: kNeutralWhite,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: kNeutralBlack.withAlpha(25),
                            blurRadius: 10,
                            offset: Offset(0, 0),
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: kNeutralGrey900,
                        size: 20,
                      ),
                    ),
                  ),
                )
              else
                SizedBox(
                  width: 110.50,
                  height: 48,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Intelli',
                              style: GoogleFonts.spaceGrotesk(
                                color: klAccentColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.2,
                              ),
                            ),
                            TextSpan(
                              text: 'genZ',
                              style: GoogleFonts.spaceGrotesk(
                                color: klPrimaryColor,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'by Mirasys',
                        style: GoogleFonts.spaceGrotesk(
                          color: kSkyBlue300,
                          fontSize: 9.6,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),

              // Right Text (default or custom)
              SizedBox(
                width: 140,
                child: Text(
                  title ?? "Next Gen\nAI Analytics",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 12,
                    color: Color(0xFF007999),
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
