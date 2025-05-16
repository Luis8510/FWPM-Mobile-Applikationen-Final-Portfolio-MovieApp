import 'package:finalportfolio/ui/widgets/movie_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/your_movies/your_movies_bloc.dart';
import '../widgets/section_header.dart';

class YourMoviesScreen extends StatefulWidget {
  static const routeName = '/your_movies';
  final bool isActive;
  const YourMoviesScreen({Key? key, required this.isActive}) : super(key: key);

  @override
  State<YourMoviesScreen> createState() => _YourMoviesScreenState();
}

class _YourMoviesScreenState extends State<YourMoviesScreen> {
  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<YourMoviesBloc>().add(LoadYourMovies(uid));
  }

  @override
  void didUpdateWidget(covariant YourMoviesScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _loadMovies();
    }
  }

  void _loadMovies() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    context.read<YourMoviesBloc>().add(LoadYourMovies(uid));
  }

  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? 'User';
    return BlocListener<AuthBloc, AuthState>(
      listener: (ctx, auth) {
        if (auth is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(ctx, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Hello $name',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthBloc>().add(LoggedOut()),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<YourMoviesBloc, YourMoviesState>(
            builder: (context, state) {
              if (state is YourMoviesLoading) {
                return ListView(
                  children: const [
                    SectionHeader(label: 'Your Movies'),
                    SizedBox(
                      height: 240,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    SectionHeader(label: 'Movies your Friends rated'),
                    SizedBox(
                      height: 240,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ],
                );
              }
              if (state is YourMoviesError) {
                return Center(child: Text(state.message ?? 'Error'));
              }
              if (state is YourMoviesLoaded) {
                return RefreshIndicator(
                  onRefresh: () async {
                    final uid = FirebaseAuth.instance.currentUser!.uid;
                    context.read<YourMoviesBloc>().add(LoadYourMovies(uid));
                  },
                  child: ListView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    children: [
                      const SectionHeader(label: 'Your Movies'),
                      MovieList(movies: state.yourMovies),
                      const SectionHeader(label: 'Movies your Friends rated'),
                      MovieList(movies: state.friendMovies),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
