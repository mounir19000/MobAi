import 'package:app/core/constants/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/constants/top_curve.dart';
import '../core/services/book_service.dart';
import '../state/user_provider.dart';
import '../models/book_model.dart';
import '../widgets/books.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  Stream<List<BookModel>>? _searchResults;
  final BookService _bookService = BookService();
  late TabController _tabController;

  @override
  void initState() {
    _searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _searchBooks(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = null);
    } else {
      setState(() => _searchResults = _bookService.searchBooks(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(330),
            child: Stack(
              children: [
                ClipPath(
                  clipper: InversedOnboardingClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: double.infinity,
                    color: Colors.redAccent,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Image.asset(
                            "lib/assets/images/Logo.png",
                            height: 50,
                            width: 50,
                          ),
                          const SizedBox(width: 20),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Hello, ${userProvider.user?.username}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "What do you want to read today?",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 25),
                      _searchBox(),
                    ],
                  ),
                ),
                
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: TabBar(
                    controller: _tabController,
                    indicatorColor: Color(0xFF0B5268),
                    labelColor: Color(0xFF0B5268),
                    dividerColor: Colors.transparent, 
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: "For you"),
                      Tab(text: "My books"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    BookGrid(),
                    Center(child: Text("My Books", style: TextStyle(fontSize: 18))),
                  ],
                ),
              ),
            ],
          ),
          
        ),
      ),
    );
  }

  Widget _searchBox() {
    return Container(
      height: 55,
      width: kIsWeb ? 450 : double.infinity,
      padding: EdgeInsets.fromLTRB(8, 2, 8, 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _searchField(),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Expanded(
      child: TextField(
        controller: _searchController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.start,
        style: TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Search books...",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide.none,
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide.none,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.black),
        ),
        onChanged: _searchBooks,
      ),
    );
  }
}
