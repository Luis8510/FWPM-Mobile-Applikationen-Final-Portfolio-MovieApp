import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../data/models/movie.dart';
import '../../data/models/rating.dart';
import '../../bloc/movie_rating/movie_rating_bloc.dart';
import '../../utils/constants.dart';
import '../widgets/rating_stars.dart';

class MovieDetailScreen extends StatefulWidget {
  static const routeName = '/movie_detail';
  final Movie movie;

  const MovieDetailScreen({required this.movie, Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  Rating? _userRating;

  @override
  void initState() {
    super.initState();
    context.read<MovieRatingBloc>().add(ListenFriendRatings(widget.movie.id));
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    final gradientColors = isDarkMode
        ? Constants.darkThemeBackgroundGradient
        : Constants.lightThemeBackgroundGradient;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              pinned: false,
              backgroundColor: Theme.of(context).primaryColor,
              elevation: 2,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  widget.movie.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.movie.posterPath.isNotEmpty)
                      Hero(
                        tag: 'poster_${widget.movie.id}',
                        child: CachedNetworkImage(
                          imageUrl:
                              '${Constants.imageBaseUrl}${widget.movie.posterPath}',
                          fit: BoxFit.cover,
                          fadeInDuration: const Duration(milliseconds: 300),
                        ),
                      ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildInfoCard(context),
                  const SizedBox(height: 20),
                  _buildOverviewCard(context),
                  const SizedBox(height: 20),
                  _buildRatingCard(user),
                  const SizedBox(height: 20),
                  _buildFriendsCard(),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    final m = widget.movie;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (m.releaseDate != null)
                  Text(
                    'Released: ${m.releaseDate!.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 4),
                Text(
                  'Runtime: ${m.runtime} min',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (m.originalLanguage.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Language: ${m.originalLanguage.toUpperCase()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ],
            ),
            if (m.rating != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black87.withOpacity(.8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      m.rating!.toStringAsFixed(1),
                      style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.blue, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '(${m.voteCount})',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              widget.movie.overview,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (widget.movie.genres.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Genre',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: widget.movie.genres
                    .map((g) => Chip(label: Text(g)))
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(User user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<MovieRatingBloc, MovieRatingState>(
          listener: (context, state) {
            if (state is RatingSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Saved your rating!')),
              );
            }
            if (state is RatingsLoaded) {
              if (state.ratings.isNotEmpty) {
                final self =
                    state.ratings.firstWhere((r) => r.userId == user.uid);
                setState(() => _userRating = self);
              }
            }
          },
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rating',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Center(
                  child: state is RatingSubmitting
                      ? const CircularProgressIndicator()
                      : RatingStars(
                          initialRating: _userRating?.value ?? 0,
                          size: 40,
                          onRated: (stars) {
                            context.read<MovieRatingBloc>().add(
                                  SubmitRating(
                                    movieId: widget.movie.id,
                                    movieName: widget.movie.title,
                                    rating: stars,
                                    userId: user.uid,
                                    username: user.displayName ??
                                        user.email ??
                                        'Anonymous',
                                  ),
                                );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFriendsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<MovieRatingBloc, MovieRatingState>(
          builder: (context, state) {
            if (state is RatingError) {
              return const Text('Error loading ratings');
            }
            if (state is RatingsLoaded) {
              final user = FirebaseAuth.instance.currentUser!;
              final friends =
                  state.ratings.where((r) => r.userId != user.uid).toList();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ratings from your Friends',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (friends.isEmpty)
                    const Center(child: Text('No ratings from friends yet'))
                  else
                    ...friends.map((r) => Column(
                          children: [
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                child: Text(r.username[0].toUpperCase()),
                              ),
                              title: Text(r.username),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(r.value.toStringAsFixed(1)),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.star, color: Colors.amber),
                                ],
                              ),
                            ),
                            if (r != friends.last) const Divider(),
                          ],
                        )),
                ],
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
