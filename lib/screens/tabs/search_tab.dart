import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/api_manager.dart';
import 'package:news/model/sources_response.dart';

import '../../items/movie_item.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {

  TextEditingController searchController = TextEditingController();
  List<Results> moviesSearchList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      _isLoading = true;
    });
    String query = searchController.text.trim();
    if (query.isNotEmpty) {
      _searchMovies(query);
    } else {
      setState(() {
        moviesSearchList = [];
        _isLoading = false;
      });
    }
  }

  Future<void> _searchMovies(String query) async {
    try {
      SourcesResponse response = await ApiManager.getPopularByName(searchController.text);
      setState(() {
        moviesSearchList = response.results!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      debugPrint('Error: $e');
    }
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: const EdgeInsets.only(top: 50),
      child:Column(
        children: [
          TextField(
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
            controller: searchController,
            decoration: InputDecoration(
              prefixIcon:  IconButton(
                icon: const Icon(Icons.search,color: Colors.white,),
                onPressed: (){
                  _searchMovies(searchController.text.trim());
                },
              ),
                hintText: "Search",
                hintStyle: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color:Colors.white)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white)),
            ),
          ),
         FutureBuilder<SourcesResponse>(future: ApiManager.getPopularByName(searchController.text),
             builder: (context,snapshot){
               if(snapshot.connectionState == ConnectionState.waiting){
                 return const Center(child: CircularProgressIndicator());
               }
               if(snapshot.hasError){
                 return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
               }
               var data = snapshot.data?.results??[];
               return Expanded(
                 child: ListView.builder(itemBuilder: (context,index){
                   return MovieItem(results: data[index],);
                 },
                 itemCount: data.length,),
               );
             })
         /* if(_isLoading)CircularProgressIndicator(),
          Expanded(child: ListView.builder(
              itemCount: moviesSearchList.length,
              itemBuilder: (context,index){
                final movie = moviesSearchList[index];

                return Text(movie.name??"No title",style: Theme.of(context).textTheme.headlineSmall,);})
          )*/
        ],
      ),),
    );
  }

  Widget _searchItem() {
    return
      TextField(
        style: const TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
        controller: searchController,
        cursorColor: Colors.white,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search,
            color: Colors.white,
          ),
          hintText: "Search",
          hintStyle: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.white),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color:Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white)),
        ),
      );


  }

}
