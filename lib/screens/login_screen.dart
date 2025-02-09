import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'forget_password.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = 'LoginScreen';
  LoginScreen({super.key});
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/splash.png')),
                ],
              ),
              TextField(
                controller: emailController,
                style: Theme.of(context).textTheme.titleSmall,
                decoration: InputDecoration(
                  fillColor: Color(0xff282A28),
                  filled: true,
                  labelText: 'email'.tr(),
                  prefixIcon: Icon(Icons.email, color: Colors.white,),
                  labelStyle: Theme.of(context).textTheme.titleSmall,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
          
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!,
                  decoration: InputDecoration(
                    fillColor: Color(0xff282A28),
                    filled: true,
                    labelText: 'password'.tr(),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(
                      Icons.visibility_off,
                      color: Colors.white,
                    ),
                    labelStyle: Theme.of(context).textTheme.titleSmall,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
          
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
          
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
          
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ForgetPassword.routeName);
                    },
                    child: Text(
                      'forget_password'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(color: Theme.of(context).primaryColor,fontSize: 14),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14, bottom: 24),
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () {
                        //Navigator.pushNamed(context, OnBoardingScreen.routeName);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        },
                        child: Text('login'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff282A28),
                            )),
                      )),
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, RegisterScreen.routeName);
          
                },
                child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "don't_account".tr(),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14),
                        ),
                        TextSpan(
                          text: "create_account".tr(),
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: 14,
                              color: Theme.of(context).primaryColor,),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      indent: 40,
                      endIndent: 10,
                      thickness: 2,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    "or".tr(),
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).primaryColor,
                      indent: 10,
                      endIndent: 40,
                      thickness: 2,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                  onPressed: () {
                    //Navigator.pushNamed(context, OnBoardingScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageIcon(AssetImage('assets/images/google.png'),color: Color(0xff202020),),
                      SizedBox(
                        width: 6,
                      ),
                      Text('login_with_google'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff282A28),
                          )),
                    ],
                  )),
              SizedBox(height: 24,),
              ToggleSwitch(
                minWidth: 60.0,
                minHeight: 30.0,
                initialLabelIndex: context.locale.toString()=="en"?0:1,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                icons:  [
                  FontAwesomeIcons.flagUsa,
                  MdiIcons.abjadArabic,
                ],
                iconSize: 30.0,
                activeBgColors: [[Theme.of(context).primaryColor, Theme.of(context).secondaryHeaderColor],
                  [Colors.yellow, Colors.orange]],
                animate: true, // with just animate set to true, default curve = Curves.easeIn
                curve: Curves.bounceInOut, // animate must be set to true when using custom curve
                onToggle: (index) {
                  if(index==1){
                    context.setLocale(Locale('ar'));
                  }
                  else{
                    context.setLocale(Locale('en'));
          
                  }
                  print('switched to: $index');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
