import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/model/similar_movies_model.dart';
import 'package:news/model/upcoming_movies.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/browse_image_response.dart';
import 'model/browse_list_response.dart';
import 'model/movie_details_response.dart';
import 'model/poplar_movie_model.dart';
import 'model/user_model.dart';

class ApiManager{
  static Future<PoplarMovieModel> getPopular()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/tv/popular?api_key=1af5751239f6c52b196a77e23dcf8416");

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    PoplarMovieModel sourcesResponse=PoplarMovieModel.fromJson(json);
    return sourcesResponse;
  }

  static Future<PoplarMovieModel> getPopularByName(String name)async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/search/movie?api_key=2b0d978a962d720636b46566d80b8e37&query=$name");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return PoplarMovieModel.fromJson(json.decode(response.body));

    } else {
      throw Exception('Failed to load movies');
    }
  }

  static Future<UpcomingMovies?> getupComing()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/movie/upcoming?api_key=1af5751239f6c52b196a77e23dcf8416&language=en-US&page=1");
    try {
      final response = await http.get(url);
      print("Upcoming Movies API Status: ${response.statusCode}");
      print("Upcoming Movies API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UpcomingMovies.fromJson(data);
      } else {
        throw Exception('Failed to load upcoming movies');
      }
    } catch (e) {
      print('Error fetching movies: $e');
      return null;
    }
  }

  static Future<BrowseListResponse> getBrowseList()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/genre/movie/list?api_key=1af5751239f6c52b196a77e23dcf8416");

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    BrowseListResponse browseListResponse=BrowseListResponse.fromJson(json);
    return browseListResponse;
  }

  static Future<BrowseImageResponse> getBrowseImage(String sourceId) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=1af5751239f6c52b196a77e23dcf8416&with_genres=$sourceId");

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      BrowseImageResponse prowesimageResponse = BrowseImageResponse.fromJson(json);
      return prowesimageResponse;
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<MovieDetailsResponse> getDetails(int movieId) async {
    final Uri url = Uri.parse("https://api.themoviedb.org/3/movie/$movieId?api_key=2b0d978a962d720636b46566d80b8e37");

    http.Response response = await http.get(url);
    print("Movie Details API Response: ${response.body}");
    if (response.statusCode == 200) {
      return MovieDetailsResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load movie details");
    }

  }

  static Future<PoplarMovieModel> getMovies() async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/movie/popular?api_key=2b0d978a962d720636b46566d80b8e37");
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      PoplarMovieModel moviesList = PoplarMovieModel.fromJson(json);
      return moviesList;
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<SimilarMoviesModel> getSimilarMovies(int movieId) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId/similar?api_key=1af5751239f6c52b196a77e23dcf8416");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return SimilarMoviesModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to load similar movies");
      }
    } catch (e) {
      throw Exception("Error: $e");
    }
  }

  static Future<void> updateMoviesWithPosters(PoplarMovieModel? sourcesResponse) async {
    if (sourcesResponse == null || sourcesResponse.results == null) return;

    for (var result in sourcesResponse.results!) {
      if (result.id != null) {
        String? backdropUrl = await fetchMovieBackdrop(result.id!);
        result.backdropPath = backdropUrl; // Update the backdropPath
      }
    }
  }

  static Future<String?> fetchMovieBackdrop(int movieId) async {
    const String apiKey = "1af5751239f6c52b196a77e23dcf8416"; // Replace with your TMDb API Key
    final Uri movieUrl = Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=en-US");
    final Uri tvUrl = Uri.parse(
        "https://api.themoviedb.org/3/tv/$movieId?api_key=$apiKey&language=en-US");
    try {
      final movieResponse = await http.get(movieUrl);
      if (movieResponse.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(movieResponse.body);
        return data['poster_path'] != null
            ? "https://image.tmdb.org/t/p/w500${data['poster_path']}"
            : null;
      }
      final tvResponse = await http.get(tvUrl);
      if (tvResponse.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(tvResponse.body);
        return data['poster_path'] != null
            ? "https://image.tmdb.org/t/p/w500${data['poster_path']}"
            : null;
      }
      print("Error fetching movie details: ${movieResponse.body}");
        return null;
      }
     catch (e) {
      print("Exception: $e");
      return null;
    }
  }

  static Future<Results?> fetchMovieDetails(int movieId) async {
    const String apiKey = "1af5751239f6c52b196a77e23dcf8416"; // Replace with your TMDb API Key

    final Uri url = Uri.parse(
        "https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=en-US");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.isEmpty || data['id'] == null) {
          print("❌ Error: No movie data found for ID: $movieId");
          return null;
        }
        return Results.fromJson(data); // Convert JSON to Results object
      } else {
        print("❌ Error fetching movie details: ${response.body}");
        return null;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>> registerUser(UserModel userModel) async {
    Uri url = Uri.parse("https://route-movie-apis.vercel.app/auth/register");

    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(
              userModel.toJson()
          ));
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print(jsonEncode(userModel.toJson()));  // Debugging: Check the serialized data

      if (response.statusCode == 201||response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage = responseBody["error"] ?? "Registration failed";
        return {
          "success": true,
          "message": errorMessage,
        };
      } else {
        return {
          "success": false,
          "message":"This email already in use",
        };
      }
    } catch (error) {
      return {
        "success": false,
        "message": "An error occurred : $error",
      };
    }
  }

  static Future<bool> resetPassword(String oldPassword, String newPassword) async {
    final Uri url = Uri.parse("https://route-movie-apis.vercel.app/auth/reset-password"); // Replace with actual API

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? authToken = prefs.getString('authToken');

      if (authToken == null) {
        print("❌ Error: No authentication token found.");
        return false;
      }

      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken", // ✅ Include token
        },
        body: jsonEncode({
          "oldPassword": oldPassword,
          "newPassword": newPassword,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Password reset successful!");
        return true;
      } else {
        print("❌ Failed to reset password: ${response.statusCode}, ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Error resetting password: $e");
      return false;
    }
  }


}

