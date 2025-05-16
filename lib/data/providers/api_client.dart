import 'package:dio/dio.dart';
import '../models/movie.dart';
import '../../utils/constants.dart';
import '../../config/env.dart';

class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Constants.tmdbBaseUrl,
            queryParameters: {'api_key': Env.tmdbApiKey, 'language': 'en-US'},
          ),
        );

  Future<List<Movie>> fetchPopular(int page) async {
    final resp = await _dio.get('/movie/popular',
        queryParameters: {'page': page, 'include_adult': false});
    return (resp.data['results'] as List)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    final resp = await _dio.get(
      '/search/movie',
      queryParameters: {'query': query, 'page': page},
    );
    return (resp.data['results'] as List)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Movie>> fetchMoviesByGenre(int genreId, {int page = 1}) async {
    final resp = await _dio.get(
      '/discover/movie',
      queryParameters: {
        'with_genres': genreId,
        'page': page,
        'include_adult': false,
        'sort_by': 'popularity.desc',
      },
    );
    return (resp.data['results'] as List)
        .map((e) => Movie.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Movie> fetchMovieDetails(int id) async {
    final resp = await _dio.get('/movie/$id');
    return Movie.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<String?> fetchImdbId(int movieId) async {
    final resp = await _dio.get('/movie/$movieId/external_ids');
    return resp.data['imdb_id'] as String?;
  }
}
