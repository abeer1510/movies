import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? authToken;
  UserModel? userModel;
  String? userEmail;

  UserProvider() {
    autoLogin();
  }

  Future<void> _saveUserData() async {
    if (userModel == null || userEmail == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username_$userEmail', jsonEncode(userModel!.name));
    await prefs.setString('userHistory_$userEmail', jsonEncode(userModel!.history));
    await prefs.setString('userFavorites_$userEmail', jsonEncode(userModel!.favorites));

  }
  Future<void> _loadUserData() async {
    if (userEmail == null) return;
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString('username_$userEmail');
    final historyString = prefs.getString('userHistory_$userEmail');
    final favoritesString = prefs.getString('userFavorites_$userEmail');

    if (userModel != null) {
      userModel!.name = savedUsername ?? "Guest"; // Fallback to "Guest"
      userModel!.history =
      historyString != null ? List<int>.from(jsonDecode(historyString)) : [];
      userModel!.favorites =
      favoritesString != null ? List<int>.from(jsonDecode(favoritesString)) : [];
    }

    notifyListeners();
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', authToken!);
        await prefs.setString('userEmail', userEmail!);

        userModel = null;

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
      debugPrint('Token is null');
      return;
    }
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/profile");
    try {
      final response =
          await http.get(url, headers: {"Authorization": "Bearer $authToken"});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('data')) {
          var userData = responseBody['data'];
          if (userData.containsKey('name')) {
            userModel = UserModel.fromJson(userData);
            debugPrint('User initialized: ${userModel?.toJson()}');
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('username_$userEmail', userModel!.name);
            await _loadUserData();
            notifyListeners();

          } else {
            print('No name field in the profile data');
          }
        } else {
          print('No data field in the profile response');
        }
        notifyListeners();
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

  void addToHistory(int movieId) {
    if (userModel != null && !userModel!.history.contains(movieId)) {
      userModel!.history.add(movieId);
      _saveUserData(); // Save to storage
      notifyListeners();
    }
  }

  void addToFavorites(int movieId) {
    if (userModel != null && !userModel!.favorites.contains(movieId)) {
      userModel!.favorites.add(movieId);
      _saveUserData(); // Save to storage
      notifyListeners();
    }
  }

  String get userName =>
      userModel?.name ?? "No Name"; // Ensure it never returns null

  List<int> get history => userModel?.history ?? [];

  List<int> get favorites => userModel?.favorites ?? [];
}
