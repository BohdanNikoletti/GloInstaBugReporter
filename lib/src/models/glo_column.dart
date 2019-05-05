import 'package:json_annotation/json_annotation.dart';

part 'glo_column.g.dart';

//flutter packages pub run build_runner watch
@JsonSerializable()
class GloColumn {
  GloColumn(
      {this.id, this.name, this.position, this.archivedDate, this.createdDate});
  factory GloColumn.fromJson(Map<String, dynamic> json) =>
      _$GloColumnFromJson(json);

  final String id;
  final String name;
  final int position;
  @JsonKey(name: 'archived_date')
  final String archivedDate;
  @JsonKey(name: 'created_date')
  final String createdDate;

  Map<String, dynamic> toJson() => _$GloColumnToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) {
    return id == other.id;
  }
}
