import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  final int movieId;
  late final int value;
  final String userId;
  final String username;

  Rating({
    required this.movieId,
    required this.value,
    required this.userId,
    required this.username,
  });

  factory Rating.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Rating(
      movieId: int.parse(doc.reference.parent.parent!.id),
      value: (data['rating'] as num).toInt(),
      userId: data['userId'] as String,
      username: data['username'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'rating': value,
        'userId': userId,
        'username': username,
        'movieId': movieId,
      };
}
