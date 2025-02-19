import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Edit profile',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).primaryColor,)
        ),
        leading: BackButton(color: Theme.of(context).primaryColor),
      ),
      body:Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(

            children: [
              InkWell(
                  onTap: ()async{
                     selectedAvatarId = await
                    showModalBottomSheet(context: context,isScrollControlled: true,
                    backgroundColor: Color(0xFF282A28),
                    builder:(context){
                      return Wrap(
                        children: [
                          AddBottomSheet(avaterId: avatarId,),
                        ],
                      );

                    });
                    if (selectedAvatarId != null) {
                      setState(() {
                        avatarId = selectedAvatarId!;
                      });
                  }
                  },
                  child: selectedAvatarId!=null?Image.asset("assets/images/gamer$avatarId.png"):

                  Image.asset("assets/images/gamer${userProvider.userModel?.avaterId}.png")),
              const SizedBox(height: 35,),
              CustomTextField(icon: const Icon(Icons.person,color: Colors.white,),
                  isPasswordField: false, hasSuffix: false,
                  keyboardType: TextInputType.text,
                  validation: (value){
                    if (value == null || value.isEmpty) {
                      return "Name is required";
                    }
                    return null;
                  },
                  onChange: (){
                    formKey.currentState!.validate();

                  }, controller: nameController, text: userProvider.userName),
              const SizedBox(height: 16,
              ),
              CustomTextField(icon: const Icon(Icons.phone,color: Colors.white,),
                  isPasswordField: false, hasSuffix: false,
                  keyboardType: TextInputType.text,
                  validation: (value){
                    if (value == null || value.isEmpty) {
                      return "Phone is required";
                    }
                    return null;
                  },
                  onChange: (){
                    formKey.currentState!.validate();

                  }, controller: nameController, text: "${userProvider.userModel?.phone}"),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Reset Password",
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.start,
                ),
              ),
              const Spacer(),
              CustomButton(text: "Delete Account",color: Color(0xFFE82626),textColor: Colors.white,),
            SizedBox(height: 12),
            CustomButton(text: "Update Data",color: Theme.of(context).primaryColor,textColor: Colors.black,)]
          ),
        ),
      )
    );
  }
}
