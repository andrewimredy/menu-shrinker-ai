import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/common.dart';
import 'cubit/login_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<LoginCubit>()..init(),
      child: const Scaffold(extendBodyBehindAppBar: true, body: LoginView()),
    );
  }
}

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        context.updateLoadingOverlay(isLoading: state.isLoading);
        if (state is SuccessLoginState) {
          switch (state.type) {
            case SuccessLoginType.completed:
              const HomeRoute().go(context);
            default:
          }
        } else if (state is FailureLoginState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.error, style: listItemStyle), backgroundColor: redColor));
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Text('vibely'.tr(), style: bigAppNameStyle),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BlocBuilder<LoginCubit, LoginState>(
                builder: (context, state) {
                  final loginCubit = context.read<LoginCubit>();
                  return Column(
                    children: [
                      CenterOutlinedAppButton(
                        title: 'login.google'.tr(),
                        icon: Assets.icons.google,
                        onTap: () {
                          loginCubit.onLogin(SignInProvider.google);
                        },
                      ),
                      if (state.isAppleSignInAvailable) ...[
                        SizedBox(height: 12),
                        CenterOutlinedAppButton(
                          title: 'login.apple'.tr(),
                          icon: Assets.icons.apple,
                          onTap: () {
                            loginCubit.onLogin(SignInProvider.apple);
                          },
                        ),
                      ],

                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: smallLightTextStyle.copyWith(color: buttonGreyColor),
                            children: [
                              TextSpan(text: 'login.legal_text'.tr()),
                              TextSpan(
                                text: 'login.terms'.tr(),
                                style: smallTextStyle.copyWith(color: buttonGreyColor),
                              ),
                              TextSpan(text: 'login.and'.tr()),
                              TextSpan(
                                text: 'login.privacy_policy'.tr(),
                                style: smallTextStyle.copyWith(color: buttonGreyColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
