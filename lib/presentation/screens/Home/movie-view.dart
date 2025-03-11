import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../resources/colors-manager.dart';
import '../../resources/font-manager.dart';
import '../../resources/values-manager.dart';
import 'home-viewModel/Movie-list.dart';
import 'home-viewModel/home-cubit.dart';
import 'home-viewModel/home-states.dart';
import 'moviedetails-view.dart';

class MovieView extends StatelessWidget {
  const MovieView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        HomeCubit cubit = HomeCubit.get(context);
        return Scaffold(
        backgroundColor: ColorsManager.backMainColor,
        body: Column(
          children: [
            SizedBox(height: size.height*0.05,),
            Container(
                margin: EdgeInsetsDirectional.symmetric(
                  horizontal: size.width * 0.10, ),
                width: 280.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppSize.s15),
                ),
                child: Align(
                  alignment: Alignment.centerLeft, // Align icon to the right
                  child: Padding(
                    padding: EdgeInsets.only(left: 10), // Add some right padding
                    child: Icon(Icons.search, color: Colors.black),
                  ),
                )),
            Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
            width: 280.w,
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: cubit.selectedCategory,
                hint: Text("Select Category", style: TextStyle(color: Colors.grey)),
                onChanged: (newValue) {
                  if (newValue != null) {
                    cubit.changeDropdownVal(newValue);
                  }
                },
                items: cubit.categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.categoryId,
                    child: Text(category.categoryName),
                  );
                }).toList(),
              ),
            ),
          ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 10,bottom: 10,top: 20),
                child: Text('Movies' , style: TextStyle(
                    fontSize: AppSize.s20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.whiteColor,
                    fontFamily: FontManager.fontFamilyTitle
                ),),
              ),
            ),
            Expanded(
              child: BlocProvider(
                create: (context) => HomeCubit()..getMovies(),
                child: BlocBuilder<HomeCubit, HomeStates>(
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is MovieState) {
                    //  print('The data of this selected ${state.movies.length}');
                      return GridView.builder(
                        padding: EdgeInsets.all(8),
                        itemCount: 200,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.8,
                        ),
                        itemBuilder: (context, index) {
                          return MovieCard(movie: state.movies[index]);
                        },
                      );
                    } else if (state is ErrorState) {
                      return Center(child: Text(state.message));
                    } else {
                      return Center(child: Text("No movies available"));
                    }
                  },
                ),
              ),
            ),




          ],
        ),

      );
      },
    );
  }
}

 class MovieCard extends StatelessWidget {
   final Movie movie;

   MovieCard({required this.movie});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailsScreen(
              streamId: movie.streamId, // Pass the stream_id of the movie
              username: "16377097252198", // Pass username
              password: "22718995529521", // Pass password
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.s5),
        ),
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                movie.streamIcon.isNotEmpty && Uri.tryParse(movie.streamIcon)?.hasAbsolutePath == true
                    ? movie.streamIcon
                    : 'https://via.placeholder.com/150', // Fallback image
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/bein.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, ),
              child: Text(
                movie.name,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
                maxLines: 2, // Prevents overflow
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    ) ;

  }
}
