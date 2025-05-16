class Movie {
  final int id; // TMDB-/IMDb-ID
  final String title; // (Lokalisierter) Titel

  final String posterPath;
  final String overview;
  final String imdbId;
  final DateTime? releaseDate;
  final double? rating;
  final int voteCount;
  final int runtime;
  final List<String> genres;
  final List<String> directors;
  final List<String> cast;
  final String originalLanguage;

  const Movie({
    required this.id,
    required this.title,
    this.posterPath = '',
    this.overview = '',
    this.imdbId = '',
    this.releaseDate,
    this.rating,
    this.voteCount = 0,
    required this.runtime,
    this.genres = const [],
    this.directors = const [],
    this.cast = const [],
    this.originalLanguage = '',
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final genres = (json['genres'] as List<dynamic>?)
            ?.map((e) => e['name']?.toString() ?? '')
            .toList() ??
        [];

    DateTime? releaseDate;
    final dateStr = json['release_date'] as String?;
    if (dateStr != null && dateStr.isNotEmpty) {
      releaseDate = DateTime.tryParse(dateStr);
    }

    return Movie(
      id: json['id'] as int,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? json['title'] as String
          : (json['original_title'] as String?) ?? '',
      posterPath: (json['poster_path'] as String?) ?? '',
      overview: (json['overview'] as String?) ?? '',
      imdbId: (json['imdb_id'] as String?) ?? '',
      releaseDate: releaseDate,
      rating: ((json['vote_average'] as num?)?.toDouble() ?? 0.0) / 2,
      voteCount: (json['vote_count'] as int?) ?? 0,
      runtime: json['runtime'] ?? 0,
      genres: genres,
      directors: const [],
      cast: const [],
      originalLanguage: (json['original_language'] as String?) ?? '',
    );
  }
}
