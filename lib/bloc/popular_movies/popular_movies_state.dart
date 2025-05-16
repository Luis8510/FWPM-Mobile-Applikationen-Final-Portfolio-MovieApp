import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';

abstract class PopularMoviesState extends Equatable {
  const PopularMoviesState();
  @override
  List<Object?> get props => [];
}

class PopularMoviesInitial extends PopularMoviesState {
  const PopularMoviesInitial();
}

class PopularMoviesLoading extends PopularMoviesState {
  const PopularMoviesLoading();
}

class PopularMoviesLoaded extends PopularMoviesState {
  final List<Movie> popularMovies;

  const PopularMoviesLoaded({
    required this.popularMovies,
  });
  @override
  List<Object?> get props => [popularMovies];
}

class PopularMoviesError extends PopularMoviesState {
  final String? message;
  const PopularMoviesError({this.message});
  @override
  List<Object?> get props => [message];
}
