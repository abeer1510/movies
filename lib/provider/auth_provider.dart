import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';


import '../firebase/firebase_manager.dart';
import '../model/user_model.dart';

class UserProvider extends ChangeNotifier{

  UserModel? userModel;
  User? currentUser;

  UserProvider(){
    currentUser=FirebaseAuth.instance.currentUser;
    if(currentUser!=null){
      initUser();
    }
  }
  initUser()async{
    currentUser=FirebaseAuth.instance.currentUser;
    userModel = await FirebaseManager.getUser(currentUser!.uid);
    notifyListeners();
  }
}