// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glo_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GloConfig _$GloConfigFromJson(Map<String, dynamic> json) {
  return GloConfig(
      identifier: json['identifier'] as String,
      secret: json['secret'] as String);
}

Map<String, dynamic> _$GloConfigToJson(GloConfig instance) => <String, dynamic>{
      'identifier': instance.identifier,
      'secret': instance.secret
    };
