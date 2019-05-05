// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attachment _$AttachmentFromJson(Map<String, dynamic> json) {
  return Attachment(
      id: json['id'] as String,
      filename: json['filename'] as String,
      mimeType: json['mime_type'] as String,
      url: json['url'] as String);
}

Map<String, dynamic> _$AttachmentToJson(Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'filename': instance.filename,
      'mime_type': instance.mimeType,
      'url': instance.url
    };
