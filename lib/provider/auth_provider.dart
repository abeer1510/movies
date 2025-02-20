import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/model/user_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? authToken;
  UserModel? userModel;
  String? userEmail;

  UserProvider() {
    autoLogin();
  }

  Future<bool> login(String email, String password) async {
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/auth/login");
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": email, "password": password}));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        authToken = responseBody['data'];
        userEmail = email;
        print(authToken);
        print(userEmail);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken!);
        await prefs.setString('userEmail', userEmail!);
        await initUser();
        notifyListeners();
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<void> autoLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
    userEmail = prefs.getString('userEmail'); // تحميل الإيميل من التخزين
    print("🔍 AutoLogin -> Token: $authToken, Email: $userEmail");

    if (authToken != null && userEmail != null) {
      debugPrint("Auto-login: Token exists, fetching user...");
      try {
        await initUser();

      } catch (e) {
        debugPrint("Auto-login failed: $e");
        logout();
      }
    } else {
      debugPrint("Auto-login: No token, user must log in.");
    }
  }

  bool get isLoggedIn => authToken != null;

  Future<void> initUser() async {
    if (authToken == null) {
      print('Token is null');
      return;
    }
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/profile");
    try {
      print('📤 Fetching user profile...');

      final response =
      await http.get(url, headers: {"Authorization": "Bearer $authToken"});
      print('📥 Response Code: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');
      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('data')) {
          var userData = responseBody['data'];
          if (userData.containsKey('name')) {
            userModel = UserModel.fromJson(userData);

            print('User initialized: ${userModel?.toJson()}');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username_$userEmail', userModel!.name);
            notifyListeners();
          } else {
            print('No name field in the profile data');
          }
        } else {
          print('No data field in the profile response');
        }
      } else {
        debugPrint("Error: ${response.statusCode}, ${response.body}");
        logout();
      }
    } catch (error) {
      print('Error fetching user profile: $error');
      logout();
    }
  }

  Future<void> logout() async {
    authToken = null;
    userModel = null;
    userEmail = null;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    await prefs.remove('userEmail');

    notifyListeners();
    debugPrint("User logged out, token removed.");
  }

  String get userName {
    debugPrint("📢 Getting userName: ${userModel?.name}");
    return userModel?.name ?? "No Name"; // Fallback
  }

  void addToHistory(int movieId) {
    if (userModel != null && !userModel!.history.contains(movieId)) {
      userModel!.history.add(movieId);
      notifyListeners();
    }
  }

   void addToFavorites(int movieId) {
     if (favorites.contains(movieId)) {
       favorites.remove(movieId); // Remove if it's already in the list
     } else {
       favorites.add(movieId); // Add if it's not in the list
     }
     print(favorites); // Debugging: See if favorites list updates correctly
     notifyListeners();
   }


  bool isFavorite(int movieId) {
    return favorites.contains(movieId);
  }

  List<int> get history => userModel?.history ?? [];

  List<int> get favorites => userModel?.favorites ?? [];

  Future<bool> updateProfile(
      {required String name, required int avaterId, required String phone,}) async {
    if (authToken == null) {
      return false;
    }
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/profile");

    try {
      final response = await http.patch(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "avaterId": avaterId,
        }),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('message') &&
            responseBody['message'] == "Profile updated successfully") {
          if (userModel != null) {
            userModel!.name = name;
            userModel!.phone = phone;
            userModel!.avaterId = avaterId;
          }

          notifyListeners();
          return true;
        }
      } else {
        debugPrint("Failed to update profile: ${response.statusCode}, ${response
            .body}");
      }
    } catch (error) {
      debugPrint("Error updating profile: $error");
    }
    return false;
  }

  Future<bool> deleteProfile() async {
    if (authToken == null) {
      debugPrint("Error: No authentication token found.");
      return false;
    }

    Uri url = Uri.parse("https://route-movie-apis.vercel.app/profile");

    try {
      debugPrint("Sending DELETE request to: $url");

      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );
      debugPrint("📥 Response Code: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("✅ Profile deleted successfully!");

        // Log out the user after deletion
        await logout();
        return true;
      } else {
        debugPrint(
            "❌ Failed to delete profile: ${response.statusCode}, ${response
                .body}");
        return false;
      }
    } catch (error) {
      debugPrint("❌ Error deleting profile: $error");
      return false;
    }
  }

}
