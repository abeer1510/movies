import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache_helper/cache_helper.dart';
import '../provider/auth_provider.dart';
import 'home_screen.dart';
import 'onbording_screen.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName ='SplashScreen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkUserStatus();
  }
  Future<void> _checkUserStatus() async {
    await Future.delayed(Duration(seconds: 3)); // Simulate loading

    bool onboardingCompleted = CacheHelper.getEligibility() ?? false;
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    await Future.delayed(Duration(seconds: 2));

    if (!onboardingCompleted) {
      Navigator.pushReplacementNamed(context, OnBoardingScreen.routeName);
    } else if (userProvider.isLoggedIn) {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Image(image: AssetImage('assets/images/splash.png')),
            Spacer(),
            Image(image: AssetImage('assets/images/pranding.png'),),
            Text("Supervised by Mohamed Nabil",style: Theme.of(context).textTheme.titleSmall,),
          ],
        ),
      ),
    );
  }
}