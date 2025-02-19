

import 'package:flutter/material.dart';
import 'package:news/screens/screen_shots.dart';
import 'package:provider/provider.dart';

import '../api_manager.dart';
import '../model/movie_details_response.dart';
import '../provider/auth_provider.dart';

class DetailsScreen extends StatefulWidget {
  static const String routName = "DetailsScreen";
  final int movieId;

  DetailsScreen({super.key, required this.movieId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<MovieDetailsResponse> movieDetailsFuture;
  late bool isFavorite=false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkIfFavorite();
    });
    movieDetailsFuture = ApiManager.getDetails(widget.movieId);
  }
  Future<void> checkIfFavorite() async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    bool exists = await userProvider.isFavorite(widget.movieId);
    setState(() {
      isFavorite = exists;
    });
  }
  Future<void> toggleFavorite(MovieDetailsResponse movie) async {
    var userProvider = Provider.of<UserProvider>(context, listen: false);

    if (isFavorite) {
      await userProvider.removeFromFavorites(widget.movieId);
    } else {
      await userProvider.addToFavorites(
        movieId: widget.movieId,
        name: movie.title ?? "No Title",
        rating: movie.voteAverage ?? 0.0,
        imageURL: movie.posterPath ?? "",
        year: movie.releaseDate?.substring(0, 4) ?? "Unknown",
      );
    }
    setState(() {
      isFavorite = !isFavorite;
    });
  }
  @override
  Widget build(BuildContext context) {
    final movieId = widget.movieId;
    var userProvider=Provider.of<UserProvider>(context,listen: false);

    return Scaffold(
        appBar: AppBar(),
        body: FutureBuilder<MovieDetailsResponse>(
            future: movieDetailsFuture,
            builder: (context,snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No movie details available"));
              }
              var movie=snapshot.data!;
              return       SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          movie.posterPath != null
                              ? Image.network("https://image.tmdb.org/t/p/w500${movie.posterPath}",height: 300,width: double.infinity)
                              : const Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
                          Icon(Icons.play_circle_outline,color:Theme.of(context).primaryColor,size: 50,),
                        ],
                      ),
                      Text(movie.title ?? "No Title", style: Theme.of(context).textTheme.headlineMedium),
                      Text(
                        movie.releaseDate != null && movie.releaseDate!.length >= 4
                            ? movie.releaseDate!.substring(0, 4)
                            : "No Date",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                userProvider.addToHistory(movieId);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),
                              )),
                              child: Text("Watch", style: Theme.of(context).textTheme.headlineMedium),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(

                            onTap: (){
                              toggleFavorite(movie);
                             /* userProvider.addToFavorites(movieId: movieId,name: movie.title??"No Title",
                              rating: movie.voteAverage??0,imageURL: movie.posterPath??"",
                                  year: movie.releaseDate != null && movie.releaseDate!.length >= 4
                                      ? movie.releaseDate!.substring(0, 4)
                                      : "No Date");*/
                            },
                            child:
                            infoContainer(isFavorite==true?Icon(Icons.favorite,color: Theme.of(context).primaryColor,):Icon(Icons.favorite_border,color: Theme.of(context).primaryColor,), movie.voteCount,context),
                          ),
                          infoContainer(Icon(Icons.timer_outlined,color: Theme.of(context).primaryColor), movie.runtime,context),
                          infoContainer(Icon(Icons.star,color: Theme.of(context).primaryColor), movie.voteAverage,context),
                        ],
                      ),
                      const SizedBox(height: 10),
                      sectionTitle("Screen Shots"),
                      MovieScreenshots(movieId: movieId),
                      sectionTitle("Similar"),
                      sectionTitle("Summary"),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(movie.overview ?? "No Overview",
                            style: Theme.of(context).textTheme.titleSmall),
                      ),
                    ],
                  ),
                ),
              );

            })

    );
  }

  infoContainer(Icon Icon,  dynamic value, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff282A28),
      ),
      child: Row(
        children: [
          Icon,
          const SizedBox(width: 10),
          Text( value != null ? value.toString() : "N/A", style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }

  sectionTitle(String title) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}
