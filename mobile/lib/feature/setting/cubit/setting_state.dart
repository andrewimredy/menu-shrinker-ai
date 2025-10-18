part of 'setting_cubit.dart';

class SettingState extends Equatable {
  const SettingState({this.isLoading = false, this.user});

  final bool isLoading;
  final User? user;

  SettingState copyWith({bool? isLoading, User? user}) {
    return SettingState(isLoading: isLoading ?? this.isLoading, user: user ?? this.user);
  }

  @override
  List<Object?> get props => [isLoading, user];
}

enum SuccessSettingType { accountLogOuted, accountDeleted }

class SuccessSettingState extends SettingState {
  SuccessSettingState({required this.type, required SettingState state})
    : super(isLoading: state.isLoading, user: state.user);

  final SuccessSettingType type;

  @override
  List<Object?> get props => [...super.props, type];
}

class FailureSettingState extends SettingState {
  FailureSettingState({required this.error, required SettingState state})
    : super(isLoading: state.isLoading, user: state.user);

  final String error;

  @override
  List<Object?> get props => [...super.props, error];
}
