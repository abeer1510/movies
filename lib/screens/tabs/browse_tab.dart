import 'package:flutter/material.dart';
import 'package:news/api_manager.dart';
import 'package:news/items/prowse_item.dart';
import 'package:news/model/browse_image_response.dart';
import '../../model/browse_list_response.dart';

class BrowseTab extends StatefulWidget {
  BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  int selectedindex = 0;
  Map<int, List<Results2>> cachedData = {};
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: FutureBuilder<BrowseListResponse>(
          future: ApiManager.getBrowseList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                "Something Went Wrong",
                style: Theme.of(context).textTheme.titleLarge,
              ));
            }
            var data = snapshot.data?.genres ?? [];
            if (data.isEmpty) return SizedBox();
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: DefaultTabController(
                initialIndex: selectedindex,
                length: data.length,
                child: Column(
                  children: [
                    TabBar(
                        isScrollable: true,
                        onTap: (value) {
                          setState(() {
                            selectedindex = value;
                            if (!cachedData
                                .containsKey(data[selectedindex].id)) {
                              fetchData(data[selectedindex].id ?? 0);
                            }
                          });
                        },
                        dividerColor: Colors.transparent,
                        unselectedLabelColor: Theme.of(context).primaryColor,
                        labelColor: Color(0xff000000),
                        indicator: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context).primaryColor, width: 3),
                        ),
                        tabs: data.map((genres) {
                          bool isSelected =
                              data.indexOf(genres) == selectedindex;
                          return Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 13),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                "${genres.name}",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: isSelected
                                          ? Color(0xff000000)
                                          : Theme.of(context).primaryColor,
                                    ),
                              ));
                        }).toList()),
                    SizedBox(
                      height: 16,
                    ),
                    isLoading
                        ? Center(child: CircularProgressIndicator())
                        : FutureBuilder<BrowseImageResponse>(
                            future: ApiManager.getBrowseImage(
                                "${data[selectedindex].id}" ?? ""),
                            builder: (context, snapshot) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 16,
                                      childAspectRatio: .7,
                                    ),
                                    itemBuilder: (context, index) {
                                      return ProwseItem(
                                          results:
                                              snapshot.data!.results![index]);
                                    },
                                    itemCount:
                                        snapshot.data?.results?.length ?? 0,
                                  ),
                                ),
                              );
                            }),
                  ],
                ),
              ),
            );
          }),
    ));
  }

  void fetchData(int genreId) async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await ApiManager.getBrowseImage(genreId.toString());
      setState(() {
        cachedData[genreId] = response.results ?? [];
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
