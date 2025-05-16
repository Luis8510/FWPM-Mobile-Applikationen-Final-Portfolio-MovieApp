import 'package:equatable/equatable.dart';

abstract class YourMoviesEvent extends Equatable {
  const YourMoviesEvent();
  @override
  List<Object?> get props => [];
}

class LoadYourMovies extends YourMoviesEvent {
  final String userId;
  const LoadYourMovies(this.userId);
  @override
  List<Object?> get props => [userId];
}
