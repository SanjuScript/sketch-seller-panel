import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String? userId;
  final String? userName;
  final double? rating;
  final String? comment;
  final String? reviewID;
  final DateTime? date;

  ReviewModel({
    this.userId,
    this.userName,
    this.rating,
    this.reviewID,
    this.comment,
    this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      reviewID: json['reviewID'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      comment: json['comment'] as String?,
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate()
          : json['date'] is String
              ? DateTime.tryParse(json['date'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'reviewID': reviewID,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date != null ? Timestamp.fromDate(date!) : null,
    };
  }
}
