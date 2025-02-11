import 'package:flutter/material.dart';

class NewsDetail extends StatelessWidget {
  final String imagePath;
  final String title;

  const NewsDetail({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        title: const Text(
          'ATMA News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF000000), Colors.black],
              stops: [0.3, 0.7],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Exciting news for Marvel fans! The highly anticipated Spider-Man: Way Back Home has been officially confirmed for a 2025 release. This latest chapter in the Spider-Man saga is set to bring even more web-slinging action, intense drama, and thrilling multiverse adventures.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'images/img_poster/Mufasa.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Fans have been eagerly awaiting Spider-Man's next adventure in the Marvel Cinematic Universe. This movie promises to bring new twists, characters, and a storyline that ties directly into the multiverse, making it one of the most exciting releases yet.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.asset(
                  'images/img_poster/infinity_war.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "With returning cast members and new surprises, Spider-Man: Way Back Home is set to break box office records. Stay tuned for more updates as we get closer to the release date!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
