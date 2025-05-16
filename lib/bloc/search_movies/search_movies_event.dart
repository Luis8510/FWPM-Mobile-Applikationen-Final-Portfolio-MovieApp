import 'package:equatable/equatable.dart';

abstract class SearchMoviesEvent extends Equatable {
  const SearchMoviesEvent();
  @override
  List<Object?> get props => [];
}

class InitSearchEvent extends SearchMoviesEvent {}

class SearchMovies extends SearchMoviesEvent {
  final String query;
  const SearchMovies(this.query);
  @override
  List<Object?> get props => [query];
}
