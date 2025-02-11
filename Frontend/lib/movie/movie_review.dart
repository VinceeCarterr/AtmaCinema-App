import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes/client/ReviewClient.dart';
import 'package:tubes/entity/Review.dart';

class MovieReviewPage extends StatefulWidget {
  final int idFilm;
  const MovieReviewPage({super.key, required this.idFilm});

  @override
  State<MovieReviewPage> createState() => _MovieReviewPageState();
}

class _MovieReviewPageState extends State<MovieReviewPage> {
  Future<ResponseReview>? review;
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    getReview();
  }

  Future<void> getReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Token not found')));
      return;
    }

    try {
      ResponseReview res =
          await ReviewClient.fetchReview(widget.idFilm, token!);

      setState(() {
        review = Future.value(res);
        print("Schedule data received: $review");
        isDataLoaded = true;
      });
    } catch (e) {
      setState(() {
        isDataLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text("Movie Review", style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0A2038),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: isDataLoaded
                ? FutureBuilder<ResponseReview>(
                    future: review,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("No data available"));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text("No data available"));
                      } else {
                        ResponseReview res = snapshot.data!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCombinedRatingAndReviewSummary(res),
                            const SizedBox(height: 20),
                            Expanded(
                              child: ListView(
                                children: _buildReviewList(res.reviews ?? []),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  )
                : const Center(child: Text("No data available")),
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedRatingAndReviewSummary(ResponseReview res) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.star, color: Colors.yellow, size: 48),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${res.average}/5",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(width: 20),
        Container(
          width: 1,
          height: 48,
          color: Colors.white.withOpacity(0.5),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${res.totalRating} User Ratings",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            Text(
              "${res.totalDescription} User Reviews",
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReview({
    required String reviewerName,
    required String daysAgo,
    required int rating,
    required String reviewText,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 15.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('images/google.png'),
            radius: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reviewerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  daysAgo,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: List.generate(
                    rating,
                    (index) =>
                        const Icon(Icons.star, color: Colors.yellow, size: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  reviewText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReviewList(List<Review> reviews) {
    return reviews.map((review) {
      return Column(
        children: [
          _buildReview(
            reviewerName: review.full_name,
            daysAgo: review.review_at ?? "Just now",
            rating: review.rating_review,
            reviewText:
                review.deskripsi_review ?? "No review from ${review.full_name}",
          ),
          Divider(color: Colors.white.withOpacity(0.2)),
        ],
      );
    }).toList();
  }
}
