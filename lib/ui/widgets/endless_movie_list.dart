import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/movie_rating/movie_rating_bloc.dart';
import '../../bloc/popular_movies/popular_movies_bloc.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/rating_repository.dart';
import 'movie_card.dart';

class EndlessMovieList extends StatefulWidget {
  final List<Movie> movies;

  const EndlessMovieList({
    Key? key,
    required this.movies,
  }) : super(key: key);

  @override
  _EndlessMovieListState createState() => _EndlessMovieListState();
}

class _EndlessMovieListState extends State<EndlessMovieList> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<PopularMoviesBloc>().add(const LoadMorePopularMovies());
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = widget.movies.length + 1;

    return SizedBox(
      height: 240,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          if (index >= widget.movies.length) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }

          final movie = widget.movies[index];
          return BlocProvider(
            create: (_) {
              final bloc = MovieRatingBloc(context.read<RatingRepository>());
              bloc.add(ListenFriendRatings(movie.id));
              return bloc;
            },
            child: MovieCard(movie: movie),
          );
        },
      ),
    );
  }
}
