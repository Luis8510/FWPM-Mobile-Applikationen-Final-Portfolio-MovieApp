import 'package:flutter_bloc/flutter_bloc.dart';
import 'movie_rating_event.dart';
import 'movie_rating_state.dart';
import '../../data/repositories/rating_repository.dart';

export 'movie_rating_event.dart';
export 'movie_rating_state.dart';

class MovieRatingBloc extends Bloc<MovieRatingEvent, MovieRatingState> {
  final RatingRepository _repo;

  MovieRatingBloc(this._repo) : super(RatingInitial()) {
    on<SubmitRating>(_onSubmitRating);
    on<ListenFriendRatings>(_onListenFriendRatings);
    on<FriendRatingsUpdated>(_onFriendRatingsUpdated);
  }

  Future<void> _onSubmitRating(
    SubmitRating event,
    Emitter<MovieRatingState> emit,
  ) async {
    emit(RatingSubmitting());
    try {
      await _repo.submitRating(
        movieId: event.movieId,
        movieName: event.movieName,
        rating: event.rating,
        userId: event.userId,
        username: event.username,
      );
      emit(RatingSubmitted());
      add(ListenFriendRatings(event.movieId));
    } catch (_) {
      emit(RatingError());
    }
  }

  void _onListenFriendRatings(
    ListenFriendRatings event,
    Emitter<MovieRatingState> emit,
  ) {
    _repo.friendRatings(event.movieId).listen((ratings) {
      add(FriendRatingsUpdated(ratings));
    });
  }

  void _onFriendRatingsUpdated(
    FriendRatingsUpdated event,
    Emitter<MovieRatingState> emit,
  ) {
    emit(RatingsLoaded(event.ratings));
  }
}
