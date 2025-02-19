import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/screens/edit_profile.dart';
import 'package:news/screens/history_screen.dart';
import 'package:news/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../../firebase/firebase_manager.dart';
import '../../provider/auth_provider.dart';

class ProfileTab extends StatelessWidget {
   ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF2B2A2B) ,
        
        body:SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Image.asset("assets/images/gamer${userProvider.userModel?.avaterId}.png"),
                        SizedBox(height: 16,),
                        Text("${userProvider.userModel?.name}",style: Theme.of(context).textTheme.headlineSmall,),
                      ],
                    ),
                    Column(
                      children: [
                        Text("${userProvider.favorites.length}",style: Theme.of(context).textTheme.headlineLarge,),
                        SizedBox(height: 16,),
                        Text("Wish List",style: Theme.of(context).textTheme.headlineMedium,),
                      ],
                    ),
                    Column(
                      children: [
                        Text("${userProvider.history.length}",style: Theme.of(context).textTheme.headlineLarge,),
                        SizedBox(height: 16,),
                        Text("History",style: Theme.of(context).textTheme.headlineMedium,),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, EditProfile.routeName);
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          child: Text('Edit Profile',
                              style: GoogleFonts.roboto(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff121312),
                              ))),
                    ),
                    SizedBox(width: 10,),
                    ElevatedButton(
                        onPressed: () {
                          userProvider.logout();
                          Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                          },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Color(0xFFE82626),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            children: [
                              Text('Exit',
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  )),
                              SizedBox(width: 4,),
                              Icon(Icons.exit_to_app,color: Colors.white,)
                            ],
                          ),
                        ))
      
                  ],
                ),
              ),
              SizedBox(height: 24,),
              Container(
                  height: MediaQuery.of(context).size.height * 0.6,
      
                  child: HistoryScreen()),
      
            ],
          ),
        )
      ),
    );
  }
}
