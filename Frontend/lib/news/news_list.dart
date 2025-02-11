import 'package:flutter/material.dart';
import 'package:tubes/news/news_detail.dart';

class NewsList extends StatelessWidget {
  const NewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          'ATMA News',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: ListView(
          children: [
            NewsItem(
              imagePath: 'images/img_poster/age_of_ultron.jpg',
              title: 'Spider-Man: Way Back Home Confirmed for 2025 Release!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/avengers.jpg',
              title: 'Robert Downey Jr. Officially Returns as Iron Man!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/endgame.jpg',
              title: 'Chris Evans Wields the Shield Again!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/Mufasa.jpg',
              title: 'Chris Evans Wields the Shield Again!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/kraven.jpeg',
              title: 'Doctor Strange: The Key to Avengers Victory!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/moana-2.jpeg',
              title: 'Thanos: From Iconic Villain to Controversial Hero!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/moana-3.jpeg',
              title: 'Spider-Man: Way Back Home Confirmed for 2025 Release!',
            ),
            NewsItem(
              imagePath: 'images/bg2.jpg',
              title: 'Robert Downey Jr. Officially Returns as Iron Man!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/Mufasa.jpg',
              title: 'Chris Evans Wields the Shield Again!',
            ),
            NewsItem(
              imagePath: 'images/img_poster/Heretic.jpg',
              title: 'Robert Downey Jr. Officially Returns as Iron Man!',
            ),
            NewsItem(
              imagePath: 'images/bg3.jpg',
              title: 'Doctor Strange: The Key to Avengers Victory!',
            ),
            NewsItem(
              imagePath: 'images/bg5.jpg',
              title: 'Thanos: From Iconic Villain to Controversial Hero!',
            ),
          ],
        ),
      ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final String imagePath;
  final String title;

  const NewsItem({
    super.key,
    required this.imagePath,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetail(
              imagePath: imagePath,
              title: title,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0E1D39),
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  bottomLeft: Radius.circular(16.0),
                ),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
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
}
