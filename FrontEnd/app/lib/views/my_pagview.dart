import 'package:flutter/material.dart';

import '../core/constants/app_theme.dart';
import '../core/constants/top_curve.dart';
import '../routes/routes.dart';
import 'pageview.dart';

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter, 
              child: ClipPath(
                clipper: OnboardingClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  color: Colors.redAccent,
                  
                ),
              ),
            ),
            PageView(
              controller: _pageViewController,
              physics: const NeverScrollableScrollPhysics(), // Disable swiping
              onPageChanged: _handlePageViewChanged,
              children: <Widget>[
                IntroPage(
                  title: 'AI-powered book \ndiscovery',
                  imagurl: 'lib/assets/images/pageview1.png',
                  description: '',
                ),
                IntroPage(
                  title: 'Search by mood \nor voice',
                  imagurl: 'lib/assets/images/pageview2.png',
                  description: '',
                ),
                IntroPage(
                  title: 'Smart picks, seamless \npurchases',
                  imagurl: 'lib/assets/images/pageview3.png',
                  description: '',
                ),
              ],
            ),
            Positioned(
              bottom: 80.0,
              child: TabPageSelector(
                controller: _tabController,
                color: Colors.grey,
                selectedColor: Theme.of(context).primaryColor,
              ),
            ),
            
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: _currentPageIndex != 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30.0), // Adjust position
                  child: FloatingActionButton(
                    heroTag: "backButton",
                    backgroundColor: Colors.white,
                    onPressed: () {
                      if (_currentPageIndex > 0) {
                        _updateCurrentPageIndex(_currentPageIndex - 1);
                      }
                    },
                    shape: const CircleBorder(),
                    child: const Icon(Icons.arrow_back,
                        color: AppTheme.primaryColor, size: 40),
                  ),
                ),
              ),
              const Spacer(),
              FloatingActionButton(
                heroTag: "nextButton",
                backgroundColor: Colors.white,
                onPressed: () {
                  if (_currentPageIndex < 2) {
                    _updateCurrentPageIndex(_currentPageIndex + 1);
                  } else {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  }
                },
                shape: const CircleBorder(),
                child: const Icon(Icons.arrow_forward,
                    color: AppTheme.primaryColor, size: 40),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePageViewChanged(int currentPageIndex) {
    setState(() {
      _currentPageIndex = currentPageIndex;
      _tabController.index = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() {
      _currentPageIndex = index;
    });
  }
}
