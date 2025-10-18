// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat.freezed.dart';

part 'chat.g.dart';

@freezed
class Chat with _$Chat {
  const Chat._();

  const factory Chat({required String id, @Default(Duration(minutes: 5)) Duration duration}) = _Chat;

  factory Chat.fromJson(Map<String, Object?> json) => _$ChatFromJson(json);

  static List<Chat> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) {
      return Chat.fromJson(json);
    }).toList();
  }
}
