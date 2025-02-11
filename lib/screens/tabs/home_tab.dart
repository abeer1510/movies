import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/items/movie_item.dart';
import 'package:news/items/upcoming_item.dart';
import 'package:news/model/sources_response.dart';

import '../../model/upcoming_response.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SourcesResponse>(future: ApiManager.getPopular(),
          builder: (context,snapshot){

          }),
    );
  }
}
