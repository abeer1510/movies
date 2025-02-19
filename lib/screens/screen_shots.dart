import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MovieScreenshots extends StatefulWidget {
  final int movieId;

  MovieScreenshots({required this.movieId});

  @override
  _MovieScreenshotsState createState() => _MovieScreenshotsState();
}

class _MovieScreenshotsState extends State<MovieScreenshots> {
  List<String> screenshots = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchMovieImages();
  }

  Future<void> fetchMovieImages() async {
    Uri url = Uri.parse("https://api.themoviedb.org/3/movie/${widget.movieId}/images?api_key=1af5751239f6c52b196a77e23dcf8416");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        List<dynamic> backdrops = jsonData['backdrops'];
        setState(() {

          screenshots = backdrops.map<String>((item) => "https://image.tmdb.org/t/p/w500${item['file_path']}").toList();
          isLoading = false; // ✅ Stop loading

        });
      } else {
        print("Error: ${response.statusCode}");
        setState(() {
          isLoading = false;

          hasError = true;
        });
      }
    } catch (e) {
      print("Failed to fetch images: $e");
      setState(() {
        isLoading = false;

        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator()); // ⏳ Loading...
    }
    if (hasError || screenshots.isEmpty) {
      return Center(child: Text("No images available for this movie.")); // 🚫 No images found
    }
    return SizedBox(
      height: 200, 
      child:ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(imageUrl: screenshots[index], height: 200),
          ),
        );
      }, separatorBuilder: (context,index)=>SizedBox(width: 6,), itemCount: screenshots.length)

      );
  }
}
