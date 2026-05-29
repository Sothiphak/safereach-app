class Review {
  const Review({
    required this.id,
    required this.serviceId,
    required this.author,
    required this.rating,
    required this.date,
    required this.comment,
  });

  final String id;
  final String serviceId;
  final String author;
  final double rating;
  final String date;
  final String comment;

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      author: json['author'] as String,
      rating: (json['rating'] as num).toDouble(),
      date: json['date'] as String,
      comment: json['comment'] as String,
    );
  }
}
