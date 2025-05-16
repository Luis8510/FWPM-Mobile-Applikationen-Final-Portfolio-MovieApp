import '../../utils/constants.dart';
import '../providers/api_client.dart';
import '../models/movie.dart';

class MovieRepository {
  final ApiClient _client;

  MovieRepository(this._client);

  Future<List<Movie>> fetchPopularPage(int page) async {
    final all = await _client.fetchPopular(page);
    return all;
  }

  Future<List<Movie>> fetchMoviesByGenre(String genre) async {
    final id = Constants.genreIds[genre];
    if (id == null) return [];
    final all = await _client.fetchMoviesByGenre(id);
    return all;
  }

  Future<List<Movie>> fetchMoviesByIds(List<int> ids) async {
    final futures = ids.map((id) => _client.fetchMovieDetails(id));
    final all = await Future.wait(futures);
    return all;
  }

  Future<Movie> fetchMoviesById(int id) async {
    final movie = _client.fetchMovieDetails(id);
    return movie;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final results = await _client.searchMovies(query);
    return results;
  }

  Future<String?> getImdbId(int movieId) {
    return _client.fetchImdbId(movieId);
  }
}
