// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_description.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardDescription _$CardDescriptionFromJson(Map<String, dynamic> json) {
  return CardDescription(
      text: json['text'] as String,
      createdDate: json['created_date'] as String,
      updatedDate: json['updated_date'] as String);
}

Map<String, dynamic> _$CardDescriptionToJson(CardDescription instance) =>
    <String, dynamic>{
      'text': instance.text,
      'created_date': instance.createdDate,
      'updated_date': instance.updatedDate
    };
