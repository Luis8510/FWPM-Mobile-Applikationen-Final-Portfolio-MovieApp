import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';

abstract class SearchMoviesState extends Equatable {
  const SearchMoviesState();
  @override
  List<Object?> get props => [];
}

class SearchMoviesInitial extends SearchMoviesState {
  const SearchMoviesInitial();
}

class SearchingMovies extends SearchMoviesState {
  const SearchingMovies();
}

class SearchedMovies extends SearchMoviesState {
  final List<Movie> searchResults;
  const SearchedMovies({
    required this.searchResults,
  });

  @override
  List<Object?> get props => [searchResults];
}

class SearchMovieError extends SearchMoviesState {
  final String message;
  const SearchMovieError({required this.message});
  @override
  List<Object?> get props => [message];
}
