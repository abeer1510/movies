import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_model.dart';


class FirebaseManager {

  /*static createAccount(String email,String password,String name,Function onSuccess,Function onLoading, Function onError) async{
    try {
      onLoading();
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      onSuccess();
      print("Name passed: $name");  // Add this line to debug

      UserModel model=UserModel(id: credential.user!.uid, name: name, email: email, createAt: DateTime.now().millisecondsSinceEpoch);
      await addUser(model);
      print('User added to Firestore: ${model.toJson()}');
      credential.user!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError(e.message);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        onError(e.message);
        print('The account already exists for that email.');
      }
    } catch (e) {
      onError("Something went wrong");
      print(e);
    }
  }*/

  static Future<void> logIn(String email,String password,Function onSuccess,Function onLoading, Function onError) async{
    try {
      onLoading();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      onSuccess();
    /*  if(credential.user!.emailVerified){
        onSuccess();}
      else{
        onError("Email is not verified");
      }*/
    } on FirebaseAuthException catch (e) {
      onError("Email or password is not valid");
      /*if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }*/
    }
  }

  static CollectionReference <UserModel> getUsersCollection() {
    return FirebaseFirestore.instance.collection("Users").withConverter<UserModel>(
        fromFirestore: (snapshot, _) {
          return UserModel.fromJson(snapshot.data()!);
        }, toFirestore: (value, _) {
      return value.toJson();
    });
  }

 /* static Future<void> addUser(UserModel model) {
    var collection = getUsersCollection();
    var docRef = collection.doc(model.id);
    return docRef.set(model);
  }*/

  static Future<UserModel?> getUser(String id)async{
    var collection=getUsersCollection();
    DocumentSnapshot<UserModel> snapshot = await collection.doc(id).get();
    if (snapshot.exists) {
      print("User found: ${snapshot.data()?.name}"); // Print user name for debugging
      return snapshot.data();
    } else {
      print("User with ID $id not found");
      return null;
    }
  }

 /* static Future<void> updateUser(UserModel model) {
    if (model.id == null ) {
      throw Exception("Document ID cannot be empty");
    }
    var collection = getUsersCollection();
    return collection.doc(model.id).update(model.toJson());
  }*/

  static forgetPassword(String email)async{
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: email);FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value) {
      print("Password reset email sent.");
    }).catchError((e) {
      print("Error: $e");
    });
  }

  static Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> logOut(){
    return FirebaseAuth.instance.signOut();
  }
}
