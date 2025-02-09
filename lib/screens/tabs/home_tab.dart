import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/items/movie_item.dart';
import 'package:news/model/sources_response.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<SourcesResponse>
        (future: ApiManager.getPopular(),
          builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.hasError){
            return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
          }
          var data = snapshot.data?.results??[];
          return DefaultTabController(
            length: data.length,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                      itemBuilder: (context,index){
                   return MovieItem(results: snapshot.data!.results![index]);
                  }, separatorBuilder: (context,index)=>SizedBox(width: 10,), itemCount: snapshot.data?.results?.length??0),
                ),
              ],
            ),
          );
          }),
    );
  }
}
