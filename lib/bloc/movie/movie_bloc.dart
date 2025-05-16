import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_event.dart';
import 'movie_state.dart';
import '../../data/repositories/movie_repository.dart';

export 'movie_event.dart';
export 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository _movieRepo;

  MovieBloc(this._movieRepo) : super(const YourMoviesInitial()) {
    on<LoadMovie>(_onLoadYourMovies);
  }

  Future<void> _onLoadYourMovies(
    LoadMovie event,
    Emitter<MovieState> emit,
  ) async {
    emit(const MovieLoading());
    try {
      final movie = await _movieRepo.fetchMoviesById(event.movieId);

      emit(MovieLoaded(
        yourMovie: movie,
      ));
    } catch (e) {
      print(e.toString());
      emit(YourMoviesError(e.toString()));
    }
  }
}
