import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:news/firebase/firebase_manager.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../provider/auth_provider.dart';
import '../widgets/text_form_field.dart';
import 'forget_password.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'LoginScreen';
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right:16,bottom: 4),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Image(image: AssetImage('assets/images/splash.png')),
                CustomTextField(
                    icon: const Icon(Icons.email,color: Colors.white,),
                    isPasswordField: false,
                    hasSuffix: false,
                    keyboardType: TextInputType.emailAddress,
                    validation: (value){
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
                    onChange: (){
                      formKey.currentState!.validate();

                    },
                    controller: emailController,
                    text: "email".tr()),
                const SizedBox(height: 16,),
                CustomTextField(
                    icon: const Icon(Icons.lock,color: Colors.white,),
                    isPasswordField: true,
                    hasSuffix: true,
                    keyboardType: TextInputType.text,
                    validation: (value){
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }String pattern =
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[?!.@#$%^&*()_+])[A-Za-z\d?!.@#$%^&*()_+]{8,}$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Password must be at least 8 characters long, with 1 uppercase, 1 lowercase, 1 number, and 1 special character';
                      }
                      return null;
                    },
                    onChange: (){
                      formKey.currentState!.validate();
                    },
                    controller: passwordController,
                    text: "password".tr()),
                const SizedBox(
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
                          if(formKey.currentState!.validate()){
                            FirebaseManager.logIn(
                                emailController.text, passwordController.text, () async{
                              await userProvider.initUser();
                              Navigator.pop(context);
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                HomeScreen.routeName,
                                    (route) => false,
                              );
                            }, () {
                              showDialog(
                                context: context,
                                builder: (context) => const AlertDialog(
                                  backgroundColor: Colors.transparent,
                                  title: Center(child: CircularProgressIndicator()),
                                ),
                              );
                            }, (message) {
                              Navigator.pop(context);
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Something went wrong"),
                                  content: Text(message),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"))
                                  ],
                                ),
                              );
                            });

                          }
                        },

                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: InkWell(
                          onTap: (){
                            Navigator.pushNamed(context, HomeScreen.routeName);
                            print("${userProvider.userModel?.name}");

                          },
                          child: Text('login'.tr(),
                              style: GoogleFonts.inter(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff282A28),
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
                const SizedBox(
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
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton(
                    onPressed: () {
                      FirebaseManager.signInWithGoogle;
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Theme.of(context).primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ImageIcon(AssetImage('assets/images/google.png'),color: Color(0xff202020),),
                        const SizedBox(
                          width: 6,
                        ),
                        Text('login_with_google'.tr(),
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff282A28),
                            )),
                      ],
                    )),
                const SizedBox(height: 24,),
                ToggleSwitch(
                  minWidth: 50,
                  initialLabelIndex: context.locale.toString()=="en"?0:1,
                  cornerRadius: 40.0,
                  inactiveBgColor: Theme.of(context).hintColor,
                  totalSwitches: 2,
                  activeBgColor: [Theme.of(context).primaryColor],
                  activeBorders: [
                    Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 3.0,
                    ),
                  ],
                  labels: const ["english","arabic"],
                  radiusStyle: true,
                  customWidgets: [
                    Image.asset("assets/images/english.png"), Image.asset("assets/images/arabic.png")],
                  onToggle: (index) {
                    if(index==1){
                      context.setLocale(const Locale('ar'));
                    }else{
                      context.setLocale(const Locale('en'));
                    }
                    print('switched to: $index');
                  },
                )              ],
            ),
          ),
        ),
      ),
    );
  }
}
