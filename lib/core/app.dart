import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelligenz/core/constants/hive_constants.dart';
import 'package:intelligenz/core/services/alerts/alert_repository.dart';
import 'package:intelligenz/core/services/alerts/cubit/alert_cubit.dart';
import 'package:intelligenz/core/services/analytics/analytics_repository.dart';
import 'package:intelligenz/core/services/analytics/cubit/analytics_cubit.dart';
import 'package:intelligenz/core/services/auth/auth_repository.dart';
import 'package:intelligenz/core/services/auth/cubit/auth_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intelligenz/core/utils/route.dart';
import 'package:intelligenz/core/utils/theme/theme.dart';
import 'package:intelligenz/db/analytics/analytics_model.dart';
import 'package:intelligenz/db/auth/auth_model.dart';
import 'package:intelligenz/db/user/user_model.dart';

Future<Widget> initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GoogleFonts.pendingFonts([
    GoogleFonts.dmSans(),
    GoogleFonts.secularOne(),
  ]);

  // local phone storage
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(AuthModelAdapter());
  Hive.registerAdapter(AnalyticsModelAdapter());

  await Hive.openBox<AuthModel>(authBox);
  await Hive.openBox<AnalyticsModel>(analyticsBox);
  await Hive.openBox<String>(metaBox);

  return const MyApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final analyticsRepository = AnalyticsRepository();
    final alertRepository = AlertRepository();
    final authCubit = AuthCubit(authRepository);
    final analyticsCubit = AnalyticsCubit(analyticsRepository);
    final alertCubit = AlertCubit(alertRepository);

    final GoRouter goRouter = router(authCubit, analyticsCubit);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),
        BlocProvider<AnalyticsCubit>.value(value: analyticsCubit),
        BlocProvider<AlertCubit>.value(value: alertCubit),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.system,
        theme: TAppTheme.lightTheme,
        // darkTheme: TAppTheme.darkTheme,
        routeInformationProvider: goRouter.routeInformationProvider,
        routerDelegate: goRouter.routerDelegate,
        routeInformationParser: goRouter.routeInformationParser,
      ),
    );
  }
}
