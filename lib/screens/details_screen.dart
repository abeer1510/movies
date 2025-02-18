// import 'package:flutter/material.dart';
// import 'package:news/model/sources_response.dart';
//
// class DetailsScreen extends StatelessWidget {
//   static const String routName="DetailsScreen";
//   final Results movie;
//   int? seriesId;
//
//
//   DetailsScreen({super.key, required this.movie,required this.seriesId});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 400,
//               color: Colors.cyan,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                           child: Text("Watch",style: Theme.of(context).textTheme.titleMedium,),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             children: [
//                               Image(image: AssetImage("assets/images/love.png")),
//                               SizedBox(width: 10,),
//                               Text("${movie.popularity}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(image: AssetImage("assets/images/time.png")),
//                               SizedBox(width: 10,),
//                               Text("${movie.voteCount}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(image: AssetImage("assets/images/star.png")),
//                               SizedBox(width: 10,),
//                               Text("${movie.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                     ],),
//                   Text(
//                       movie.name ?? "No Title",
//                       style: Theme.of(context).textTheme.titleMedium),
//                   SizedBox(height: 20),
//                   Text(movie.overview ?? "No Overview",
//                       style: Theme.of(context).textTheme.titleSmall),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/items/image_item.dart';
import 'package:news/model/image_response.dart';
import 'package:news/model/movie_details_response.dart';
import 'package:news/model/sources_response.dart';
import 'package:news/screens/screen_shots.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class DetailsScreen extends StatefulWidget {
  static const String routName = "DetailsScreen";
  final int movieId;
  final Results movie;

  DetailsScreen({super.key, required this.movieId, required this.movie});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<ImageResponse> movieImagesFuture;
  late Future<MovieDetailsResponse> movieDetailsFuture;
  late Future<SourcesResponse> movieSourcesFuture;

  @override
  void initState() {
    super.initState();
    movieImagesFuture = ApiManager.getMovieImages(widget.movieId);
    movieDetailsFuture = ApiManager.getDetails(widget.movieId);
    movieSourcesFuture = ApiManager.getPopular();
  }

  @override
  Widget build(BuildContext context) {
    final movieId = widget.movieId;
    final movie = widget.movie;
    var userProvider=Provider.of<UserProvider>(context,listen: false);

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  movie.posterPath != null
                      ? Image.network("https://image.tmdb.org/t/p/w500${movie.posterPath}",height: 300,width: double.infinity)
                      : Placeholder(fallbackHeight: 200, fallbackWidth: double.infinity),
                  Icon(Icons.play_circle_outline,color:Theme.of(context).primaryColor,size: 50,),
                ],
              ),
              Text(movie.name ?? "No Title", style: Theme.of(context).textTheme.headlineMedium),
              Text(
                movie.firstAirDate != null && movie.firstAirDate!.length >= 4
                    ? movie.firstAirDate!.substring(0, 4)
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
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                      userProvider.addToFavorites(movieId);
                    },
                    child:
                    infoContainer(Icon(Icons.favorite_border,color: Theme.of(context).primaryColor,), movie.voteCount,context),
                  ),
                  infoContainer(Icon(Icons.timer_outlined,color: Theme.of(context).primaryColor), movie.runtimeType,context),
                  infoContainer(Icon(Icons.star,color: Theme.of(context).primaryColor), movie.voteAverage,context),
                ],
              ),
              SizedBox(height: 10),
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
      ),
    );
  }

  infoContainer(Icon Icon,  dynamic value, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Color(0xff282A28),
      ),
      child: Row(
        children: [
          Icon,
          SizedBox(width: 10),
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

































// import 'package:flutter/material.dart';
// import 'package:news/api_manager.dart';
// import 'package:news/items/image_item.dart';
// import 'package:news/model/image_response.dart';
// import 'package:news/model/movie_details_response.dart';
// import 'package:news/model/sources_response.dart';
//
// class DetailsScreen extends StatefulWidget {
//   static const String routName = "DetailsScreen";
//   final int movieId;
//   Results movie;
//
//   DetailsScreen({super.key, required this.movieId,required this .movie,});
//
//   @override
//   State<DetailsScreen> createState() => _DetailsScreenState();
// }
//
// class _DetailsScreenState extends State<DetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ImageResponse>(
//       future: ApiManager.getMovieImages(widget.movieId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasError) {
//           return Center(child: Text("Error: ${snapshot.error}"));
//         }
//
//         var data = snapshot.data?.backdrops??[];
//
//
//         return FutureBuilder<MovieDetailsResponse>(
//           future: ApiManager.getDetails(widget.movieId),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }
//
//             var movieDetails = snapshot.data;
//             if (movieDetails == null) {
//               return Center(child: Text("No details available"));
//             }
//
//             return FutureBuilder<SourcesResponse>(
//               future: ApiManager.getPopular(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 }
//
//                 var movieDetails = snapshot.data;
//                 if (movieDetails == null) {
//                   return Center(child: Text("No details available"));
//                 }
//
//                 return Scaffold(
//                   appBar: AppBar(),
//                   body: Column(
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Image.network("https://image.tmdb.org/t/p/w500${widget.movie.posterPath}"??""),
//                       Column(
//                         children: [
//                           Image(image: AssetImage("assets/images/video.png")),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Text(
//                       widget.movie.name ?? "No Title",
//                       style: Theme.of(context).textTheme.titleLarge),
//                   Text(
//                     widget.movie.firstAirDate != null && widget.movie.firstAirDate!.length >= 4
//                         ? widget.movie.firstAirDate!.substring(0, 4)
//                         : "No Date",
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                           child: Text("Watch",style: Theme.of(context).textTheme.titleMedium,),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             children: [
//                               Image(image: AssetImage("assets/images/love.png")),
//                               SizedBox(width: 10,),
//                               Text("${widget.movie.popularity}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(image: AssetImage("assets/images/time.png")),
//                               SizedBox(width: 10,),
//                               Text("${widget.movie.voteCount}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(image: AssetImage("assets/images/star.png")),
//                               SizedBox(width: 10,),
//                               Text("${widget.movie.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                     ],),
//                   SizedBox(height: 10,),
//                   Row(
//                     children: [
//                       Text("Screen Shots",style: Theme.of(context).textTheme.titleMedium!.
//                       copyWith(fontWeight: FontWeight.w700),),
//                     ],
//                   ),
//                   Container(
//                     height: 300,
//                     color: Colors.cyanAccent,
//                   ),
//                   Row(
//                     children: [
//                       Text("Similar ",style: Theme.of(context).textTheme.titleMedium!.
//                       copyWith(fontWeight: FontWeight.w700),),
//                     ],
//                   ),
//                   Container(
//                     height: 300,
//                     color: Colors.cyanAccent,
//                   ),
//                   Row(
//               children: [
//               Text("Summary ",style: Theme.of(context).textTheme.titleMedium!.
//               copyWith(fontWeight: FontWeight.w700),),
//               ],),
//                   ImageItem(backdrops: snapshot.data!.backdrops![index]),
//                   SizedBox(height: 20),
//                   Text(widget.movie.overview ?? "No Overview",
//                       style: Theme.of(context).textTheme.titleSmall),
//
//                 ],
//                ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:news/api_manager.dart';
// import 'package:news/items/image_item.dart';
// import 'package:news/items/similar_item.dart';
// import 'package:news/model/image_response.dart';
// import 'package:news/model/movieSimilar_Response.dart';
// import 'package:news/model/browse_image_response.dart';
// import 'package:news/model/sources_response.dart';
// import 'package:news/model/upcoming_response.dart';
//
// class DetailsScreen extends StatefulWidget {
//   static const String routName="DetailsScreen";
//   final Results movie;
//   int movieId;
//
//
//
//   DetailsScreen({super.key, required this.movie,  required this.movieId});
//
//   @override
//   State<DetailsScreen> createState() => _DetailsScreenState();
// }
//
// class _DetailsScreenState extends State<DetailsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<ImageResponse>(
//         future: ApiManager.getMovieImages(widget.movieId),
//     builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//     return Center(child: CircularProgressIndicator());
//     }
//     if (snapshot.hasError) {
//     return Center(child: Text("Error: ${snapshot.error}"));
//     }
//
//     var movieDetails = snapshot.data;
//     if (movieDetails == null) {
//     return Center(child: Text("No details available"));}
//
//
//     return Scaffold(
//       appBar: AppBar(leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),),
//       body: SingleChildScrollView(
//         child:Column(
//                 children: [
//                   Stack(
//                     alignment: Alignment.center,
//                     children: [
//                       Image.network("https://image.tmdb.org/t/p/w500${widget.movie.posterPath}"??""),
//                       Column(
//                         children: [
//                           Image(image: AssetImage("assets/images/video.png")),
//                         ],
//                       ),
//                     ],
//                   ),
//                   Text(
//                       widget.movie.name ?? "No Title",
//                       style: Theme.of(context).textTheme.titleLarge),
//                   Text(
//                     widget.movie.firstAirDate != null && widget.movie.firstAirDate!.length >= 4
//                         ? widget.movie.firstAirDate!.substring(0, 4)
//                         : "No Date",
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                           child: Text("Watch",style: Theme.of(context).textTheme.titleMedium,),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10,),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             children: [
//                               Image(image: AssetImage("assets/images/love.png")),
//                               SizedBox(width: 10,),
//                               Text("${widget.movie.popularity}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(image: AssetImage("assets/images/time.png")),
//                               SizedBox(width: 10,),
//                               Text("${widget.movie.voteCount}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                       Container(
//                           padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(10),
//                             color: Color(0xff282A28),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image(image: AssetImage("assets/images/star.png")),
//                               SizedBox(width: 10,),
//                               Text("${widget.movie.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
//                             ],
//                           )),
//                     ],),
//                   SizedBox(height: 10,),
//                   Row(
//                     children: [
//                       Text("Screen Shots",style: Theme.of(context).textTheme.titleMedium!.
//                       copyWith(fontWeight: FontWeight.w700),),
//                     ],
//                   ),
//                   Container(
//                     height: 300,
//                     color: Colors.cyanAccent,
//                   ),
//                   Row(
//                     children: [
//                       Text("Similar ",style: Theme.of(context).textTheme.titleMedium!.
//                       copyWith(fontWeight: FontWeight.w700),),
//                     ],
//                   ),
//                   Container(
//                     height: 300,
//                     color: Colors.cyanAccent,
//                   ),
//                   Row(
//               children: [
//               Text("Summary ",style: Theme.of(context).textTheme.titleMedium!.
//               copyWith(fontWeight: FontWeight.w700),),
//               ],),
//                   SizedBox(
//                     height: 300,
//                     child: ListView.separated(
//                       shrinkWrap: true,
//                       physics: NeverScrollableScrollPhysics(),
//                       itemBuilder: (context,index){
//                         return ImageItem(backdrop: snapshot.data!.backdrops![index]) ;
//                       },itemCount:snapshot.data?.backdrops?.length??0,
//                       separatorBuilder: (context,index)=>SizedBox(height: 10,),),
//                   ),
//
//                   SizedBox(height: 20),
//                   Text(widget.movie.overview ?? "No Overview",
//                       style: Theme.of(context).textTheme.titleSmall),
//
//                 ],
//                );
//
//             }),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:news/api_manager.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// import '../model/sources_response.dart';
//
// class DetailsScreen extends StatefulWidget {
//     static const String routName="DetailsScreen";
//      Results movie;
//     final int seriesId;
//    DetailsScreen({super.key, required this.seriesId,required this.movie});
//
//   @override
//   State<DetailsScreen> createState() => _DetailsScreenState();
// }
// class _DetailsScreenState extends State<DetailsScreen> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   String? videoUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadVideo();
//   }
//   Future<void> _loadVideo() async {
//     try {
//       final videos = await ApiManager.getTvShowVideos(widget.seriesId);
//       print("Videos: $videos");
//
//       if (videos.isNotEmpty) {
//         final video = videos.firstWhere(
//               (video) => video['type'] == 'Trailer' || video['type'] == 'Teaser' || video['type'] == 'Clip',
//           orElse: () => {},
//         );
//
//         if (video.isNotEmpty) {
//           final videoKey = video['key'];
//           setState(() {
//             videoUrl = "https://www.youtube.com/watch?v=$videoKey";
//             _videoPlayerController = VideoPlayerController.network(videoUrl!)
//               ..initialize().then((_) {
//                 setState(() {
//                   _chewieController = ChewieController(
//                     videoPlayerController: _videoPlayerController,
//                     autoPlay: true,
//                     looping: false,
//                   );
//                 });
//               });
//           });
//         } else {
//           print(" No Trailer, Teaser, or Clip found");
//         }
//       } else {
//         print(" No videos available for this series");
//       }
//     } catch (e) {
//       print("Error loading video: $e");
//     }
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     _chewieController?.dispose();
//     super.dispose();
//   }
//   // videoUrl == null
//   // ? CircularProgressIndicator()
//   //     : Chewie(controller: _chewieController!),
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Series Details")),
//     body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: 400,
//               color: Colors.cyan,
//             ),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 16),
//              child: Column(
//                children: [
//                  Row(
//                    children: [
//                      Expanded(
//                        child: ElevatedButton(
//                          onPressed: () {},
//                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                          child: Text("Watch",style: Theme.of(context).textTheme.titleMedium,),
//                        ),
//                      ),
//                    ],
//                  ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                    children: [
//                    Container(
//                        padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10),
//                          color: Color(0xff282A28),
//                        ),
//                        child: Row(
//                          children: [
//                            Image(image: AssetImage("assets/images/love.png")),
//                            SizedBox(width: 10,),
//                            Text("${movie.popularity}",style: Theme.of(context).textTheme.titleSmall),
//                          ],
//                        )),
//                    Container(
//                        padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                        decoration: BoxDecoration(
//                          borderRadius: BorderRadius.circular(10),
//                          color: Color(0xff282A28),
//                        ),
//                        child: Row(
//                          mainAxisAlignment: MainAxisAlignment.center,
//                          children: [
//                            Image(image: AssetImage("assets/images/time.png")),
//                            SizedBox(width: 10,),
//                            Text("${movie.voteCount}",style: Theme.of(context).textTheme.titleSmall),
//                          ],
//                        )),
//                      Container(
//                          padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
//                          decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Color(0xff282A28),
//                          ),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.center,
//                            children: [
//                              Image(image: AssetImage("assets/images/star.png")),
//                              SizedBox(width: 10,),
//                              Text("${movie.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
//                            ],
//                          )),
//                  ],),
//                  Text(
//                      movie.name ?? "No Title",
//                      style: Theme.of(context).textTheme.titleMedium),
//                  SizedBox(height: 20),
//                  Text(movie.overview ?? "No Overview",
//                      style: Theme.of(context).textTheme.titleSmall),
//                ],
//              ),
//            )
//           ],
//         ),
//       ),
//     );
//   }
// }

