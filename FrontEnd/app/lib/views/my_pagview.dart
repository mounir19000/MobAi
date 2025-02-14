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

    _pageViewController.addListener(() {
      int newIndex = _pageViewController.page!.round();
      if (newIndex != _currentPageIndex) {
        setState(() {
          _currentPageIndex = newIndex;
          _tabController.index = newIndex;
        });
      }
    });
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
              bottom: 110.0,
              child: _buildPageIndicator(),
            ),
          ],
        ),
        floatingActionButton: Container(
          width: double.infinity, // Ensures the Row is centered
          // color: AppTheme.primaryColor,
          padding: const EdgeInsets.fromLTRB(
              40, 10, 0, 20), // Adds spacing
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // Centers the buttons
            children: [
              // Skip button
              SizedBox(
                width: 120,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                  },
                  child: const Text(
                    "skip",
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16), // Reduced spacing between buttons

              // Next button
              SizedBox(
                width: 120,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPageIndex < 2) {
                      _updateCurrentPageIndex(_currentPageIndex + 1);
                    } else {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Custom page indicator with rounded rectangle for selected
  Widget _buildPageIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        bool isSelected = index == _currentPageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 10,
          width: isSelected ? 30 : 10,
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.primaryColor : Colors.grey,
            borderRadius: BorderRadius.circular(10),
          ),
        );
      }),
    );
  }

  void _handlePageViewChanged(int index) {
    setState(() {
      _currentPageIndex = index;
      _tabController.index = index;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
