import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showhub/presentation/screens/Home/home-view.dart';
import 'package:showhub/presentation/screens/Home/home-viewModel/home-cubit.dart';

import 'domian/bloc_observer.dart';
import 'domian/local/sharedPref.dart';
import 'package:loader_overlay/loader_overlay.dart';


Future<void> main() async {

  Bloc.observer = MyBlocObserver();
  await ScreenUtil.ensureScreenSize();
  await SharedPreferencesHelper.init();

  WidgetsFlutterBinding.ensureInitialized();


  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => GlobalLoaderOverlay(
          useDefaultLoading: true,
          child: MyApp()), // Wrap your app
    ),);
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(
      context,
      designSize: Size(360, 690), // Use your design size
      minTextAdapt: true,
    );
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeCubit()..getChannels()..fetchLiveCategories()..fetchMovieCategories()..getMovies(),
          ),
        ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: HomeView(),
      ),
     );
  }
}

