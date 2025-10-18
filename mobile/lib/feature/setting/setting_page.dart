import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../common/common.dart';
import 'cubit/setting_cubit.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SettingCubit>()..init(user),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: ArrowButtonLeft(
            onTap: () {
              context.pop();
            },
          ),
          title: Text('settings.settings'.tr(), style: pageHeaderSmallStyle.copyWith(color: buttonGreyColor)),
          centerTitle: true,
        ),
        body: const SettingView(),
      ),
    );
  }
}

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingCubit, SettingState>(
      listener: (context, state) {
        if (state is SuccessSettingState) {
          switch (state.type) {
            case SuccessSettingType.accountDeleted:
            case SuccessSettingType.accountLogOuted:
              const LoginRoute().go(context);
          }
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            Container(decoration: BoxDecoration(border: Border(top: BorderSide(color: lightGreyColor, width: 2)))),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CenterOutlinedAppButton(
                onTap: () {
                  context.read<SettingCubit>().onLogOutUser();
                },
                title: 'setting.logout'.tr(),
                titleColor: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CenterOutlinedAppButton(
                onTap: () {
                  context.read<SettingCubit>().onDeleteUser();
                },
                title: 'setting.delete_account'.tr(),
                titleColor: redColor,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
