import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../common/common.dart';

part 'setting_state.dart';

@injectable
class SettingCubit extends Cubit<SettingState> {
  SettingCubit(this.userService) : super(const SettingState());

  final UserService userService;

  void init(User user) {
    emit(state.copyWith(user: user));
  }

  Future<void> onLogOutUser() async {
    await userService.logout();
    emit(SuccessSettingState(state: state, type: SuccessSettingType.accountLogOuted));
  }

  Future<void> onDeleteUser() async {
    await userService.deleteUser();
    emit(SuccessSettingState(state: state, type: SuccessSettingType.accountDeleted));
  }
}
