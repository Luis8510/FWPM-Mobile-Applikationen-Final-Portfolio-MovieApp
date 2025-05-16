import 'package:flutter_bloc/flutter_bloc.dart';
import 'popular_movies_event.dart';
import 'popular_movies_state.dart';
import '../../data/repositories/movie_repository.dart';

export 'popular_movies_event.dart';
export 'popular_movies_state.dart';

class PopularMoviesBloc extends Bloc<PopularMoviesEvent, PopularMoviesState> {
  final MovieRepository _repo;
  int _currentPage = 1;
  bool _isFetchingMore = false;

  PopularMoviesBloc(this._repo) : super(const PopularMoviesInitial()) {
    on<LoadPopularMovies>(_onLoadRandom);
    on<LoadMorePopularMovies>(_onLoadNextPage);
  }

  Future<void> _onLoadRandom(
    LoadPopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    _currentPage = 1;
    emit(const PopularMoviesLoading());
    try {
      final movies = await _repo.fetchPopularPage(_currentPage);
      emit(PopularMoviesLoaded(
        popularMovies: movies,
      ));
    } catch (_) {
      emit(const PopularMoviesError());
    }
  }

  Future<void> _onLoadNextPage(
    LoadMorePopularMovies event,
    Emitter<PopularMoviesState> emit,
  ) async {
    final current = state as PopularMoviesLoaded;
    _isFetchingMore = true;
    try {
      _currentPage++;
      final extra = await _repo.fetchPopularPage(_currentPage);
      emit(PopularMoviesLoaded(
        popularMovies: [...current.popularMovies, ...extra],
      ));
    } catch (_) {
      _currentPage--;
    }
    _isFetchingMore = false;
  }
}
