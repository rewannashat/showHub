import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'home-viewModel/MoviePlayerScreen.dart';
import 'home-viewModel/home-cubit.dart';
import 'home-viewModel/home-states.dart';

class MovieDetailsScreen extends StatelessWidget {
  final int streamId;
  final String username;
  final String password;

  MovieDetailsScreen({
    required this.streamId,
    required this.username,
    required this.password,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..fetchMovieDetails(streamId, username, password),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: BlocBuilder<HomeCubit, HomeStates>(
          builder: (context, state) {
            if (state is LoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MovieDetailsLoadedState) {
              final movieDetails = state.movieDetails;
              print('the data is $movieDetails');
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          movieDetails["info"]["movie_image"],
                          width: double.infinity,
                          //height: 350.h,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                              Text(movieDetails["info"]["youtube_trailer"] ?? "Unknown Title",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),),
                              IconButton(
                                icon: Icon(Icons.favorite_border, color: Colors.white),
                                onPressed: () {
                                  // Handle favorite action
                                },
                              ),
                            ],
                          ),
                        ),
                      ],

                    ),
                    SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        "Summary",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        movieDetails["info"]["plot"] ?? "No description available.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ),

                    SizedBox(height: 16),


                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          /// Year
                          Text(
                            "Cinema ${movieDetails["info"]["year"] ?? "Unknown"}",
                            style: TextStyle(color: Colors.purple, fontSize: 14),
                          ),

                          /// Separator |
                          SizedBox(width: 6),
                          Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          SizedBox(width: 6),

                          /// Age Restriction +18
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "+18",
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),

                          /// Separator |
                          SizedBox(width: 6),
                          Text("|", style: TextStyle(color: Colors.white70, fontSize: 14)),
                          SizedBox(width: 6),

                          /// Genre
                          Text(
                            movieDetails["info"]["genre"] ?? "Action",
                            style: TextStyle(color: Colors.purple, fontSize: 14),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: 8),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star : Icons.star_border, // Example: 4 stars filled
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 16),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              final String streamId = movieDetails["info"]["tmdb_id"].toString();
                              final String extension = "mp4";

                              String movieUrl = "http://tgdns4k.com:8080/movie/1234322441154/73057628438336/$streamId.$extension";
                            //  print('url is $movieUrl');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MoviePlayerScreen(movieUrl: movieUrl),
                                ),
                              );
                            },
                            icon: Icon(Icons.play_arrow, color: Colors.white),
                            label: Text("Watch", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(Icons.video_library, color: Colors.white),
                            label: Text("Trailer", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade700,
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                  ],
                ),
              );
            } else if (state is ErrorState) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.white)),
              );
            } else {
              return Center(
                child: Text("No Data Available", style: TextStyle(color: Colors.white)),
              );
            }
          },
        ),
      ),
    );
  }
}
