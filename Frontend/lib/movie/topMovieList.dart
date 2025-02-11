import 'package:flutter/material.dart';
import 'package:tubes/entity/Film.dart';
import 'package:tubes/client/FilmClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TopMovieList extends StatelessWidget {
  const TopMovieList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'Top Movies For You!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<List<Film>>(
          future: _fetchNowPlayingMovies(), // Fetch movie data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No movies found',
                  style: TextStyle(color: Colors.white),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final movie = snapshot.data![index];
                  return MovieListCard(
                    imagePath: movie.poster ?? 'images/default_poster.jpg',
                    title: movie.judul_film,
                    duration: '${movie.durasi} mnt',
                    rating: '${movie.rating ?? 0}/5',
                    ageRating: movie.rating_umur ?? 'N/A',
                    format: movie.dimensi ?? 'N/A',
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<List<Film>> _fetchNowPlayingMovies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) throw Exception('Token not found');
    return FilmClient.fetchByStatus('now playing', token);
  }
}

class MovieListCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String duration;
  final String rating;
  final String ageRating;
  final String format;

  const MovieListCard({
    super.key,
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
      margin: const EdgeInsets.only(left: 30.0, bottom: 10.0, top: 16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: 120,
              height: 150,
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
