import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/items/movie_item.dart';
import 'package:provider/provider.dart';

import '../model/poplar_movie_model.dart';
import '../provider/auth_provider.dart';
import 'details_screen.dart';

class HistoryScreen extends StatelessWidget {
  static const String routName = "HistoryScreen";
   HistoryScreen({super.key});
  final Map<int, Future<Results?>> _movieCache = {}; // Cache movie details

  Future<Results?> getMovieDetails(int movieId) {
    if (!_movieCache.containsKey(movieId)) {
        _movieCache[movieId] = ApiManager.fetchMovieDetails(movieId);
    }
    return _movieCache[movieId]!;
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              isScrollable: false,
              dividerColor: Colors.transparent,
              indicatorColor: Theme.of(context).primaryColor,
              labelPadding: EdgeInsets.zero,
              tabs: [
                Column(
                  children: [
                    Icon(Icons.list, color: Theme.of(context).primaryColor),
                    SizedBox(height: 4),
                    Text(
                      "Watch List",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.folder, color: Theme.of(context).primaryColor),
                    SizedBox(height: 4),
                    Text(
                      "History",
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildGridView(userProvider.favorites),
                  _buildGridView(userProvider.history),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildGridView(List<int> movieIds) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movieIds.length,
      itemBuilder: (context, index) {
        int movieId = movieIds[index];

        return FutureBuilder<Results?>(
          future: getMovieDetails(movieId), // Using the cached Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Icon(Icons.error, size: 40));
            } else {
              return  ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailsScreen(
                              movieId: movieId,
                            ),
                      ),
                    );
                  },
                  child: Image.network(
                    "https://image.tmdb.org/t/p/w500${snapshot.data!.posterPath}" ?? "",
                    fit: BoxFit.fill,
                    height: 300,
                    width: 230,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
