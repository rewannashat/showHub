
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showhub/presentation/screens/Home/home-viewModel/home-cubit.dart';
import 'package:showhub/presentation/screens/Home/home-viewModel/home-states.dart';

import '../../resources/colors-manager.dart';
import '../../resources/font-manager.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = HomeCubit.get(context);

        return SafeArea(
          child: Scaffold(
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changePage(index);
              },
              type: BottomNavigationBarType.fixed,
              items: cubit.items,
            ),
          ),
        );
      },
    );
  }
}
