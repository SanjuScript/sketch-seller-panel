import 'package:drawer_panel/FUNCTIONS/DATA_RETRIEVE_FN/get_reviews.dart';
import 'package:drawer_panel/MODEL/DATA/review_model.dart';
import 'package:flutter/material.dart';

class ReviewScreen extends StatelessWidget {
  final String pID;
  const ReviewScreen({super.key, required this.pID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Reviews',
        ),
      ),
      body: FutureBuilder<List<ReviewModel>>(
          future: GetReviews.getAllReviews(pID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("No DATA"));
            }

            final reviews = snapshot.data;
            if (reviews == null) return const SizedBox();
            if (reviews.isEmpty) {
              return const Center(
                child: Text("No Reviews"),
              );
            }
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Reviews (${reviews.length})',
                          ),
                          const Spacer(),
                          Row(
                            children: List.generate(
                              4,
                              (index) => const Icon(Icons.star, size: 24),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      ...reviews
                          .map((review) => _buildReviewCard(context, review))
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Widget _buildReviewCard(BuildContext context, ReviewModel review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (review.userName!.isNotEmpty)
          Text(
            review.userName!,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        const SizedBox(height: 8),
        Row(children: [
          Text(review.rating.toString()),
          const SizedBox(width: 5),
          ...List.generate(
            5,
            (index) => Icon(
              index < review.rating! ? Icons.star : Icons.star_border,
              size: 20,
            ),
          ),
        ]),
        const SizedBox(height: 8),
        if (review.comment!.isNotEmpty && review.comment != null)
          Text(
            review.comment! ?? '',
          ),
        const Divider(),
        const SizedBox(height: 16),
      ],
    );
  }
}
