import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/custom_button.dart';
import '../widgets/text_form_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String routeName = 'ResetPasswordScreen';
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  var oldPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              CustomTextField(
                icon: const Icon(Icons.lock, color: Colors.white),
                isPasswordField: true,
                hasSuffix: false,
                keyboardType: TextInputType.text,
                validation: (value) {
                  if (value == null || value.isEmpty) return "Old Password is required";
                  return null;
                },
                controller: oldPasswordController,
                text: "Enter Old Password", onChange: (){
                formKey.currentState!.validate();

              },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                icon: const Icon(Icons.lock_outline, color: Colors.white),
                isPasswordField: true,
                hasSuffix: false,
                keyboardType: TextInputType.text,
                validation: (value) {
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
                controller: newPasswordController,
                text: "Enter New Password", onChange: (){
                formKey.currentState!.validate();

              },
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: "Reset Password",
                color: Theme.of(context).primaryColor,
                textColor: Colors.black,
                onTab: () {
                  if (formKey.currentState!.validate()) {
                    ApiManager.resetPassword(oldPasswordController.text, newPasswordController.text);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ Password reset successful!")));
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

