import 'package:flutter/material.dart';
import 'package:news/screens/tabs/browse_tab.dart';
import 'package:news/screens/tabs/home_tab.dart';
import 'package:news/screens/tabs/profile_tab.dart';
import 'package:news/screens/tabs/search_tab.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'HomeScreen';
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16)),
        child: Padding(
            padding: EdgeInsets.only(bottom: 8,right: 8,left: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BottomNavigationBar(
                  currentIndex: selectedIndex,
                  onTap: (value){
                    selectedIndex=value;
                    setState(() {});},
                  items: [
                    BottomNavigationBarItem(icon:selectedIndex==0 ?
                    Image(image: AssetImage('assets/images/bottom1.png',),color: Theme.of(context).primaryColor,) :
                    Image(image: AssetImage('assets/images/bottom1.png'),),label: ""),
                    BottomNavigationBarItem(icon:selectedIndex==1 ?
                    Image(image: AssetImage('assets/images/bottom2.png',),color: Theme.of(context).primaryColor,) :
                    Image(image: AssetImage('assets/images/bottom2.png'),),label: ""),
                    BottomNavigationBarItem(icon:selectedIndex==2 ?
                    Image(image: AssetImage('assets/images/bottom3.png',),color: Theme.of(context).primaryColor,) :
                    Image(image: AssetImage('assets/images/bottom3.png'),),label: ""),
                    BottomNavigationBarItem(icon:selectedIndex==3 ?
                    Image(image: AssetImage('assets/images/bottom4.png',),color: Theme.of(context).primaryColor,) :
                    Image(image: AssetImage('assets/images/bottom4.png'),),label: ""),
                  ]),
            )
        ),
      ),

      body: Column(
        children: [
          Expanded(child: tabs[selectedIndex]),
        ],),);
  }
  List<Widget> tabs=[
    HomeTab(),
    SearchTab(),
    BrowseTab(),
    ProfileTab()
  ];
}
