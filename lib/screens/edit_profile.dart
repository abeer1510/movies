import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/screens/login_screen.dart';
import 'package:news/screens/reset_password_screen.dart';
import 'package:news/widgets/add_bottom_sheet.dart';
import 'package:news/widgets/custom_button.dart';
import 'package:news/widgets/text_form_field.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../provider/auth_provider.dart';

class EditProfile extends StatefulWidget {
  static const String routeName = 'EditProfile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  var phoneController = TextEditingController();
  var nameController = TextEditingController();
  int avatarId = 0;
  int? selectedAvatarId;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text('Edit profile',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).primaryColor,
                  )),
          leading: BackButton(color: Theme.of(context).primaryColor),
        ),
        body: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, // Adjust height

                child: Column(children: [
                  InkWell(
                      onTap: () async {
                        selectedAvatarId = await showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: const Color(0xFF282A28),
                            builder: (context) {
                              return Wrap(
                                children: [
                                  AddBottomSheet(
                                    avaterId: avatarId,
                                  ),
                                ],
                              );
                            });
                        if (selectedAvatarId != null) {
                          setState(() {
                            avatarId = selectedAvatarId!;
                          });
                        }
                      },
                      child: selectedAvatarId != null
                          ? Image.asset("assets/images/gamer$avatarId.png")
                          : Image.asset(
                              "assets/images/gamer${userProvider.userModel?.avaterId}.png")),
                  const SizedBox(
                    height: 35,
                  ),
                  CustomTextField(
                      icon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      isPasswordField: false,
                      hasSuffix: false,
                      keyboardType: TextInputType.text,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                      onChange: () {
                        formKey.currentState!.validate();
                      },
                      controller: nameController,
                      text: userProvider.userName),
                  const SizedBox(
                    height: 16,
                  ),
                  CustomTextField(
                      icon: const Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      isPasswordField: false,
                      hasSuffix: false,
                      keyboardType: TextInputType.phone,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "phone is required";
                        }
                        String pattern = r'^\+20\d{10}$';
                        RegExp regExp = RegExp(pattern);
                        if (!regExp.hasMatch(value)) {
                          return 'Please enter a valid phone number (e.g., +201141209334)';
                        }
                        return null;
                      },
                      onChange: () {
                        formKey.currentState!.validate();
                      },
                      controller: phoneController,
                      text: "${userProvider.userModel?.phone}"),
                  const SizedBox(
                    height: 30,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, ResetPasswordScreen.routeName);
                
                      },
                      child: Text(
                        "Reset Password",
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),Spacer(),
                  CustomButton(
                    text: "Delete Account",
                    color: const Color(0xFFE82626),
                    textColor: Colors.white,
                    onTab: () async {
                      bool success = await userProvider.deleteProfile();
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profile deleted successfully!")),
                        );
                        Navigator.pushReplacementNamed(
                            context, LoginScreen.routeName); // Navigate to login
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Failed to delete profile.")),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  CustomButton(
                    text: "Update Data",
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.black,
                    onTab: () async {
                      bool success = await userProvider.updateProfile(
                        name: nameController.text,
                        phone: phoneController.text,
                        avaterId: selectedAvatarId!,
                      );
                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Profile updated successfully!")));
                        Navigator.pop(context);
                        print("Profile updated successfully!");
                      } else {
                        Navigator.pop(context);
                        print("Failed to update profile.");
                      }
                    },
                  )
                ]),
              ),
            ),
          ),
        ));
  }
}
