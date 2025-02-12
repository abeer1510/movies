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
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              Stack(
                children: [
                  Image(image: AssetImage("assets/images/onboarding6.png"),),
                  Column(
                    children: [
                      Image(image: AssetImage("assets/images/available.png")),
                      FutureBuilder<SourcesResponse>(future: ApiManager.getPopular(),
                          builder: (context,snapshot){
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator());
                            }
                            if(snapshot.hasError){
                              return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
                            }
                            var data = snapshot.data?.results??[];
                            return Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                CarouselSlider.builder(
                                  itemBuilder: (context,index,realIndex){
                                    return MovieItem(results: snapshot.data!.results![index]);},
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
                              ],);
                          }),
                      Padding(
                        padding: const EdgeInsets.only(right: 16,left: 16,bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Action",style: Theme.of(context).textTheme.titleMedium,),
                            Row(
                              children: [
                                Text("See More ",style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).primaryColor),),
                                Icon(Icons.arrow_forward,color: Theme.of(context).primaryColor)
                              ],
                            )

                          ],
                        ),
                      ),
                      FutureBuilder(future: ApiManager.getupComing(), builder: (context,snapshot){
                        return SizedBox(
                          height: 230,
                          child: ListView.separated(scrollDirection: Axis.horizontal,
                            itemBuilder: (context,index){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return Center(child: CircularProgressIndicator());
                              }
                              if(snapshot.hasError){
                                return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
                              }
                              var data = snapshot.data?.results??[];
                              return UpcomingItem(results: snapshot.data!.results![index]) ;
                            },itemCount:snapshot.data?.results?.length??0,
                            separatorBuilder: (context,index)=>SizedBox(width: 10,),),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ],
          ),
        )
      ],),
    )
    ;}
}
