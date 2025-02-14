import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news/model/detailsimage_response.dart';
import 'package:news/model/sources_response.dart';

import 'model/prowesimage_response.dart';
import 'model/prowselist_response.dart';
import 'model/upcoming_response.dart';

class ApiManager{
  static Future<SourcesResponse> getPopular()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/tv/popular?api_key=1af5751239f6c52b196a77e23dcf8416");

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    SourcesResponse sourcesResponse=SourcesResponse.fromJson(json);
    return sourcesResponse;
  }


  static Future<UpcomingResponse> getupComing()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/movie/upcoming?api_key=1af5751239f6c52b196a77e23dcf8416");

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    UpcomingResponse upcomingResponse=UpcomingResponse.fromJson(json);
    return upcomingResponse;
  }

  static Future<prowselistResponse> getprowiselist()async{
    Uri url=Uri.parse("https://api.themoviedb.org/3/genre/movie/list?api_key=1af5751239f6c52b196a77e23dcf8416");

    http.Response response = await http.get(url);
    var json =jsonDecode(response.body);
    prowselistResponse proweslistResponse=prowselistResponse.fromJson(json);
    return proweslistResponse;
  }


  static Future<prowseimageResponse> getprowiseimage(String sourceId) async {
    Uri url = Uri.parse(
        "https://api.themoviedb.org/3/discover/movie?api_key=1af5751239f6c52b196a77e23dcf8416&with_genres=$sourceId");

    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      prowseimageResponse prowesimageResponse = prowseimageResponse.fromJson(json);
      return prowesimageResponse;
    } else {
      throw Exception("Failed to load movies");
    }
  }

  static Future<DetailsImageResponse> getdetailsimage(String sourceId) async {
    Uri url = Uri.parse("https://api.themoviedb.org/3/network/$sourceId/images?api_key=1af5751239f6c52b196a77e23dcf8416");

    http.Response response = await http.get(url);
    var json = jsonDecode(response.body);
    DetailsImageResponse detailsimageResponse = DetailsImageResponse.fromJson(json);
    return detailsimageResponse;
  }



  static Future<List<Map<String, dynamic>>> getTvShowVideos(int seriesId) async {
     String apiKey = "1af5751239f6c52b196a77e23dcf8416";
     String baseUrl = "https://api.themoviedb.org/3";
  Uri url = Uri.parse("$baseUrl/tv/$seriesId/videos?api_key=$apiKey");

  final response = await http.get(url);
     print("API Response Code: ${response.statusCode}");
     print("API Response Body: ${response.body}");
  if (response.statusCode == 200) {
  final jsonData = jsonDecode(response.body);
  print("Parsed Videos: ${jsonData['results']}");
  return List<Map<String, dynamic>>.from(jsonData['results']);
  } else {
  throw Exception("Failed to load TV show videos");
  }
  }

}

