import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../../firebase/firebase_manager.dart';
import '../../provider/auth_provider.dart';

class ProfileTab extends StatelessWidget {
   ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Color(0xFF2B2A2B) ,
      body:Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Image.asset("assets/images/gamer1.png"),
                      SizedBox(height: 16,),
                      Text("${userProvider.userModel?.name}",style: Theme.of(context).textTheme.headlineSmall,),
                    ],
                  ),
                  Column(
                    children: [
                      Text("12",style: Theme.of(context).textTheme.headlineLarge,),
                      SizedBox(height: 16,),
                      Text("Wish List",style: Theme.of(context).textTheme.headlineMedium,),
                    ],
                  ),
                  Column(
                    children: [
                      Text("10",style: Theme.of(context).textTheme.headlineLarge,),
                      SizedBox(height: 16,),
                      Text("History",style: Theme.of(context).textTheme.headlineMedium,),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 23,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () {

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
            DefaultTabController(length: 2,
                child: TabBar(
                  isScrollable: false,
                    dividerColor: Colors.transparent,
                    indicatorColor: Theme.of(context).primaryColor,
                    labelPadding: EdgeInsets.zero,
                    tabs: [
                      Column(
                  children: [
                    Icon(Icons.list,color: Theme.of(context).primaryColor,),
                    SizedBox(height: 4,),
                    Text("Watch List",style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400),)
                  ],
                ),
                      Column(
                  children: [
                    Icon(Icons.folder,color: Theme.of(context).primaryColor,),
                    SizedBox(height: 4,),
                    Text("History",style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w400),)
                  ],
                )
                ])
            ),

            Expanded(child: Container(
                color: Color(0xFF121312),
                width: double.infinity,
                child: Image.asset("assets/images/popcorn.png")))

          ],
        ),
      )
    );
  }
}

/*Center(child:
InkWell(
onTap: () {
FirebaseManager.logOut().then((_){
Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false,);
});
},

child: Text("Sign Out",style: TextStyle(color: Colors.white),))),*/
