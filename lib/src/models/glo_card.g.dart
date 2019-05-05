// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'glo_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GloCard _$GloCardFromJson(Map<String, dynamic> json) {
  return GloCard(
      position: json['position'] as int,
      boardId: json['board_id'] as String,
      columnId: json['column_id'] as String,
      dueDate: json['due_date'] as String,
      commentCount: json['comment_count'] as int,
      attachmentCount: json['attachment_count'] as int,
      completedTaskCount: json['completed_task_count'] as int,
      totalTaskCount: json['total_task_count'] as int,
      id: json['id'] as String,
      name: json['name'] as String,
      updatedDate: json['updated_date'] as String,
      description: json['description'] == null
          ? null
          : CardDescription.fromJson(
              json['description'] as Map<String, dynamic>),
      archivedDate: json['archived_date'] as String,
      createdDate: json['created_date'] as String);
}

Map<String, dynamic> _$GloCardToJson(GloCard instance) => <String, dynamic>{
      'position': instance.position,
      'board_id': instance.boardId,
      'column_id': instance.columnId,
      'updated_date': instance.updatedDate,
      'due_date': instance.dueDate,
      'comment_count': instance.commentCount,
      'attachment_count': instance.attachmentCount,
      'completed_task_count': instance.completedTaskCount,
      'description': instance.description,
      'total_task_count': instance.totalTaskCount,
      'id': instance.id,
      'name': instance.name,
      'archived_date': instance.archivedDate,
      'created_date': instance.createdDate
    };
