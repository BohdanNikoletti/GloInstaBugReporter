// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glo_board.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GloBoard _$GloBoardFromJson(Map<String, dynamic> json) {
  return GloBoard(
      id: json['id'] as String,
      name: json['name'] as String,
      columns: (json['columns'] as List)
          ?.map((e) =>
              e == null ? null : GloColumn.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      archivedDate: json['archived_date'] as String,
      createdDate: json['created_date'] as String);
}

Map<String, dynamic> _$GloBoardToJson(GloBoard instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'columns': instance.columns,
      'archived_date': instance.archivedDate,
      'created_date': instance.createdDate
    };
