import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import '../../items/movie_item.dart';
import '../../model/poplar_movie_model.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  TextEditingController searchController = TextEditingController();
  List<Results> moviesSearchList = [];
  bool _isLoading = false;
  bool _showImage = true;
  Timer? _debounce;
  bool _searched = false;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _isLoading = true;
        _showImage = searchController.text.isEmpty;
        _searched = false;
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
    });
  }

  Future<void> _searchMovies(String query) async {
    try {
      PoplarMovieModel response = await ApiManager.getPopularByName(query);
      setState(() {
        moviesSearchList = response.results!;
        _isLoading = false;
        _searched = true;
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
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () => _searchMovies(searchController.text.trim()),
                ),
                hintText: "Search...",
                filled: true,
                fillColor: const Color(0xff282A28),
                hintStyle: const TextStyle(
                    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              onChanged: (text) {
                setState(() {
                  _showImage = text.isEmpty;
                });
              },
            ),
            if (_showImage)
              Padding(
                padding: const EdgeInsets.only(top: 180),
                child: Center(
                  child: Image.asset(
                    "assets/images/empty.png",
                    width: 200,
                    height: 200,
                  ),
                ),
              ),

            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : moviesSearchList.isEmpty && _searched
                  ? const Center(
                child: Text(
                  "No Movies Found",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: moviesSearchList.length,
                itemBuilder: (context, index) {
                  return MovieItem(
                    movieId: moviesSearchList[index].id ?? 0,
                    voteAverage: moviesSearchList[index].voteAverage ?? 0,
                    movieImage: moviesSearchList[index].posterPath ?? "",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

























































// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:news/api_manager.dart';
// import '../../items/movie_item.dart';
// import '../../model/poplar_movie_model.dart';
//
// class SearchTab extends StatefulWidget {
//   const SearchTab({super.key});
//
//   @override
//   State<SearchTab> createState() => _SearchTabState();
// }
//
// class _SearchTabState extends State<SearchTab> {
//
//   TextEditingController searchController = TextEditingController();
//   List<Results> moviesSearchList = [];
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     searchController.addListener(_onSearchChanged);
//
//
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       _isLoading = true;
//     });
//     String query = searchController.text.trim();
//     if (query.isNotEmpty) {
//       _searchMovies(query);
//     } else {
//       setState(() {
//         moviesSearchList = [];
//         _isLoading = false;
//       });
//     }
//   }
//
//   Future<void> _searchMovies(String query) async {
//     try {
//       PoplarMovieModel response = await ApiManager.getPopularByName(searchController.text);
//       setState(() {
//         moviesSearchList = response.results!;
//         _isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//       });
//       debugPrint('Error: $e');
//     }
//   }
//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }
//
//
//     @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(padding: const EdgeInsets.only(top: 50,right: 20,left: 20),
//       child:Column(
//         children: [
//           TextField(
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//             controller: searchController,
//             decoration: InputDecoration(
//               prefixIcon:  IconButton(
//                 icon: const ImageIcon(AssetImage("assets/images/bottom2.png"),color: Colors.white,),
//
//                 onPressed: (){
//                   _searchMovies(searchController.text.trim());
//                 },
//               ),
//               filled: true,
//               fillColor: Color(0xff282A28),
//                 hintText: "Search",
//                 hintStyle: const TextStyle(
//                     color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     ),
//                 focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(15),
//                     ),
//             ),
//           ),
//
//          FutureBuilder<PoplarMovieModel>(future: ApiManager.getPopularByName(searchController.text),
//              builder: (context,snapshot){
//                if(snapshot.connectionState == ConnectionState.waiting){
//                  return const Center(child: CircularProgressIndicator());
//                }
//                if(snapshot.hasError){
//                  return Center(child: Text("Something Went Wrong",style: Theme.of(context).textTheme.titleLarge,));
//                }
//                var movies = snapshot.data?.results??[];
//                return Expanded(
//                  child: GridView.builder(gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                    crossAxisCount: 2, // Number of columns
//                    childAspectRatio: 0.6, // Adjust height to width ratio
//                    crossAxisSpacing: 10,
//                    mainAxisSpacing: 10,
//                  ),itemCount: movies.length,
//                  itemBuilder: (context,index){
//                    return MovieItem(movieId:movies[index].id??0 ,voteAverage: movies[index].voteAverage??0,movieImage: movies[index].posterPath??"",);
//
//                  },)
//                );
//              })
//         ],
//       ),),
//     );
//   }
//
//   Widget _searchItem() {
//     return
//       TextField(
//
//         style: const TextStyle(
//             color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//         controller: searchController,
//         cursorColor: Colors.white,
//         decoration: InputDecoration(
//           prefixIcon: const Icon(Icons.search,
//             color: Colors.white,
//           ),
//           hintText: "Search",
//           filled: true,
//           fillColor: Color(0xff282A28),
//           hintStyle: const TextStyle(
//               color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),),
//           focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(15),
//         ),),
//       );
//
//
//   }
//
// }