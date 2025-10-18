import 'package:fodie_ai/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fodie_ai/feature/home/cubit/home_state.dart';

import 'cubit/home_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeCubit>()/*..init()*/,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () {
                    // SettingRoute($extra: state.user).push(context);
                  },
                  child: SvgPicture.asset(Assets.icons.settings),
                );
              },
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: const HomeView(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // TODO implement it
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container (
      width: 100,
      height: 100,
      color: Colors.red,
    );
  }
}
