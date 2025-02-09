import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../firebase/firebase_manager.dart';
import '../provider/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  static const String routeName = 'RegisterScreen';
  RegisterScreen({super.key});
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var rePasswordController = TextEditingController();
  var phoneNumberController = TextEditingController();

  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'register'.tr(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).primaryColor,)
          ),
        leading: BackButton(color: Theme.of(context).primaryColor),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(image: AssetImage('assets/images/filter.png')),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                    onChanged:(value) {
                      formKey.currentState!.validate();
                    },
                    controller: nameController,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
                    decoration: InputDecoration(
                      fillColor: Color(0xff282A28),
                      filled: true,
                      labelText: "name".tr(),
                      prefixIcon: ImageIcon(AssetImage("assets/images/person.png"),color: Colors.white,),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      }
                      final bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);

                      if (!emailValid) {
                        return "Email not valid";
                      }
                      return null;
                    },
                    onChanged:(value) {
                      formKey.currentState!.validate();
                    },
                    controller: emailController,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
                    decoration: InputDecoration(
                      fillColor: Color(0xff282A28),
                      filled: true,
                      labelText: 'email'.tr(),
                      prefixIcon: Icon(
                        Icons.email,
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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be more than 6 digits";
                      }
                      return null;
                    },
                    onChanged:(value) {
                      formKey.currentState!.validate();
                    },
                    controller: passwordController,
                    obscureText: true,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Repassword is required";
                      } else if (value.length < 6) {
                        return "Password must be more than 6 digits";
                      }
                      else if(passwordController.text!=value){
                        return "Password don't match";
                      }
                      return null;
                    },
                    onChanged:(value) {
                      formKey.currentState!.validate();
                    },
                    controller: rePasswordController,
                    obscureText: true,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
                    decoration: InputDecoration(
                      fillColor: Color(0xff282A28),
                      filled: true,
                      labelText:"re_password".tr(),
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
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "phone is required";
                      }
                      else if(!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit phone number';
                      }
                      return null;
                    },
                    onChanged:(value) {
                      formKey.currentState!.validate();
                    },
                    controller: phoneNumberController,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall,
                    decoration: InputDecoration(
                      fillColor: Color(0xff282A28),
                      filled: true,
                      labelText:"phone_number".tr(),
                      prefixIcon: Icon(
                        Icons.call,
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
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            FirebaseManager.createAccount(
                                emailController.text, passwordController.text,nameController.text,
                                    () async {
                                  await userProvider.initUser();
                                  Navigator.pop(context);
                                  Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routeName, (route) => false,);
                                },(){
                              showDialog(context: context,
                                builder: (context) => const AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  title: Center(child:
                                  CircularProgressIndicator()),
                                ),);
                            },(message){
                              Navigator.pop(context);
                              showDialog(context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Something went wrong"),
                                  content: Text(message),
                                  actions: [
                                    ElevatedButton(onPressed: (){Navigator.pop(context);},
                                        child: const Text("Ok"))
                                  ],
                                ),);
                            });
                          };
                        },

                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text('create_account'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff121312),
                            ))),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'have_account'.tr(),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      Text(
                        'login'.tr(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).primaryColor,decoration: TextDecoration.underline),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                ToggleSwitch(
                  minWidth: 60.0,
                  minHeight: 30.0,
                  initialLabelIndex: context.locale.toString() == "en" ? 0 : 1,
                  cornerRadius: 20.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  icons: [
                    FontAwesomeIcons.flagUsa,
                    MdiIcons.abjadArabic,
                  ],
                  iconSize: 30.0,
                  activeBgColors: [
                    [
                      Theme.of(context).primaryColor,
                      Theme.of(context).secondaryHeaderColor
                    ],
                    [Colors.yellow, Colors.orange]
                  ],
                  animate:
                  true, // with just animate set to true, default curve = Curves.easeIn
                  curve: Curves
                      .bounceInOut, // animate must be set to true when using custom curve
                  onToggle: (index) {
                    if (index == 1) {
                      context.setLocale(Locale('ar'));
                    } else {
                      context.setLocale(Locale('en'));
                    }
                    print('switched to: $index');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
