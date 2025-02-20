import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news/provider/auth_provider.dart';
import 'package:news/screens/edit_profile.dart';
import 'package:news/screens/forget_password.dart';
import 'package:news/screens/history_screen.dart';
import 'package:news/screens/login_screen.dart';
import 'package:news/screens/reset_password_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cache_helper/cache_helper.dart';
import 'firebase/firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/onbording_screen.dart';
import 'screens/register_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/dark_theme.dart';
import 'theme/theme.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseFirestore.instance.enableNetwork();

  runApp(

      ChangeNotifierProvider(
    create: (context)=> UserProvider(),
    child: EasyLocalization(
          supportedLocales: [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: Locale('en'),
          child: MyApp(),
  ),
  ));
}

class MyApp extends StatelessWidget {

   MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider =Provider.of<UserProvider>(context);
    BaseTheme darkTheme =DarkTheme();
    return MaterialApp(
      darkTheme: darkTheme.themeData,
      themeMode: ThemeMode.dark,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName:(context)=>SplashScreen(),
        OnBoardingScreen.routeName:(context)=>OnBoardingScreen(),
        LoginScreen.routeName:(context)=>LoginScreen(),
        RegisterScreen.routeName:(context)=>RegisterScreen(),
        ForgetPassword.routeName:(context)=>ForgetPassword(),
        HomeScreen.routeName:(context)=>HomeScreen(),
        EditProfile.routeName:(context)=>EditProfile(),
        HistoryScreen.routName:(context)=>HistoryScreen(),
        ResetPasswordScreen.routeName:(context)=>ResetPasswordScreen(),


      },
    );
  }
}

