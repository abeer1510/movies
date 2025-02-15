import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/firebase/firebase_manager.dart';

import '../widgets/text_form_field.dart';

class ForgetPassword extends StatelessWidget {
  static const String routeName = 'ForgetPassword';

   ForgetPassword({super.key});
  var emailController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Forget Password',
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
                Image(image: AssetImage('assets/images/forgot_password.png')),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomTextField(
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
                      text: "email".tr())
                    ,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14, bottom: 24),
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          if(formKey.currentState!.validate()){
                            return
                            FirebaseManager.forgetPassword(emailController.text);

                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text('Verify Email',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff121312),
                            ))),
                  ),
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
