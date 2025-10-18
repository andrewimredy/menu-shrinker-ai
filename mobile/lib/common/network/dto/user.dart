// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../common.dart';

part 'user.freezed.dart';

part 'user.g.dart';

enum SignInProvider { apple, google }

@freezed
class User with _$User {
  const User._();

  const factory User({
    required String id,
    required String email,
    @JsonKey(name: 'account_name') String? accountName,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
