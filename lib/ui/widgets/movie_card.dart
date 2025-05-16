import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finalportfolio/ui/widgets/rating_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/movie/movie_bloc.dart';
import '../../bloc/movie_rating/movie_rating_bloc.dart';
import '../../data/models/movie.dart';
import '../../utils/constants.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final bool isHorizontal;

  const MovieCard({
    Key? key,
    required this.movie,
    this.isHorizontal = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(16);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () {
          context.read<MovieBloc>().add(LoadMovie(movie.id));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
                if (state is MovieLoaded) {
                  final yourMovie = state.yourMovie;
                  return MovieDetailScreen(
                    movie: yourMovie,
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }),
            ),
          );
        },
        child: Ink(
          width: isHorizontal ? 140 : double.infinity,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2 / 3,
                  child: CachedNetworkImage(
                    imageUrl: '${Constants.imageBaseUrl}${movie.posterPath}',
                    fit: BoxFit.cover,
                    placeholder: (c, img) => Container(
                      color: Colors.grey.shade800,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    ),
                    errorWidget: (c, _, __) => Container(
                      color: Colors.grey.shade800,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 48),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                        color: Colors.black.withOpacity(0.55),
                        child: Text(
                          movie.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.25,
                            shadows: [
                              Shadow(
                                blurRadius: 4,
                                color: Colors.black54,
                                offset: Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<MovieRatingBloc, MovieRatingState>(
                    builder: (ctx, state) {
                      if (state is RatingsLoaded && state.ratings.isNotEmpty) {
                        final avg = state.ratings
                                .fold<double>(0, (sum, r) => sum + r.value) /
                            state.ratings.length;
                        return RatingBadge(
                          avgRating: avg,
                          noFriendRated: false,
                        );
                      }
                      if (state is RatingError) {
                        return const Icon(Icons.error, color: Colors.red);
                      }
                      if (movie.rating == null) {
                        return const SizedBox.shrink();
                      }
                      return RatingBadge(
                        avgRating: movie.rating!,
                        noFriendRated: true,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
