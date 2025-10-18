import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../common/common.dart';

part 'login_state.dart';

@injectable
class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.userService) : super(const LoginState());

  final UserService userService;

  Future<void> init() async {
    final isAppleAvailable = await SignInWithApple.isAvailable();
    emit(state.copyWith(isAppleSignInAvailable: isAppleAvailable));
  }

  Future<void> onLogin(SignInProvider signInProvider) async {
    emit(state.copyWith(isLoading: true));
    final res = await userService.getUser(signInProvider: signInProvider);
    if (res.isError) {
      emit(FailureLoginState(error: res.error.toString(), state: state));
      return;
    }
    emit(SuccessLoginState(type: SuccessLoginType.completed, state: state));
  }
}
