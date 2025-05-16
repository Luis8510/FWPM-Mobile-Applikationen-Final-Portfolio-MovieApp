import 'package:equatable/equatable.dart';

abstract class PopularMoviesEvent extends Equatable {
  const PopularMoviesEvent();
  @override
  List<Object?> get props => [];
}

class LoadPopularMovies extends PopularMoviesEvent {
  const LoadPopularMovies();
}

class LoadMorePopularMovies extends PopularMoviesEvent {
  const LoadMorePopularMovies();
}
