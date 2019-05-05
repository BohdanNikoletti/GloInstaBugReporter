// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glo_column.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GloColumn _$GloColumnFromJson(Map<String, dynamic> json) {
  return GloColumn(
      id: json['id'] as String,
      name: json['name'] as String,
      position: json['position'] as int,
      archivedDate: json['archived_date'] as String,
      createdDate: json['created_date'] as String);
}

Map<String, dynamic> _$GloColumnToJson(GloColumn instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'archived_date': instance.archivedDate,
      'created_date': instance.createdDate
    };
