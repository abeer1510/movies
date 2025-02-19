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

  Future<void> _saveUserData() async {
    if (userModel == null || userEmail == null) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username_$userEmail', jsonEncode(userModel!.name));
    await prefs.setString(
        'userHistory_$userEmail', jsonEncode(userModel!.history));
    await prefs.setString(
        'userFavorites_$userEmail', jsonEncode(userModel!.favorites));
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
      favoritesString != null ? List<int>.from(jsonDecode(favoritesString)) : [
      ];
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

  /* void addToFavorites(int movieId) {
    if (userModel != null && !userModel!.favorites.contains(movieId)) {
      userModel!.favorites.add(movieId);
      _saveUserData(); // Save to storage
      notifyListeners();
    }
  }*/

  String get userName =>
      userModel?.name ?? "No Name"; // Ensure it never returns null

  List<int> get history => userModel?.history ?? [];

  List<int> get favorites => userModel?.favorites ?? [];
  int get favoriteMoviesCount => favorites.length;


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
            await _saveUserData();
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

  /* Future<bool> addToFavorites({ required int movieId,
    required String name,
    required double rating,
    required String imageURL,
    required String year,}) async {

    if (authToken == null) {
      debugPrint("Error: No authentication token found.");
      return false;
    }

    Uri url = Uri.parse("https://route-movie-apis.vercel.app/favorites/add");

    try {
      debugPrint("Sending request to add movie to favorites: $url");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "movieId": movieId,
          "name": name,
          "rating": rating,
          "imageURL": imageURL,
          "year": year,        }),
      );

      debugPrint("📥 Response Code: ${response.statusCode}");
      debugPrint("📥 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        debugPrint("✅ Movie added to favorites successfully!");

        if (userModel != null && !userModel!.favorites.contains(movieId)) {
          userModel!.favorites.add(movieId);
          await _saveUserData();
        }

        notifyListeners();
        return true;
      } else {
        debugPrint("❌ Failed to add movie to favorites: ${response.statusCode}, ${response.body}");
        return false;
      }
    } catch (error) {
      debugPrint("❌ Error adding movie to favorites: $error");
      return false;
    }
  }*/
  Future<bool> isFavorite(int movieId) async {
    try {
      final response = await http.get(
        Uri.parse(
            "https://route-movie-apis.vercel.app/favorites/is-favorite/$movieId"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["isFavorite"] ==
            true; // ✅ API returns true if the movie is a favorite
      }
    } catch (e) {
      print("❌ Error checking favorite status: $e");
    }
    return false;
  }

  Future<void> addToFavorites({ required int movieId, required String name, required double rating, required String imageURL, required String year,}) async {
    try {
      bool alreadyFavorite = await isFavorite(
          movieId); // ✅ Check if movie is already in favorites
      if (authToken == null) {
        debugPrint("❌ Error: No authentication token found.");
        return;
      }
      debugPrint(
          "📤 Adding movie: ID = $movieId, Name = $name, Rating = $rating");

      if (alreadyFavorite) {
        print("⚠️ Movie already in favorites");
        return; // 🚀 Exit early if it's already added
      }
      if (userModel == null) return; // Ensure userModel is not null

      if (!favorites.contains(movieId)) {
        userModel!.favorites.add(movieId);
        notifyListeners(); // Notify UI of changes
      }
      final response = await http.post(
        Uri.parse("https://route-movie-apis.vercel.app/favorites/add"),
        headers: {"Content-Type": "application/json",
          "Authorization": "Bearer $authToken", // ✅ Token added automatically
        },
        body: jsonEncode({
          "movieId": movieId,
          "name": name,
          "rating": rating,
          "imageURL": imageURL,
          "year": year,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Movie added successfully!");
      } else {
        print(
            "❌ Failed to add movie: ${response.statusCode}, ${response.body}");
      }
    } catch (e) {
      print("❌ Error adding movie to favorites: $e");
    }
  }

  Future<List<dynamic>> getAllFavorites() async {
    if (authToken == null) return [];

    Uri url = Uri.parse("https://route-movie-apis.vercel.app/favorites/all");

    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $authToken"},
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('data') && responseBody['data'] is List) {
          return responseBody['data'];
        } else {
          debugPrint("❌ Error: Unexpected response format.");
          return [];
        }
      } else {
        debugPrint(
            "❌ Failed to fetch favorites: ${response.statusCode}, ${response
                .body}");
        return [];
      }
    } catch (error) {
      debugPrint("❌ Error fetching favorites: $error");
      return [];
    }
  }

  Future<bool> removeFromFavorites(int movieId) async {
    if (authToken == null) {
      debugPrint("❌ Error: No authentication token found.");
      return false;
    }

    Uri url = Uri.parse(
        "https://route-movie-apis.vercel.app/favorites/remove/$movieId");

    try {
      debugPrint("📤 Sending request to remove movie ID: $movieId");

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
        debugPrint("✅ Movie removed from favorites successfully!");

        // تحديث قائمة المفضلات في `UserProvider`
        userModel?.favorites.remove(movieId);
        await _saveUserData();
        notifyListeners();

        return true;
      } else {
        debugPrint("❌ Failed to remove movie from favorites: ${response
            .statusCode}, ${response.body}");
      }
    } catch (error) {
      debugPrint("❌ Error removing movie from favorites: $error");
    }

    // ✅ ضمان إرجاع `false` في جميع الحالات
    return false;
  }
}
