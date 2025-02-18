import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  static const String routeName = 'EditProfile';
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Edit profile',
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context).primaryColor,)
        ),
        leading: BackButton(color: Theme.of(context).primaryColor),
      ),
      body:Column(
        children: [
          Image.asset("assets/iamges/")
        ],
      )
    );
  }
}
