import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UserProvider extends ChangeNotifier {
  String? authToken;  // This will store the token for API authentication
  String? userName;
  String? email;
  String? phone;
  int? avatarId;

  // You can store the user's name or email directly here

  UserProvider();

  // Login method via API
  Future<bool> login(String email, String password) async {
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/auth/login");

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}));

      if (response.statusCode == 200) {
        // Successful login
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        authToken = responseBody['data'];
        print('Auth Token: $authToken');    // Debugging the token
// Assuming the response contains a token
        userName = responseBody['name'];  // Assuming the response contains the user name or email
        print('User Name: $userName');

        print('Response body: ${response.body}');

        notifyListeners();
        // Now get the user details using the token (if needed)
        await initUser();

        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  // Initialize user data after login (you can fetch more data here if needed)
  Future<void> initUser() async {
    if (authToken == null) {
      print('Token is null');
      return;
    }    // Example API to fetch user data if needed, for example, profile info
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/profile");
    try {
      final response = await http.get(url, headers: {"Authorization": "Bearer $authToken"});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('data')) {
          var userData = responseBody['data'];  // Extract the data object
          if (userData.containsKey('name')) {
            userName = userData['name'];  // Set the userName to the 'name' field
            print('User Name: $userName');

          }if (userData.containsKey('email')) {
            email = userData['email'];  // Set the 'email'
            print('User Email: $email');
          }
          if (userData.containsKey('phone')) {
            phone = userData['phone'];  // Set the 'phone'
            print('User Phone: $phone');
          }
          if (userData.containsKey('avaterId')) {
            avatarId = userData['avaterId'];  // Set the 'avatarId'
            print('Avatar ID: $avatarId');
          }
          else {
            print('No name field in the profile data');
          }
        } else {
          print('No data field in the profile response');
        }
        notifyListeners();
        // Notify listeners that user data has been fetched
      }
    } catch (error) {
      // Handle any error, maybe log out user
      logout();
    }
  }

  // Logout method (clear token and user data)
  Future<void> logout() async {
    authToken = null;  // Clear token
    userName = null;   // Clear user data (like userName)

    notifyListeners();  // Notify listeners that the user is logged out
  }
}
