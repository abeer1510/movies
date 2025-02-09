import 'package:flutter/cupertino.dart';
import 'package:news/model/sources_response.dart';

class MovieItem extends StatelessWidget {
  Results results;
   MovieItem({super.key,required this.results});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(results.backdropPath??"")
      ],
    );
  }
}
