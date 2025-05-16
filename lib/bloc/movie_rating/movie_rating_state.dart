import 'package:equatable/equatable.dart';
import 'package:finalportfolio/data/models/rating.dart';

abstract class MovieRatingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RatingInitial extends MovieRatingState {}

class RatingSubmitting extends MovieRatingState {}

class RatingSubmitted extends MovieRatingState {}

class RatingsLoaded extends MovieRatingState {
  final List<Rating> ratings;
  RatingsLoaded(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class RatingError extends MovieRatingState {}
