part of 'login_cubit.dart';

class LoginState extends Equatable {
  const LoginState({this.isLoading = false, this.isAppleSignInAvailable = false});

  final bool isLoading;
  final bool isAppleSignInAvailable;

  LoginState copyWith({bool? isLoading, bool? isAppleSignInAvailable}) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isAppleSignInAvailable: isAppleSignInAvailable ?? this.isAppleSignInAvailable,
    );
  }

  @override
  List<Object?> get props => [isLoading, isAppleSignInAvailable];
}

enum SuccessLoginType { completed, updated }

class SuccessLoginState extends LoginState {
  SuccessLoginState({required this.type, required LoginState state})
    : super(isLoading: false, isAppleSignInAvailable: state.isAppleSignInAvailable);

  final SuccessLoginType type;

  @override
  List<Object?> get props => [...super.props, type];
}

class FailureLoginState extends LoginState {
  FailureLoginState({required this.error, required LoginState state})
    : super(isLoading: false, isAppleSignInAvailable: state.isAppleSignInAvailable);

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
