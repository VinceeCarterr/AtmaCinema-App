import 'package:flutter/material.dart';
import 'package:tubes/client/FilmClient.dart';
import 'package:tubes/entity/Film.dart';
import '../transaction/buyTicket.dart';
import 'movie_review.dart';

class MovieDetailPage extends StatelessWidget {
  final Film movie;
  final bool isComingSoon;

  const MovieDetailPage({
    required this.movie,
    this.isComingSoon = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FittedBox(
                      child: Image.asset(
                        movie.poster,
                        height: 200,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Judul Film dan Detail
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.judul_film,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Detail Film
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                color: Colors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text("${movie.durasi} min",
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 16),
                            const Icon(Icons.visibility,
                                color: Colors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text(movie.rating_umur,
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 16),
                            const Icon(Icons.theaters,
                                color: Colors.grey, size: 14),
                            const SizedBox(width: 4),
                            Text(movie.dimensi,
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          movie.genre,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            const Text("4.8",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Tombol Buy Ticket dan See Review
                        // Masih dicomment biar gak error. Itu masuk transaksi soale
                        Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: isComingSoon
                                    ? null
                                    : () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MovieShowtimePage(movie: movie),
                                          ),
                                        );
                                      },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      if (states
                                          .contains(WidgetState.disabled)) {
                                        return Colors.grey;
                                      }
                                      return Colors.white;
                                    },
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                      return states
                                              .contains(WidgetState.disabled)
                                          ? Colors.white70
                                          : Colors.black;
                                    },
                                  ),
                                  padding: WidgetStateProperty.all(
                                      const EdgeInsets.symmetric(vertical: 8)),
                                ),
                                child: const Text("BUY TICKETS",
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 100,
                              child: OutlinedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MovieReviewPage(
                                            idFilm: movie.id_film)),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                ),
                                child: const Text("SEE REVIEW",
                                    style: TextStyle(fontSize: 12)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Bagian Trailer
              const Text(
                "Trailer",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Icon(Icons.play_circle_fill,
                      color: Colors.white, size: 50),
                ),
              ),
              const SizedBox(height: 16),

              // Bagian Sinopsis
              const Text(
                "Synopsis",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                movie.sinopsis,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // Bagian Data Produser
              const Text(
                "Producer",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                movie.producer,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // Bagian Data Director
              const Text(
                "Director",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                movie.director,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // Bagian Data Writers
              const Text(
                "Writers",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                movie.writers,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 16),

              // Bagian Data Cast
              const Text(
                "Cast",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                movie.cast,
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
