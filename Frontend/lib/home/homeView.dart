import 'package:flutter/material.dart';
import 'package:tubes/profile/profile.dart';
import 'package:tubes/movie/movieDetail.dart';
import 'package:tubes/movie/topMovieList.dart';
import 'package:tubes/news/news_list.dart';
import 'package:tubes/news/news_detail.dart';
import 'package:tubes/notification/notification.dart';
import 'package:tubes/client/FilmClient.dart';
import 'package:tubes/entity/Film.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

class MyHomeView extends StatefulWidget {
  final Function({required bool nowPlaying}) navigateToMovies;

  const MyHomeView({super.key, required this.navigateToMovies});

  @override
  State<MyHomeView> createState() => _MyHomeViewState();
}

class _MyHomeViewState extends State<MyHomeView> {
  late Future<List<Film>> nowPlayingMovies = Future.value([]);
  late Future<List<Film>> comingSoonMovies = Future.value([]);
  final FocusNode _focusNode = FocusNode();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken(); // Fetch token to load data from API
  }

  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token =
        prefs.getString('token'); // Retrieve the token from SharedPreferences

    if (token != null) {
      // Fetch movie data if token is available
      setState(() {
        nowPlayingMovies = FilmClient.fetchByStatus('now playing', token!);
        comingSoonMovies = FilmClient.fetchByStatus('coming soon', token!);
      });
    } else {
      // If token is not available, print an error and navigate to login screen
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_2, size: 36),
              onPressed: () {
                (context.findAncestorStateOfType<homePageState>())
                    ?.changeTab(4);
              },
              color: Colors.white,
            ),
            IconButton(
              icon: const Icon(Icons.notifications, size: 36),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotifList()),
                );
              },
              color: Colors.white,
            ),
          ],
          title: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "ATMA ",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Bold',
                    fontSize: 28,
                  ),
                ),
                TextSpan(
                  text: "Cinema",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins-Regular',
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(context, true, widget.navigateToMovies),
            const SizedBox(height: 15),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSectionHeader(
                        "Now Playing", true, widget.navigateToMovies),
                    const SizedBox(height: 15),
                    _buildMovieList(),
                    const SizedBox(height: 15),
                    _buildSectionHeader(
                        "Coming Soon", false, widget.navigateToMovies),
                    const SizedBox(height: 15),
                    _buildComingSoonList(),
                    const SizedBox(height: 15),
                    buildAtmaNewsSection(context),
                    const SizedBox(height: 30),
                    buildTopMoviesSection(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    bool showNowPlaying,
    Function({required bool nowPlaying}) navigateToMovies,
  ) {
    return GestureDetector(
      onTap: () {
        _focusNode.unfocus();
        navigateToMovies(nowPlaying: showNowPlaying);
      },
      child: Container(
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
                enabled: false,
                focusNode: _focusNode,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: "Search for movies...",
                  hintStyle: TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic, color: Colors.white54),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool showNowPlaying,
      Function({required bool nowPlaying}) navigateToMovies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Poppins-SemiBold',
              fontSize: 20,
            ),
          ),
          GestureDetector(
            onTap: () {
              navigateToMovies(nowPlaying: showNowPlaying);
            },
            child: Row(
              children: const [
                Text(
                  "See all",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovieList() {
    return FutureBuilder<List<Film>>(
      future: nowPlayingMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          List<Film> movies = snapshot.data!;
          return SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Film movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movie: movie,
                          isComingSoon: false,
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: MovieCard(
                      imagePath: movie.poster ?? 'images/film1.jpg',
                      title: movie.judul_film,
                      duration: movie.durasi.toString() + ' mnt' ?? 'N/A',
                      ageRating: movie.rating_umur ?? 'N/A',
                      format: movie.dimensi ?? 'N/A',
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget _buildComingSoonList() {
    return FutureBuilder<List<Film>>(
      future: comingSoonMovies,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Film> movies = snapshot.data!;
          return SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Film movie = movies[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailPage(
                          movie: movie,
                          isComingSoon: true,
                        ),
                      ),
                    );
                  },
                  child: ComingSoonCard(
                    imagePath: movie.poster,
                    title: movie.judul_film,
                  ),
                );
              },
            ),
          );
        } else {
          return const Text('No data available');
        }
      },
    );
  }
}

// MovieCard Widget
class MovieCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String duration;
  final String ageRating;
  final String format;

  const MovieCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.duration,
    required this.ageRating,
    required this.format,
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
              imagePath,
              fit: BoxFit.cover,
              width: 350,
              height: 180,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
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
                  duration,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                  ageRating,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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
                  format,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

// ComingSoonCard Widget
class ComingSoonCard extends StatelessWidget {
  final String? imagePath;
  final String title;

  const ComingSoonCard({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath ?? 'images/film_default.jpg',
              fit: BoxFit.cover,
              width: 120,
              height: 165,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1, // Batasi teks menjadi 2 baris
            textAlign: TextAlign.center,
            overflow: TextOverflow
                .ellipsis, // Tampilkan elipsis jika teks terlalu panjang
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'Poppins-SemiBold',
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildAtmaNewsSection(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ATMA news',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsList()),
                );
              },
              child: Row(
                children: const [
                  Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            AtmaNewsCard(
              imagePath: 'images/img_poster/endgame.jpg',
              description:
                  'Spider-Man: Way Back Home Confirmed for 2025 Release!',
            ),
            AtmaNewsCard(
              imagePath: 'images/img_poster/avengers.jpg',
              description:
                  'Robert Downey Jr. Officially Returns as Iron Man: Announcement Delights Marvel Fans!',
            ),
            AtmaNewsCard(
              imagePath: 'images/img_poster/infinity_war.jpg',
              description:
                  'Chris Evans Wields the Shield Again: Marvel Fans Cheer for the Return of Captain America!',
            ),
          ],
        ),
      ),
    ],
  );
}

// ATMA News Card Widget
class AtmaNewsCard extends StatelessWidget {
  final String imagePath;
  final String description;

  const AtmaNewsCard({
    required this.imagePath,
    required this.description,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(
              imagePath: imagePath,
              title: description,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20.0, bottom: 16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildTopMoviesSection(BuildContext context) {
  return FutureBuilder<String?>(
    future: SharedPreferences.getInstance()
        .then((prefs) => prefs.getString('token')),
    builder: (context, tokenSnapshot) {
      if (tokenSnapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (tokenSnapshot.hasError ||
          !tokenSnapshot.hasData ||
          tokenSnapshot.data == null) {
        return const Center(child: Text('Error: Unable to fetch token.'));
      }

      final token = tokenSnapshot.data!;
      Future<List<Film>> topMovies =
          FilmClient.fetchByStatus('now playing', token);

      return FutureBuilder<List<Film>>(
        future: topMovies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Film> movies = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Top Movies For You!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TopMovieList()),
                          );
                        },
                        child: Row(
                          children: const [
                            Text(
                              "See all",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white70,
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: movies.map((movie) {
                      return MovieListCard(
                        imagePath: movie.poster ?? 'images/default_poster.jpg',
                        title: movie.judul_film,
                        duration: '${movie.durasi} mins',
                        rating: '${movie.rating ?? 0}/5',
                        ageRating: movie.rating_umur ?? 'N/A',
                        format: movie.dimensi ?? 'N/A',
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No top movies found'));
          }
        },
      );
    },
  );
}

class MovieListCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String duration;
  final String rating;
  final String ageRating;
  final String format;

  const MovieListCard({
    required this.imagePath,
    required this.title,
    required this.duration,
    required this.rating,
    required this.ageRating,
    required this.format,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20.0, bottom: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 100,
              height: 120,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    MovieTag(text: duration),
                    const SizedBox(width: 8),
                    MovieTag(text: ageRating),
                    const SizedBox(width: 8),
                    MovieTag(text: format),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// // MovieTag Widget
class MovieTag extends StatelessWidget {
  final String text;

  const MovieTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F1F),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    );
  }
}
