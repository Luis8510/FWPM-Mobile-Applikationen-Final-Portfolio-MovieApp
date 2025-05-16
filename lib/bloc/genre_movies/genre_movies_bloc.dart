import 'package:flutter_bloc/flutter_bloc.dart';
import 'genre_movies_event.dart';
import 'genre_movies_state.dart';
import '../../data/repositories/movie_repository.dart';

export 'genre_movies_event.dart';
export 'genre_movies_state.dart';

class GenreMoviesBloc extends Bloc<GenreMoviesEvent, GenreMoviesState> {
  final MovieRepository _repo;
  GenreMoviesBloc(this._repo) : super(const PopularMoviesInitial()) {
    on<LoadGenreMovies>(_onLoadGenre);
  }

  Future<void> _onLoadGenre(
    LoadGenreMovies event,
    Emitter<GenreMoviesState> emit,
  ) async {
    try {
      final genreMovies = await _repo.fetchMoviesByGenre(event.genre);
      emit(GenreMoviesLoaded(
        genreMovies: genreMovies,
      ));
    } catch (_) {
      emit(const GenreMoviesError(message: 'Failed to load genre movies'));
    }
  }
}
