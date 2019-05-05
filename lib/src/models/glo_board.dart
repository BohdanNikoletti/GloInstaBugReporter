import 'package:json_annotation/json_annotation.dart';
import 'glo_column.dart';
part 'glo_board.g.dart';

//flutter packages pub run build_runner watch
@JsonSerializable()
class GloBoard {
  GloBoard(
      {this.id, this.name, this.columns, this.archivedDate, this.createdDate});

  factory GloBoard.fromJson(Map<String, dynamic> json) =>
      _$GloBoardFromJson(json);
  final String id;
  final String name;
  final List<GloColumn> columns;
  @JsonKey(name: 'archived_date')
  final String archivedDate;
  @JsonKey(name: 'created_date')
  final String createdDate;

  Map<String, dynamic> toJson() => _$GloBoardToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) {
    return id == other.id;
  }
}
