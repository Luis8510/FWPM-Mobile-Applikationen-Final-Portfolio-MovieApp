import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();
  @override
  List<Object?> get props => [];
}

class LoadMovie extends MovieEvent {
  final int movieId;
  const LoadMovie(this.movieId);
  @override
  List<Object?> get props => [movieId];
}
