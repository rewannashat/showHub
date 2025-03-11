
import 'package:flutter/foundation.dart';

import 'Movie-list.dart';
import 'MovieCategory-list.dart';
import 'chanel-list.dart';

abstract class HomeStates {}
class InitialState extends HomeStates {}
class ChangeBottomNavState extends HomeStates {}
class ChangeSelectedListState extends HomeStates {}

class LoadingState extends HomeStates {}

class LoadedState extends HomeStates {
  final List<Channel> channels;
  LoadedState(this.channels);
}

class LiveCategoriesLoaded extends HomeStates {
  final List<MovieCategory> liveCategories;
  final String? selectedLiveCategory;

  LiveCategoriesLoaded(this.liveCategories, this.selectedLiveCategory);
}

class ErrorState extends HomeStates {
  final String message;
  ErrorState(this.message);
}


class MovieLoading extends HomeStates {}

class MovieLoaded extends HomeStates {
  final List<MovieCategory> categories;
  final String? selectedCategory;

  MovieLoaded(this.categories, this.selectedCategory);
}

class MovieError extends HomeStates {
  final String message;
  MovieError(this.message);
}

class AllMovieLoaded extends HomeStates {
  final List<Movie> movies;
  AllMovieLoaded(this.movies);
}

class MovieState extends HomeStates {
  final List<Movie> movies;
  MovieState(this.movies);

}

class MovieDetailsLoadedState extends HomeStates {
  final Map<String, dynamic> movieDetails;
  MovieDetailsLoadedState(this.movieDetails);
}





