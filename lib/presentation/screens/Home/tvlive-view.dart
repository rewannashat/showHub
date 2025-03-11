import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showhub/presentation/resources/colors-manager.dart';
import 'package:showhub/presentation/resources/font-manager.dart';
import 'package:showhub/presentation/resources/values-manager.dart';
import 'package:showhub/presentation/screens/Home/home-viewModel/home-cubit.dart';
import 'package:showhub/presentation/screens/Home/home-viewModel/home-states.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home-viewModel/MovieCategory-list.dart';
import 'home-viewModel/chanel-list.dart';
import 'live_player_screen.dart';

class TvLiveView extends StatelessWidget {
  const TvLiveView({super.key});

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
                  value: cubit.selectedLiveCategory,
                  hint: cubit.selectedLiveCategory == null
                      ? Text("Select Category") // Show "Select Category" initially
                      : Text(cubit.liveCategories.firstWhere(
                          (category) => category.categoryId == cubit.selectedCategory,
                      orElse: () => MovieCategory(categoryId: '', categoryName: 'Select Category')).categoryName,
                  ),
                  onChanged: (newValue) {
                    cubit.changeDropdownValue(newValue!);
                  },
                  items: cubit.liveCategories.map((category) {
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
                child: Text('Channels' , style: TextStyle(
                    fontSize: AppSize.s20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorsManager.whiteColor,
                    fontFamily: FontManager.fontFamilyTitle
                ),),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: BlocProvider(
                  create: (context) => HomeCubit()..getChannels(),
                  child: BlocBuilder<HomeCubit, HomeStates>(
                    builder: (context, state) {
                      if (state is LoadingState) {
                        return Center(child: CircularProgressIndicator());
                      } else if (state is LoadedState) {
                        return GridView.builder(
                          shrinkWrap: true, // FIXES THE ERROR
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(8),
                          itemCount: 100, //state.channels.length
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            return ChannelCard(channel: state.channels[index]);
                          },
                        );
                      } else if (state is ErrorState) {
                        return Center(child: Text(state.message));
                      } else {
                        return Center(child: Text("No data available"));
                      }
                    },
                  ),
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

class ChannelCard extends StatelessWidget {
  final Channel channel;

  ChannelCard({required this.channel});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        final streamUrl = "http://tgdns4k.com:8080/live/1234322441154/73057628438336/${channel.streamId}.ts";
          print('the link of livestream $streamUrl');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LivePlayerScreen(streamUrl: streamUrl),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.s5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  channel.imageUrl.isNotEmpty && Uri.tryParse(channel.imageUrl)?.hasAbsolutePath == true
                      ? channel.imageUrl
                      : 'https://via.placeholder.com/150', // Fallback image
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/bein.png'),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              channel.name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }}
