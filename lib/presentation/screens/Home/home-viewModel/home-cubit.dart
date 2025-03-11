import 'dart:developer';

import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showhub/presentation/resources/colors-manager.dart';
import 'package:showhub/presentation/resources/font-manager.dart';

import '../more-view.dart';
import '../movie-view.dart';
import '../series-view.dart';
import '../tvlive-view.dart';
import 'LiveCategory.dart';
import 'Movie-list.dart';
import 'MovieCategory-list.dart';
import 'chanel-list.dart';
import 'home-states.dart';




class HomeCubit extends Cubit <HomeStates> {
  HomeCubit() : super(InitialState());

  static HomeCubit get(context) => BlocProvider.of(context);


  // == Bottom Nav Bar LOGIC == //
  int currentIndex = 0;

  void changePage(int index) {
    if (currentIndex != index) {
      currentIndex = index;
     // log('Selected Index: $index');
      emit(ChangeBottomNavState());
    }
  }

  final List<Widget> screens = [
    TvLiveView(),
    MovieView(),
    seriesView(),
    MoreView(),
  ];


  List<BottomNavigationBarItem> get items {
    return [
      buildNavItem(0, "assets/images/TvLive.png", "TvLive"),
      buildNavItem(1, "assets/images/Movie.png", "Movie"),
      buildNavItem(2, "assets/images/Series.png", "Series"),
      buildNavItem(3, "assets/images/More.png", "More"),
    ];
  }


  BottomNavigationBarItem buildNavItem(int index, String imagePath,
      String label) {
    bool isSelected = index == currentIndex;

    return BottomNavigationBarItem(
      icon: TweenAnimationBuilder<double>(
        duration: Duration(milliseconds: 300),
        tween: Tween<double>(
            begin: isSelected ? 1.0 : 0.8, end: isSelected ? 1.2 : 0.8),
        builder: (context, value, child) {
          return Column(
            children: [
              Transform.scale(
                scale: value,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    isSelected ? ColorsManager.mainColor : ColorsManager
                        .greyColor,
                    BlendMode.srcIn,
                  ),
                  child: Image.asset(imagePath, width: 24, height: 24),
                ),
              ),
              AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: isSelected ? 1.0 : 0.6,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? ColorsManager.mainColor : ColorsManager
                        .greyColor,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      label: '',
    );
  }



  // ==== Api ENDPOINT ==== //

  final Dio dio = Dio();
  final String username = '16377097252198';
  final String password = '22718995529521';

   // ==== End ==== //



  // ==== LIVE LOGIC ==== //

  List<CategoryLive> categoriesLive = [];
  String? selectedCategoryLive;



  Future<void> getLives() async {
    emit(LoadingState());

    try {
      final response = await dio.get(
        "http://tgdns4k.com:8080/player_api.php",
        queryParameters: {
          "username": username,
          "password": password,
          "action": "get_live_streams",
        },
      );

    // print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
      //  print("Response Data");
        if (response.data is List) {
          List<Channel> allLives = List<Channel>.from(
              response.data.map((live) => Channel.fromJson(live)));

          emit(LoadedState(allLives));
        } else {
          emit(ErrorState("Unexpected response format. Expected a List."));
        }
      } else {
        emit(ErrorState("Failed to load live streams. Status code: ${response.statusCode}"));
      }
    } catch (e) {
      emit(ErrorState("Error fetching live streams: ${e.toString()}"));
    }
  }


  Future<void> fetchCategories() async {
    try {
      final response = await dio.get(
        'http://tgdns4k.com:8080/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_live_categories',
        },
      );

      if (response.data is List) {
       // log('the data ${response.data}');
        categoriesLive = (response.data as List)
            .map((json) => CategoryLive.fromJson(json))
            .toList();
      } else if (response.data is Map<String, dynamic> &&
          response.data.containsKey('categories')) {
        categoriesLive = (response.data['categories'] as List)
            .map((json) => CategoryLive.fromJson(json))
            .toList();
      ///  log('the data ${categoriesLive.length}');
      } else {
        emit(ErrorState('Failed to load categories'));
      }

      emit(LiveCategoriesLoaded(categoriesLive, selectedCategoryLive));
    } catch (e) {
      emit(ErrorState('Error fetching categories: $e'));
    }
  }

  void changeDropdownValue(String value) {
    selectedCategoryLive = value;
    getLives();
    emit(LiveCategoriesLoaded(categoriesLive, selectedCategoryLive));

  }







  // ==== Movies LOGIC ==== //


  List<MovieCategory> categories = [];
  String? selectedCategory;


  Future<void> fetchMovieCategories() async {
    emit(MovieLoading());
    try {
      final response = await dio.get(
        'http://tgdns4k.com:8080/player_api.php',
        queryParameters: {
          'username': username,
          'password': password,
          'action': 'get_vod_categories',
        },
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          categories = (response.data as List)
              .map((json) => MovieCategory.fromJson(json))
              .toList();
        } else if (response.data is Map<String, dynamic> &&
            response.data.containsKey('categories')) {
          categories = (response.data['categories'] as List)
              .map((json) => MovieCategory.fromJson(json))
              .toList();
         // log('the data ${categories.length}');
        } else {
          throw Exception('Invalid data format');
        }
        emit(MovieLoaded(categories, selectedCategory));
      } else {
        emit(MovieError('Failed to load movie categories'));
      }
    } catch (e) {
      emit(MovieError('Error: $e'));
    }
  }


  void changeDropdownVal(String value) {
    selectedCategory = value;
    getMovies();
    emit(MovieLoaded(categories, selectedCategory));
  }


  Future<void> getMovies() async {
    emit(MovieLoading());
    try {
      final response = await dio.get(
        "http://tgdns4k.com:8080/player_api.php",
        queryParameters: {
          "username": username,
          "password": password,
          "action": "get_vod_streams",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
       // log('the movie dataaaa ${data.toString()}');

        List<Movie> allMovies = data.map((movie) => Movie.fromJson(movie)).toList();
      //  log('the movie data ${data.toString()}');

        emit(MovieState(allMovies));
      } else {
        emit(ErrorState("Failed to load movies"));
      }
    } catch (e) {
      emit(ErrorState("Error: ${e.toString()}"));
    }
  }






  // == Movies Details LOGIC == //

  Future<void> fetchMovieDetails(int streamId, String username, String password) async {
    emit(LoadingState());

    try {
      final response = await Dio().get(
        "http://tgdns4k.com:8080/player_api.php",
        queryParameters: {
          "username": username,
          "password": password,
          "action": "get_vod_info",
          "vod_id": streamId.toString(),
        },
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
      //  print("Stream ID: $streamId");
        emit(MovieDetailsLoadedState(response.data));
      } else {
        emit(ErrorState("Failed to load movie details"));
      }
    } catch (e) {
      emit(ErrorState("Error: ${e.toString()}"));
    }
  }


  // == Url Video Request == //

  Future<void> checkMovieUrl(String url) async {
    try {
      final response = await Dio().get(url);
      print("Response status: ${response.statusCode}");
      emit(SucessState());
    } catch (e) {
        print("Error: $e");
    }
  }

}











