import 'package:finalportfolio/bloc/movie/movie_bloc.dart';
import 'package:finalportfolio/bloc/genre_movies/genre_movies_bloc.dart';
import 'package:finalportfolio/bloc/popular_movies/popular_movies_bloc.dart';
import 'package:finalportfolio/bloc/theme/theme_bloc.dart';
import 'package:finalportfolio/ui/screens/home_screen.dart';
import 'package:finalportfolio/ui/screens/login_screen.dart';
import 'package:finalportfolio/ui/screens/main_screen.dart';
import 'package:finalportfolio/ui/screens/your_movies_screen.dart';
import 'package:finalportfolio/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'bloc/auth/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'bloc/movie_rating/movie_rating_bloc.dart';
import 'bloc/search_movies/search_movies_bloc.dart';
import 'bloc/your_movies/your_movies_bloc.dart';
import 'data/providers/api_client.dart';
import 'data/repositories/movie_repository.dart';
import 'data/repositories/rating_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  final themeBloc = await ThemeBloc.create();
  runApp(MovieApp(themeBloc: themeBloc));
}

class MovieApp extends StatelessWidget {
  final ThemeBloc themeBloc;
  const MovieApp({Key? key, required this.themeBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => MovieRepository(ApiClient())),
        RepositoryProvider(create: (_) => RatingRepository()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthBloc()
              ..add(
                AppStarted(),
              ),
          ),
          BlocProvider(
            create: (ctx) => SearchMoviesBloc(
              ctx.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => PopularMoviesBloc(
              ctx.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => GenreMoviesBloc(
              ctx.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => MovieBloc(
              ctx.read<MovieRepository>(),
            ),
          ),
          BlocProvider(
            create: (ctx) => MovieRatingBloc(
              ctx.read<RatingRepository>(),
            ),
          ),
          BlocProvider(
            create: (c) => YourMoviesBloc(
              c.read<RatingRepository>(),
              c.read<MovieRepository>(),
            ),
          ),
        ],
        child: BlocProvider.value(
          value: themeBloc,
          child: Builder(builder: (context) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              themeMode: context.watch<ThemeBloc>().state.themeMode,
              title: 'MovieApp',
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              home: const MainScreen(),
              routes: {
                MainScreen.routeName: (_) => const MainScreen(),
                LoginScreen.routeName: (_) => const LoginScreen(),
                HomeScreen.routeName: (_) => const HomeScreen(),
                YourMoviesScreen.routeName: (_) => const YourMoviesScreen(
                      isActive: false,
                    ),
              },
            );
          }),
        ),
      ),
    );
  }
}
