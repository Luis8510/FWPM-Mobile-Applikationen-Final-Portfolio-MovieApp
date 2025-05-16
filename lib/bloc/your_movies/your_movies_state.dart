import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';

abstract class YourMoviesState extends Equatable {
  const YourMoviesState();
  @override
  List<Object?> get props => [];
}

class YourMoviesInitial extends YourMoviesState {
  const YourMoviesInitial();
}

class YourMoviesLoading extends YourMoviesState {
  const YourMoviesLoading();
}

class YourMoviesLoaded extends YourMoviesState {
  final List<Movie> yourMovies;
  final List<Movie> friendMovies;
  const YourMoviesLoaded({
    required this.yourMovies,
    required this.friendMovies,
  });
  @override
  List<Object?> get props => [yourMovies, friendMovies];
}

class YourMoviesError extends YourMoviesState {
  final String? message;
  const YourMoviesError([this.message]);
  @override
  List<Object?> get props => [message];
}
