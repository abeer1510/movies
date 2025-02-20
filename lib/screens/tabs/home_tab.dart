import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/items/movie_item.dart';
import 'package:news/model/upcoming_movies.dart';

import '../../model/poplar_movie_model.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const Image(
                        image: AssetImage("assets/images/movie_poster.jpg"),
                      ),
                      Column(
                        children: [
                          const Image(
                              image: AssetImage("assets/images/available.png")),
                          FutureBuilder<PoplarMovieModel>(
                              future: ApiManager.getMovies(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError) {
                                  return Center(
                                      child: Text(
                                    "Something Went Wrong",
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ));
                                }
                                var movies = snapshot.data?.results ?? [];
                                return Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    CarouselSlider.builder(
                                      itemBuilder: (context, index, realIndex) {
                                        return MovieItem(
                                          movieId: movies[index].id ?? 0,
                                          voteAverage:
                                              movies[index].voteAverage ?? 0,
                                          movieImage:
                                              movies[index].posterPath ?? "",
                                        );
                                      },
                                      itemCount:
                                          movies.length ?? 0,
                                      options: CarouselOptions(
                                        height: 440,
                                        autoPlay: false,
                                        enlargeCenterPage: true,
                                        enableInfiniteScroll: false,
                                        scrollDirection: Axis.horizontal,
                                        viewportFraction: 0.55,
                                        aspectRatio: 16 / 9,
                                      ),
                                    ),
                                    const Image(
                                        image: AssetImage(
                                            "assets/images/watch.png")),
                                  ],
                                );
                              }),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 16, left: 16, bottom: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Action",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "See More ",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                              color:
                                                  Theme.of(context).primaryColor),
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: Theme.of(context).primaryColor)
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 250,  // Ensures proper constraints
                            child: FutureBuilder<UpcomingMovies?>(
                                future: ApiManager.getupComing(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.results == null || snapshot.data!.results!.isEmpty) {
                                    return const Center(child: Text('No upcoming movies found.'));
                                  }
                                  print("API Response: ${snapshot.data}"); // ✅ Debugging output

                                  final movies = snapshot.data?.results??[];
                                  if (movies.isEmpty) {
                                    return const Center(child: Text('No upcoming movies found.'));
                                  }
                                  return ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final movie = movies[index];
                                      print("Movie: ${movie.title}, ID: ${movie.id}"); // ✅ Debug each movie
                                      return SizedBox(
                                        width: 120,
                                        child: MovieItem(
                                          movieId: movie.id ?? 0,
                                          voteAverage:
                                          movie.voteAverage ?? 0,
                                          movieImage:
                                          movie.posterPath ?? "",
                                        ),
                                      );
                                    },
                                    itemCount:
                                        movies.length,
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(
                                      width: 10,
                                    ),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
