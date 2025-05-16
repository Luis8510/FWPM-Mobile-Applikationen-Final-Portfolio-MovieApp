import 'package:equatable/equatable.dart';
import 'package:finalportfolio/data/models/rating.dart';

abstract class MovieRatingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitRating extends MovieRatingEvent {
  final int movieId;
  final String movieName;
  final int rating;
  final String userId;
  final String username;

  SubmitRating({
    required this.movieId,
    required this.movieName,
    required this.rating,
    required this.userId,
    required this.username,
  });

  @override
  List<Object?> get props => [movieId, rating, userId, username, movieName];
}

class ListenFriendRatings extends MovieRatingEvent {
  final int movieId;
  ListenFriendRatings(this.movieId);

  @override
  List<Object?> get props => [movieId];
}

class FriendRatingsUpdated extends MovieRatingEvent {
  final List<Rating> ratings;
  FriendRatingsUpdated(this.ratings);

  @override
  List<Object?> get props => [ratings];
}
