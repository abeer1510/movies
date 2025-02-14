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
import 'package:news/model/detailsimage_response.dart';
import 'package:news/model/sources_response.dart';

class DetailsScreen extends StatelessWidget {
  static const String routName="DetailsScreen";
  final Results movie;
  int? seriesId;



  DetailsScreen({super.key, required this.movie,required this.seriesId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: Icon(Icons.arrow_back_ios_new,color: Colors.white,),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<DetailsImageResponse>(future: ApiManager.getdetailsimage("$seriesId"),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  if(snapshot.hasError){
                    return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
                  }
                  var data = snapshot.data?.logos??[];
                  return Column(
                    children: [
                      Container(
                        height: 400,
                        color: Colors.cyan,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                              child: Text("Watch",style: Theme.of(context).textTheme.titleMedium,),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff282A28),
                              ),
                              child: Row(
                                children: [
                                  Image(image: AssetImage("assets/images/love.png")),
                                  SizedBox(width: 10,),
                                  Text("${movie.popularity}",style: Theme.of(context).textTheme.titleSmall),
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff282A28),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: AssetImage("assets/images/time.png")),
                                  SizedBox(width: 10,),
                                  Text("${movie.voteCount}",style: Theme.of(context).textTheme.titleSmall),
                                ],
                              )),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xff282A28),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image(image: AssetImage("assets/images/star.png")),
                                  SizedBox(width: 10,),
                                  Text("${movie.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
                                ],
                              )),
                        ],),
                      ListView.separated(scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index){
                          return ImageItem(logos: snapshot.data!.logos![index]) ;
                        },itemCount:snapshot.data?.logos?.length??0,
                        separatorBuilder: (context,index)=>SizedBox(height: 10,),),

                      Text(
                          movie.name ?? "No Title",
                          style: Theme.of(context).textTheme.titleMedium),
                      SizedBox(height: 20),
                      Text(movie.overview ?? "No Overview",
                          style: Theme.of(context).textTheme.titleSmall)
                    ],
                  );

                }),





          ],
        ),
      ),
    );
  }
}







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

