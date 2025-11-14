import 'user_model.dart';

enum ReviewContextType {
  booking,
  jastip;

  static ReviewContextType fromString(String type) {
    switch (type) {
      case 'BOOKING':
        return ReviewContextType.booking;
      case 'JASTIP':
        return ReviewContextType.jastip;
      default:
        return ReviewContextType.booking;
    }
  }

  String toApiString() {
    switch (this) {
      case ReviewContextType.booking:
        return 'BOOKING';
      case ReviewContextType.jastip:
        return 'JASTIP';
    }
  }
}

class ReviewModel {
  final String id;
  final String reviewerId;
  final String revieweeId;
  final String contextId;
  final ReviewContextType contextType;
  final int rating;
  final String? comment;
  final UserModel? reviewer;
  final UserModel? reviewee;

  ReviewModel({
    required this.id,
    required this.reviewerId,
    required this.revieweeId,
    required this.contextId,
    required this.contextType,
    required this.rating,
    this.comment,
    this.reviewer,
    this.reviewee,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      reviewerId: json['reviewerId'] as String,
      revieweeId: json['revieweeId'] as String,
      contextId: json['contextId'] as String,
      contextType: ReviewContextType.fromString(json['contextType'] as String),
      rating: json['rating'] as int,
      comment: json['comment'] as String?,
      reviewer: json['reviewer'] != null
          ? UserModel.fromJson(json['reviewer'] as Map<String, dynamic>)
          : null,
      reviewee: json['reviewee'] != null
          ? UserModel.fromJson(json['reviewee'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'contextId': contextId,
      'contextType': contextType.toApiString(),
      'rating': rating,
      'comment': comment,
      'reviewer': reviewer?.toJson(),
      'reviewee': reviewee?.toJson(),
    };
  }

  bool get isBookingReview => contextType == ReviewContextType.booking;
  bool get isJastipReview => contextType == ReviewContextType.jastip;
}
