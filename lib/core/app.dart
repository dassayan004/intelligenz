import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intelligenz/core/services/auth/auth_repository.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/utils/route.dart';
import 'package:intelligenz/core/utils/theme/theme.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([
    GoogleFonts.dmSans(),
    GoogleFonts.secularOne(),
  ]);

  return const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final authCubit = AuthCubit(authRepository);

    final GoRouter goRouter = router(authCubit);

    return MultiBlocProvider(
      providers: [BlocProvider<AuthCubit>.value(value: authCubit)],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: appTheme,
        routeInformationProvider: goRouter.routeInformationProvider,
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
      ),
    );
  }
}
