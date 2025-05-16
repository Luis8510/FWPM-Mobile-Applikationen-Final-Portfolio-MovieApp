import 'package:flutter_bloc/flutter_bloc.dart';
import 'your_movies_event.dart';
import 'your_movies_state.dart';
import '../../data/repositories/rating_repository.dart';
import '../../data/repositories/movie_repository.dart';

export 'your_movies_event.dart';
export 'your_movies_state.dart';

class YourMoviesBloc extends Bloc<YourMoviesEvent, YourMoviesState> {
  final RatingRepository _ratingRepo;
  final MovieRepository _movieRepo;

  YourMoviesBloc(this._ratingRepo, this._movieRepo)
      : super(const YourMoviesInitial()) {
    on<LoadYourMovies>(_onLoadYourMovies);
  }

  Future<void> _onLoadYourMovies(
    LoadYourMovies event,
    Emitter<YourMoviesState> emit,
  ) async {
    emit(const YourMoviesLoading());
    try {
      final yourMovieIds =
          await _ratingRepo.fetchMovieIdsOfCurrentUser(event.userId);
      final yourMovies = await _movieRepo.fetchMoviesByIds(yourMovieIds);

      final friendMovieIds =
          await _ratingRepo.loadMovieIdsFromFriends(event.userId);
      final friendMovies = await _movieRepo.fetchMoviesByIds(friendMovieIds);

      emit(YourMoviesLoaded(
        yourMovies: yourMovies,
        friendMovies: friendMovies,
      ));
    } catch (e) {
      print(e.toString());
      emit(YourMoviesError(e.toString()));
    }
  }
}
