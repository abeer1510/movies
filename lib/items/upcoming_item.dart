import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news/model/sources_response.dart';
import 'package:news/model/upcoming_response.dart';
import 'package:news/screens/details_screen.dart';

class UpcomingItem extends StatelessWidget {
  Results results;
  UpcomingItem({super.key,required this.results});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [

                GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                        context, DetailsScreen.routName,
                      );                  },
                    child: Image.network("https://image.tmdb.org/t/p/w500${results.posterPath}"??"",fit: BoxFit.fill,height: 220,width: 150,)),

                Padding(
                  padding: const EdgeInsets.only(top: 13,left: 14),
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 7),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xB5121312),
                      ),
                      child: Row(
                        children: [
                          Text("${results.voteAverage}",style: Theme.of(context).textTheme.titleSmall),
                          Image(image: AssetImage("assets/images/star1.png"))
                        ],
                      )),
                ),
              ],
            ))
      ],
    );
  }
}