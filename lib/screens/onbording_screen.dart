import 'package:flutter/material.dart';
import 'package:news/screens/login_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName ='OnBoardingScreen';
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage >= 0) {
      _pageController.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }
  void _goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        children: [
          _buildPage(
            containerColor:Colors.transparent,
            containereHeight: 260,
            name: "assets/images/onboarding1.png",
            title: "Find Your Next Favorite Movie Here!",
            description: "Get access to a huge library of movies to suit all tastes. You will surely like it.",
            button1Text: "Explore Now",
            button1Action: _nextPage,
          ),
          // First Page (One Button)
          _buildPage(
            containerColor: Color(0xff121312),
            containereHeight: 260,
            name: "assets/images/onboarding2.png",
            title: "Discover Movies",
            description: "Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.",
            button1Text: "Next",
            button1Action: _nextPage,
          ),

          // Second Page (Two Buttons)
          _buildPage(
            containerColor: Color(0xff121312),
            containereHeight: 320,
            name: "assets/images/onboarding3.png",
            title: "Explore All Genres",
            description: "Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.",
            button1Text: "Next",
            button1Action: _nextPage,
            button2Text: "Back",
            button2Action: _previousPage,
          ),
          _buildPage(
            containerColor: Color(0xff121312),
            containereHeight: 320,
            name: "assets/images/onboarding4.png",
            title: "Create Watchlists",
            description: "Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.",
            button1Text: "Next",
            button1Action: _nextPage,
            button2Text: "Back",
            button2Action: _previousPage,
          ),
          _buildPage(
            containerColor: Color(0xff121312),
            containereHeight: 320,
            name: "assets/images/onboarding5.png",
            title: "Rate, Review, and Learn",
            description: "Share your thoughts on the movies you've watched. Dive deep into film details and help others discover great movies with your reviews.",
            button1Text: "Next",
            button1Action: _nextPage,
            button2Text: "Back",
            button2Action: _previousPage,
          ),
          _buildPage(
            containerColor: Color(0xff121312),
            containereHeight: 200,
            name: "assets/images/onboarding6.png",
            title: "Start Watching Now",
            button2Text: "Back",
            button2Action: _previousPage,
            button1Text: "Finish",
            button1Action: () => _goToLogin(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required Color containerColor,
    required double containereHeight,
    required String name,
    required String title,
    String? description,
    required String button1Text,
    required VoidCallback button1Action,
    String? button2Text,
    VoidCallback? button2Action,
  }) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image(image: AssetImage(name),fit: BoxFit.fitWidth,width: double.infinity,),
      Container(
        padding: EdgeInsets.only(top: 16,right: 16,left: 16),
        width: double.infinity,
        height:containereHeight ,
        decoration: BoxDecoration(
            color:containerColor ,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(40),topRight: Radius.circular(40),)
        ),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge,textAlign: TextAlign.center),
            SizedBox(height: 16),
            if (description != null)
              Text(description, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
            SizedBox(height: 30),
            Column(
              mainAxisAlignment: button2Text == null
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        onPressed: button1Action,
                        child: Text(button1Text,style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Color(0xff121312)),),
                      ),
                    ),
                  ],
                ),
                if (button2Text != null)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            side: BorderSide(color: Theme.of(context).primaryColor),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          onPressed: button2Action,
                          child: Text(button2Text,style: Theme.of(context).textTheme.titleSmall!
                              .copyWith(color: Theme.of(context).primaryColor, ),),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      )
      ],
    );
  }
}