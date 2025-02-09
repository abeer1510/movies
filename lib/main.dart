import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news/screens/forget_password.dart';
import 'package:news/screens/login_screen.dart';
import 'firebase/firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/onbording_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/dark_theme.dart';
import 'theme/theme.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(  EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp()),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    BaseTheme darkTheme =DarkTheme();
    return MaterialApp(
      darkTheme: darkTheme.themeData,
      themeMode: ThemeMode.dark,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,



      debugShowCheckedModeBanner: false,
      initialRoute:SplashScreen.routeName,
      routes: {
        SplashScreen.routeName:(context)=>SplashScreen(),
        OnBoardingScreen.routeName:(context)=>OnBoardingScreen(),
        LoginScreen.routeName:(context)=>LoginScreen(),
        RegisterScreen.routeName:(context)=>RegisterScreen(),
        ForgetPassword.routeName:(context)=>ForgetPassword(),
        HomeScreen.routeName:(context)=>HomeScreen(),


      },
    );
  }
}

