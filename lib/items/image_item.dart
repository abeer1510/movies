import 'package:flutter/material.dart';
import 'package:news/model/image_response.dart';

class ImageItem extends StatelessWidget {
   ImageItem({super.key,required this.backdrops});
   Backdrops backdrops;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ClipRRect(
        child: GestureDetector(

            child: Image.network("https://image.tmdb.org/t/p/w500${backdrops.filePath}"??"")),
      ),
    );
  }
}
