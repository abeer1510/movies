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
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
          }
          var data = snapshot.data?.results??[];
          return Stack(
            children: [
              Image(image: AssetImage("assets/images/background.png"),height: double.infinity,width: double.infinity,fit: BoxFit.fill,),
              Column(
                children: [
                  Image(image: AssetImage("assets/images/available.png")),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CarouselSlider.builder(
                        itemBuilder: (context,index,realIndex){
                            return MovieItem(results: snapshot.data!.results![index]);
                        },
                        itemCount:snapshot.data?.results?.length??0,
                        options: CarouselOptions(
                          height: 440,
                          autoPlay: false,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        scrollDirection: Axis.horizontal,
                        viewportFraction: 0.55,
                          aspectRatio: 16 / 9,
                        ),),
                      Image(image: AssetImage("assets/images/watch.png")),
                    ],
                  ),
                  FutureBuilder(future: ApiManager.getupComing(), builder: (context,snapshot){
                    return ListView.separated(itemBuilder: (context,index){
                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }
                      if(snapshot.hasError){
                        return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
                      }
                      var data = snapshot.data?.results??[];
                      return UpcomingItem(results: snapshot.data!.results![index]) ;
                    },itemCount:snapshot.data?.results?.length,

                      separatorBuilder: (context,index)=>SizedBox(width: 10,),);
                  })

                ],
              ),

            ],
          );
          }),
    );
  }
}
