import 'package:app/core/constants/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  Stream<List<BookModel>>? _searchResults;
  final BookService _bookService = BookService();
  late TabController _tabController;
  late stt.SpeechToText _speech;
  late ValueNotifier<bool> _isListeningNotifier;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
    _speech = stt.SpeechToText();
    _isListeningNotifier = ValueNotifier(false);
    _initializeSpeech();
    _requestPermissions();
  }

  Future<void> _initializeSpeech() async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('Speech recognition error: $val'),
    );
    if (!available) {
      print("Speech recognition not available");
    }
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _isListeningNotifier.dispose();
    super.dispose();
  }

  void _searchBooks(String query) {
    if (query.isEmpty) {
      setState(() => _searchResults = null);
    } else {
      setState(() => _searchResults = _bookService.searchBooks(query));
    }
  }

  void _listen() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      if (!_isListeningNotifier.value) {
        _isListeningNotifier.value = true;
        _speech.listen(
          localeId: 'en_US',
          onResult: (val) {
            _searchController.text = val.recognizedWords;
            _searchBooks(val.recognizedWords);
          },
        );
      } else {
        _isListeningNotifier.value = false;
        _speech.stop();
      }
    } else {
      print("Microphone permission denied");
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
            preferredSize: const Size.fromHeight(330),
            child: Stack(
              children: [
                ClipPath(
                  clipper: InversedOnboardingClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: double.infinity,
                    color: AppTheme.primaryColor,
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
                      const SizedBox(height: 12),
                      Text(
                        "Hello, ${userProvider.user?.username}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "What do you want to read today?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 25),
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
                    indicatorColor: const Color(0xFF0B5268),
                    labelColor: const Color(0xFF0B5268),
                    dividerColor: Colors.transparent,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                    tabs: const [
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
                    const Center(
                      child: Text("My Books", style: TextStyle(fontSize: 18)),
                    ),
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
      
      width: kIsWeb ? 450 : double.infinity,
      padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(80)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          _searchField(),
          ValueListenableBuilder<bool>(
            valueListenable: _isListeningNotifier,
            builder: (context, isListening, child) {
              return IconButton(
                icon: Icon(!isListening ? Icons.mic_off : Icons.mic),
                onPressed: _listen,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Expanded(
      child: TextField(
        minLines: 1, // ✅ Starts small
        maxLines: 1, // ✅ Grows when typing
        controller: _searchController,
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.start,
        style: const TextStyle(fontSize: 18, color: Colors.black),
        decoration: InputDecoration(
          hintText: "Search books...",
          focusedBorder: OutlineInputBorder(
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
