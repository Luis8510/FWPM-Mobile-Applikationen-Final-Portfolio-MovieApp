import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/movie_rating/movie_rating_bloc.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/rating_repository.dart';
import 'movie_card.dart';

class MovieList extends StatelessWidget {
  final List<Movie> movies;
  const MovieList({super.key, required this.movies});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 240,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: movies.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final movie = movies[i];
            return BlocProvider(
              create: (_) {
                final bloc = MovieRatingBloc(context.read<RatingRepository>());
                bloc.add(ListenFriendRatings(movie.id));
                return bloc;
              },
              child: MovieCard(
                movie: movie,
              ),
            );
          },
        ),
      );
}
