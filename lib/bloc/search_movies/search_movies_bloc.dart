import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_movies_event.dart';
import 'search_movies_state.dart';
import '../../data/repositories/movie_repository.dart';

export 'search_movies_event.dart';
export 'search_movies_state.dart';

class SearchMoviesBloc extends Bloc<SearchMoviesEvent, SearchMoviesState> {
  final MovieRepository _repo;

  SearchMoviesBloc(this._repo) : super(const SearchMoviesInitial()) {
    on<SearchMovies>(_onSearch);
  }

  Future<void> _onSearch(
    SearchMovies event,
    Emitter<SearchMoviesState> emit,
  ) async {
    emit(const SearchingMovies());
    try {
      final results = await _repo.searchMovies(event.query);
      emit(SearchedMovies(
        searchResults: results,
      ));
    } catch (_) {
      emit(const SearchMovieError(message: 'Failed to load search results'));
    }
  }
}
