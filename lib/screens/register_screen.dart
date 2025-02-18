import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_icon_class/font_awesome_icon_class.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:news/widgets/text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../api_manager.dart';
import '../firebase/firebase_manager.dart';
import '../model/user_model.dart';
import '../provider/auth_provider.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'RegisterScreen';
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var nameController = TextEditingController();

  var confirmPasswordController = TextEditingController();

  var phoneController = TextEditingController();

  var formKey=GlobalKey<FormState>();

  int currentIndex = 0;

  List<String> imgList=[
    "assets/images/gamer0.png",
      "assets/images/gamer1.png",
      "assets/images/gamer2.png",
      "assets/images/gamer3.png",
      "assets/images/gamer4.png",
      "assets/images/gamer5.png",
      "assets/images/gamer6.png",
      "assets/images/gamer7.png",
      "assets/images/gamer8.png",
  ];

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
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: CarouselSlider.builder(
                    itemCount: imgList.length,
                      itemBuilder: (context, index, realIdx){
                        bool isSelected = index == currentIndex;
                        return Container(
                          decoration: BoxDecoration(
                            border: isSelected
                                ? Border.all(color:Theme.of(context).primaryColor, width: 3)
                                : null,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(imgList[index]),
                          ),
                        );
                      },
                      options: CarouselOptions(
                          height: 120,
                          viewportFraction: 0.3,
                          initialPage: 4,
                          enableInfiniteScroll: false,
                          reverse: false,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.4,      // Make the center image significantly larger
                          scrollDirection: Axis.horizontal,
                          aspectRatio: 8 / 4,
                          onPageChanged: (index,reason){
                            setState(() {
                              currentIndex=index;
                            });
                          }
                      )
                  ),
                ),
                SizedBox(height: 16,),
                CustomTextField(
                    icon: Icon(Icons.person,color: Colors.white,),
                    isPasswordField: false,
                    hasSuffix: false,
                    keyboardType: TextInputType.text,
                    validation: (value){
                      if (value == null || value.isEmpty) {
                        return "Name is required";
                      }
                      return null;
                    },
                    onChange: (){
                      formKey.currentState!.validate();

                    },
                    controller: nameController,
                    text: "name".tr()),
                SizedBox(height: 16,),
                CustomTextField(
                    icon: Icon(Icons.email,color: Colors.white,),
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
                SizedBox(height: 16,),
                CustomTextField(
                    icon: Icon(Icons.lock,color: Colors.white,),
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
                SizedBox(height: 16,),
                CustomTextField(
                    icon: Icon(Icons.lock,color: Colors.white,),
                    isPasswordField: true,
                    hasSuffix: true,
                    keyboardType: TextInputType.text,
                    validation: (value){
                      if (value == null || value.isEmpty) {
                        return "Re password is required";
                      } String pattern =
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[?!.@#$%^&*()_+])[A-Za-z\d?!.@#$%^&*()_+]{8,}$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Password must be at least 8 characters long, with 1 uppercase, 1 lowercase, 1 number, and 1 special character';
                      }
                      else if(passwordController.text!=value){
                        return "Password don't match";
                      }
                      return null;
                    },
                    onChange: (){
                      formKey.currentState!.validate();
                    },
                    controller: confirmPasswordController,
                    text: "confirm_password".tr()),
                SizedBox(height: 16,),
                CustomTextField(
                    icon: Icon(Icons.call,color: Colors.white,),
                    isPasswordField: false,
                    hasSuffix: false,
                    keyboardType: TextInputType.phone,
                    validation: (value){
                      if (value == null || value.isEmpty) {
                        return "phone is required";
                      }
                      String pattern = r'^\+20\d{10}$';
                      RegExp regExp = RegExp(pattern);
                      if (!regExp.hasMatch(value)) {
                        return 'Please enter a valid phone number (e.g., +201141209334)';}
                      return null;
                    },
                    onChange: (){
                      formKey.currentState!.validate();

                    },
                    controller: phoneController,
                    text: "phone_number".tr()),
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async{
                          if(formKey.currentState!.validate()){
                            UserModel newUser = UserModel(
                              name: nameController.text,
                              email: emailController.text,
                              password:passwordController.text,
                              confirmPassword: confirmPasswordController.text,
                              phone: phoneController.text,
                              avaterId: currentIndex,
                            );
                            Map<String, dynamic> result = await ApiManager.registerUser(newUser);
                            print(result); // Add this line to debug and check the result

                            if (result['success']) {
                              Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(result['message'])),
                              );
                            }
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
