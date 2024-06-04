// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onboarding_app/constants/navigation/app_router.dart';
import 'package:onboarding_app/constants/share_pref_keys.dart';
import 'package:onboarding_app/constants/share_preference.dart';
import 'package:onboarding_app/functions/get_device_info.dart';
import 'package:onboarding_app/screens/auth_module/auth_provider/auth_provider.dart';
import 'package:onboarding_app/screens/candidate_module/candidate_providers/candidate_provider.dart';
import 'package:onboarding_app/screens/candidate_module/connect/connect_providers/connect_provider.dart';
import 'package:onboarding_app/screens/candidate_module/dashboard/dashboard_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/candidate_module/profile/profile_providers/profile_provider.dart';
import 'package:onboarding_app/screens/employer_module/employer_provider/dashboard_provider.dart';
import 'package:onboarding_app/screens/qr_code_module/qr_code_provider/qr_code_provider.dart';
import 'package:onboarding_app/services/socket_services.dart';
import 'package:provider/provider.dart';
import 'package:onboarding_app/providers/general_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => GeneralHelper()),
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(create: (_) => CandidateProvider()),
      ChangeNotifierProvider(create: (_) => EmployerDashboardProvider()),
      ChangeNotifierProvider(create: (_) => QRCodeProvider()),
      ChangeNotifierProvider(create: (_) => ConnectionProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppRouter appRouter;

  @override
  void initState() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    final qrCodeProvider = Provider.of<QRCodeProvider>(context, listen: false);
    final candidateProvider =
        Provider.of<ConnectionProvider>(context, listen: false);

    //Define App Router
    appRouter = AppRouter(
        helper, authProvider, context, qrCodeProvider, candidateProvider);
    setThemData();
    // Get Device Information
    CurrentDeviceInformation.getDeviceInformation();

    super.initState();
  }

  @override
  void dispose() {
    // Disconnect the socket when the widget is disposed
    SocketServices(context).disposeSocket();
    super.dispose();
  }

  Future<void> setThemData() async {
    final helper = Provider.of<GeneralHelper>(context, listen: false);
    //Get Login Status
    await Shared_Preferences.prefGetString(SharedP.themColorListKey, "")
        .then((value) async {
      if (value != "") {
        helper.themColorData = jsonDecode(value);
      }
    });

    helper.updateThemColor();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "ZingHR Onboarding",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Cera Pro"),
      builder: BotToastInit(),
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // English
        Locale('hi'),
        Locale('ar'),
      ],
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
