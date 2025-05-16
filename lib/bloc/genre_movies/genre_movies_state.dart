import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';

abstract class GenreMoviesState extends Equatable {
  const GenreMoviesState();
  @override
  List<Object?> get props => [];
}

class PopularMoviesInitial extends GenreMoviesState {
  const PopularMoviesInitial();
}

class GenreMoviesLoading extends GenreMoviesState {
  const GenreMoviesLoading();
}

class GenreMoviesLoaded extends GenreMoviesState {
  final List<Movie> genreMovies;

  const GenreMoviesLoaded({
    required this.genreMovies,
  });
  @override
  List<Object?> get props => [genreMovies];
}

class GenreMoviesError extends GenreMoviesState {
  final String message;
  const GenreMoviesError({required this.message});
  @override
  List<Object?> get props => [message];
}
