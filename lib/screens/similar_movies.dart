import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/model/similar_movies_model.dart';

import 'details_screen.dart';

class SimilarMovies extends StatelessWidget {
  int movieId;
   SimilarMovies({super.key,required this.movieId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SimilarMoviesModel>(
      future: ApiManager.getSimilarMovies(movieId), // Using the cached Future
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Failed to load similar movies"));
        } else if (!snapshot.hasData || snapshot.data!.results == null || snapshot.data!.results!.isEmpty) {
          return const Center(child: Text("No similar movies found"));
        }
        final movies = snapshot.data!.results!;
        return GridView.builder(
          shrinkWrap: true, // Ensures it doesn't take unnecessary space
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,

          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {final movie = movies[index];
          return  ClipRRect(
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
              child: CachedNetworkImage(imageUrl:
              movie.posterPath != null
                  ? "https://image.tmdb.org/t/p/w500${movie.posterPath}"
                  : "",
                fit: BoxFit.fill,
                height: 300,
                width: 230,
              ),
            ),
          );
          }
          ,
        );
      },
    );
  }



}
