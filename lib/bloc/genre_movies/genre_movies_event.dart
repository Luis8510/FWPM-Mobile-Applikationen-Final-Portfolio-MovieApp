import 'package:equatable/equatable.dart';

abstract class GenreMoviesEvent extends Equatable {
  const GenreMoviesEvent();
  @override
  List<Object?> get props => [];
}

class LoadGenreMovies extends GenreMoviesEvent {
  final String genre;
  const LoadGenreMovies(this.genre);
  @override
  List<Object?> get props => [genre];
}
