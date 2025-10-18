import 'package:equatable/equatable.dart';

import '../../../common/common.dart';

class HomeState extends Equatable {
  const HomeState({this.isLoading = false, this.user});

  final bool isLoading;
  final User? user;

  HomeState copyWith({bool? isLoading, User? user}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [isLoading, user];
}

enum SuccessHomeType { completed, updated }

class SuccessHomeState extends HomeState {
  SuccessHomeState({required this.type, required HomeState state})
      : super(isLoading: state.isLoading, user: state.user);

  final SuccessHomeType type;

  @override
  List<Object?> get props => [...super.props, type];
}

class FailureHomeState extends HomeState {
  FailureHomeState({required this.error, required HomeState state})
      : super(isLoading: false, user: state.user);

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
