// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:news/model/sources_response.dart';
// import 'package:news/screens/details_screen.dart';
//
// class MovieItem extends StatelessWidget {
//   Results results;
//    MovieItem({super.key,required this.results});
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Stack(children: [
//             ClipRRect(
//               borderRadius: BorderRadius.circular(20),
//                 child: GestureDetector(onTap: ()
//                     {Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => DetailsScreen(movie: results,),),);},
//                     child: Image.network("https://image.tmdb.org/t/p/w500${results.posterPath}"??"",
//                       fit: BoxFit.fill,height: 300,width: 230,))),
//             Padding(
//               padding: const EdgeInsets.only(top: 13,left: 14,),
//               child: Row(
//                 children: [
//                   Container(
//                       padding: EdgeInsets.only(right: 9,left: 9),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(10),
//                         color: Color(0xB5121312),
//                       ),
//                       child: Row(
//                         children: [
//                           Text("${results.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
//                           Image(image: AssetImage("assets/images/star1.png"))
//                         ],
//                       )),
//                   Spacer(),
//                 ],
//               ),
//             ),
//
//           ],
//         ),
//
//       ],
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:news/model/sources_response.dart';
import 'package:news/screens/details_screen.dart';

class MovieItem extends StatelessWidget {
  final Results results;

  MovieItem({super.key, required this.results});

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
                             seriesId: results.id,
                            movie: results,
                          ),
                    ),
                  );
                },
                child: Image.network(
                  "https://image.tmdb.org/t/p/w500${results.posterPath}" ?? "",
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
                        Text("${results.voteAverage}",
                            style: Theme
                                .of(context)
                                .textTheme
                                .titleSmall),
                        Image.asset("assets/images/star1.png"),
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