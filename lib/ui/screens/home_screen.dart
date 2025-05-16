import 'package:finalportfolio/bloc/genre_movies/genre_movies_bloc.dart';
import 'package:finalportfolio/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/search_movies/search_movies_bloc.dart';
import '../../utils/constants.dart';
import '../widgets/endless_movie_list.dart';
import '../widgets/movie_list.dart';
import '../widgets/section_header.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  final focusNode = FocusNode();

  bool isSearching = false;

  String? _selectedGenre = Constants.genreIds.keys.first;

  @override
  void initState() {
    context.read<PopularMoviesBloc>().add(const LoadPopularMovies());
    context.read<GenreMoviesBloc>().add(LoadGenreMovies(_selectedGenre!));
    super.initState();
  }

  void _runSearch(String query) {
    if (query.isEmpty) {
      setState(() => isSearching = false);
      focusNode.unfocus();
    } else {
      setState(() => isSearching = true);
      context.read<SearchMoviesBloc>().add(SearchMovies(query.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, auth) {
        if (auth is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(ctx, LoginScreen.routeName);
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Search Movie',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _searchCtrl.clear();
                          _runSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: _runSearch,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthBloc>().add(LoggedOut()),
            ),
          ],
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<PopularMoviesBloc>().add(const LoadPopularMovies());
              context
                  .read<GenreMoviesBloc>()
                  .add(LoadGenreMovies(_selectedGenre!));
            },
            child: ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [
                if (!isSearching) ...[
                  const SectionHeader(label: 'Popular'),
                  BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
                      builder: (context, state) {
                    if (state is PopularMoviesLoading) {
                      return const SizedBox(
                        height: 240,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is PopularMoviesError) {
                      return const Center(
                        child: Text('Error while loading movies'),
                      );
                    }
                    if (state is PopularMoviesLoaded) {
                      return EndlessMovieList(movies: state.popularMovies);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
                if (!isSearching) ...[
                  const SectionHeader(label: 'Genres'),
                  _GenreChips(
                    genres: Constants.genreIds.keys.toList(),
                    selected: _selectedGenre,
                    onSelected: (g) {
                      setState(() => _selectedGenre = g);
                      context.read<GenreMoviesBloc>().add(
                            LoadGenreMovies(g!),
                          );
                    },
                  ),
                  BlocBuilder<GenreMoviesBloc, GenreMoviesState>(
                      builder: (context, state) {
                    if (state is GenreMoviesLoading) {
                      return const SizedBox(
                        height: 240,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    if (state is GenreMoviesError) {
                      return Center(
                        child: Text(
                          'No movies in genre "$_selectedGenre"',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      );
                    }
                    if (state is GenreMoviesLoaded) {
                      final movies = state.genreMovies;
                      return MovieList(movies: movies);
                    }
                    return const SizedBox.shrink();
                  }),
                ],
                if (isSearching) ...[
                  const SectionHeader(label: 'Search Results'),
                  BlocBuilder<SearchMoviesBloc, SearchMoviesState>(
                    builder: (context, state) {
                      if (state is SearchingMovies) {
                        return const SizedBox(
                          height: 240,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (state is SearchMovieError) {
                        return Center(
                          child: Text(
                            'No movies in genre "$_selectedGenre"',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        );
                      }
                      if (state is SearchedMovies) {
                        final movies = state.searchResults;
                        return MovieList(movies: movies);
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GenreChips extends StatelessWidget {
  final List<String> genres;
  final String? selected;
  final void Function(String?) onSelected;

  const _GenreChips({
    required this.genres,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: genres.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, index) {
            final g = genres[index];
            final isSelected = g == selected;
            return ChoiceChip(
              label: Text(g),
              selected: isSelected,
              onSelected: (_) => onSelected(g),
              selectedColor: Theme.of(context).chipTheme.selectedColor,
              backgroundColor: Theme.of(context).chipTheme.backgroundColor,
              labelStyle: TextStyle(
                color: isSelected
                    ? Theme.of(context).chipTheme.labelStyle?.color
                    : Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).chipTheme.side?.color ??
                        Colors.transparent
                    : Theme.of(context)
                            .chipTheme
                            .side
                            ?.color
                            .withOpacity(0.25) ??
                        Colors.transparent,
              ),
            );
          },
        ),
      );
}
