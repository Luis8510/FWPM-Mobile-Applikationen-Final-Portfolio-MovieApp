import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';

abstract class MovieState extends Equatable {
  const MovieState();
  @override
  List<Object?> get props => [];
}

class YourMoviesInitial extends MovieState {
  const YourMoviesInitial();
}

class MovieLoading extends MovieState {
  const MovieLoading();
}

class MovieLoaded extends MovieState {
  final Movie yourMovie;
  const MovieLoaded({
    required this.yourMovie,
  });
  @override
  List<Object?> get props => [yourMovie];
}

class YourMoviesError extends MovieState {
  final String? message;
  const YourMoviesError([this.message]);
  @override
  List<Object?> get props => [message];
}
