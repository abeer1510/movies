import 'package:flutter/material.dart';
import '../screens/details_screen.dart';

class MovieItem extends StatelessWidget {
  int movieId;
  String movieImage;
  double voteAverage;

  MovieItem({super.key, required this.movieId,required this.movieImage,required this.voteAverage});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          DetailsScreen(
                            movieId: movieId,
                          ),
                    ),
                  );
                },
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${movieImage}" ?? "",
                  fit: BoxFit.fill,
                  height: 300,
                  width: 230,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13, left: 14),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 9),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xB5121312),
                    ),
                    child: Row(
                      children: [
                        Text("${voteAverage}",
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall),
                        Icon(Icons.star,color: Theme.of(context).primaryColor,)
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}