import 'package:flutter/material.dart';
import 'package:news/model/detailsimage_response.dart';

class ImageItem extends StatelessWidget {
   ImageItem({super.key,required this.logos});
  Logos logos;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        child: Image.network("https://image.tmdb.org/t/p/w500${logos.filePath}"??""),
      ),
    );
  }
}
