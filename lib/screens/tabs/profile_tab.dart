import 'package:flutter/material.dart';
import 'package:news/screens/login_screen.dart';

import '../../firebase/firebase_manager.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:
      InkWell(
          onTap: () {
            FirebaseManager.logOut().then((_){
              Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false,);
            });
          },

          child: Text("Sign Out",style: TextStyle(color: Colors.white),))),
    );
  }
}
