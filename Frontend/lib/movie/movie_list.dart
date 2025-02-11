import 'package:flutter/material.dart';
import 'package:tubes/movie/movieDetail.dart';
import 'movie.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:tubes/client/FilmClient.dart';
import 'package:tubes/entity/Film.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListMovieView extends StatefulWidget {
  final int initialIndex;

  const ListMovieView({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _ListMovieViewState createState() => _ListMovieViewState();
}

class _ListMovieViewState extends State<ListMovieView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late stt.SpeechToText _speech;
  late TextEditingController _searchController;
  bool _isListening = false;
  String _searchQuery = "";
  late Future<List<Film>> nowPlayingMovies;
  late Future<List<Film>> comingSoonMovies;
  String? token;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _speech = stt.SpeechToText();
    _searchController = TextEditingController();
    _loadToken();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _searchQuery = "";
          _searchController.clear();
          _performSearch("");
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  // Fungsi untuk load token dari SharedPreferences
  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token'); // Mengambil token dari SharedPreferences

    if (token != null) {
      // Kalau tokennya dapat, maka fetch data dari API
      setState(() {
        nowPlayingMovies = FilmClient.fetchByStatus('now playing', token!);
        comingSoonMovies = FilmClient.fetchByStatus('coming soon', token!);
      });
    } else {
      // Kalau token tidak ada  / null, maka print pesan error dan mundur ke halaman login
      print('Token not found');
    }
  }

  // Speech recognition to handle voice search
  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("onStatus: $status"),
        onError: (error) => print("onError: $error"),
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (result) {
            setState(() {
              _searchQuery = result.recognizedWords;
              _searchController.text = _searchQuery;
              _performSearch(_searchController.text);
            });
          },
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFF0A2038),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white54),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _performSearch(value);
              },
              decoration: const InputDecoration(
                hintText: "Search for movies...",
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
            onPressed: _listen,
          ),
        ],
      ),
    );
  }

  void _performSearch(String query) {
    if (token != null) {
      String status = _tabController.index == 0 ? 'now playing' : 'coming soon';
      try {
        print('Searching for: $query in $status');
        if (status == 'now playing') {
          nowPlayingMovies = FilmClient.searchMovies(query, status, token!);
        } else {
          comingSoonMovies = FilmClient.searchMovies(query, status, token!);
        }
      } catch (e) {
        print('Search error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Movies",
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins-Medium',
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110.0),
          child: Column(
            children: [
              _buildSearchBar(),
              TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                tabs: const [
                  Tab(
                    child: Text(
                      "Now Playing",
                      style: TextStyle(
                        fontFamily: 'Poppins-Semibold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Coming Soon",
                      style: TextStyle(
                        fontFamily: 'Poppins-Semibold',
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 5),
          const SizedBox(height: 5),
          Expanded(
            child: token == null
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Cuma buat loading biar gak nampak layar merah karena token belum diambil
                : TabBarView(
                    controller: _tabController,
                    children: [
                      // Menampilkan data 'Now Playing'
                      FutureBuilder<List<Film>>(
                        future: nowPlayingMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No movies found'));
                          } else {
                            return MovieGrid(
                              movies: snapshot.data!,
                              isComingSoon: false,
                            );
                          }
                        },
                      ),

                      // Menampilkan data 'Coming Soon'
                      FutureBuilder<List<Film>>(
                        future: comingSoonMovies,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Center(child: Text('No movies found'));
                          } else {
                            return MovieGrid(
                              movies: snapshot.data!,
                              isComingSoon: true,
                            );
                          }
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class MovieGrid extends StatelessWidget {
  final List<Film> movies;
  final bool isComingSoon;

  const MovieGrid({
    required this.movies,
    required this.isComingSoon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.5,
        crossAxisSpacing: 8,
        // mainAxisSpacing: 3,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];

        return GestureDetector(
          onTap: () {
            // Ketika film diklik, arahkan ke MovieDetailPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie),
              ),
            );
          },
          child: MovieCard(
              movie: movie,
              isComingSoon:
                  isComingSoon), // Memanggil MovieCard di dalam GestureDetector
        );
      },
    );
  }
}

class MovieCard extends StatelessWidget {
  final Film movie;
  final bool isComingSoon;

  const MovieCard({
    required this.movie,
    required this.isComingSoon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 365,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              movie.poster,
              fit: BoxFit.cover,
              width: 180,
              height: 240,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            movie.judul_film,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Poppins-SemiBold',
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                margin: const EdgeInsets.only(right: 8),
                child: Text(
                  movie.durasi.toString() + ' mnt',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                margin: const EdgeInsets.only(right: 8),
                child: Text(
                  movie.rating_umur,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(7),
                ),
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 7),
                child: Text(
                  movie.dimensi,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Poppins-Medium',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
