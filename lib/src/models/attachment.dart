import 'package:json_annotation/json_annotation.dart';

part 'attachment.g.dart';

//flutter packages pub run build_runner watch
@JsonSerializable()
class Attachment {
  Attachment({this.id, this.filename, this.mimeType, this.url});
  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);

  final String id;
  final String filename;
  @JsonKey(name: 'mime_type')
  final String mimeType;
  final String url;

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) {
    return id == other.id;
  }

  Map<String, dynamic> toJson() => _$AttachmentToJson(this);

  @override
  String toString() => toJson().toString();
}
