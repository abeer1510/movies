import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgetPassword extends StatelessWidget {
  static const String routeName = 'ForgetPassword';

   ForgetPassword({super.key});
  var emailController = TextEditingController();

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
        child: Column(
          children: [
            Image(image: AssetImage('assets/images/forgot_password.png')),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: TextField(
                controller: emailController,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall,
                decoration: InputDecoration(
                  fillColor: Color(0xff282A28),
                  filled: true,
                  labelText: 'Email',
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
    );
  }
}
