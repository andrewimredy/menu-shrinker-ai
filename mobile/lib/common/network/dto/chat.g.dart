// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      id: json['id'] as String,
      duration: json['duration'] == null
          ? const Duration(minutes: 5)
          : Duration(microseconds: (json['duration'] as num).toInt()),
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'duration': instance.duration.inMicroseconds,
    };
