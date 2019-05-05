import 'package:json_annotation/json_annotation.dart';
import 'card_description.dart';
part 'glo_card.g.dart';

//flutter packages pub run build_runner watch
@JsonSerializable()
class GloCard {
  GloCard(
      {this.position,
        this.boardId,
        this.columnId,
        this.dueDate,
        this.commentCount,
        this.attachmentCount,
        this.completedTaskCount,
        this.totalTaskCount,
        this.id,
        this.name,
        this.updatedDate,
        this.description,
        this.archivedDate,
        this.createdDate});

  factory GloCard.fromJson(Map<String, dynamic> json) =>
      _$GloCardFromJson(json);
  final int position;
  @JsonKey(name: 'board_id')
  final String boardId;
  @JsonKey(name: 'column_id')
  final String columnId;
  @JsonKey(name: 'updated_date')
  final String updatedDate;
  @JsonKey(name: 'due_date')
  final String dueDate;
  @JsonKey(name: 'comment_count')
  final int commentCount;
  @JsonKey(name: 'attachment_count')
  final int attachmentCount;
  @JsonKey(name: 'completed_task_count')
  final int completedTaskCount;
  CardDescription description;
  @JsonKey(name: 'total_task_count')
  final int totalTaskCount;
  final String id;
  final String name;
  @JsonKey(name: 'archived_date')
  final String archivedDate;
  @JsonKey(name: 'created_date')
  final String createdDate;

  Map<String, dynamic> toJson() => _$GloCardToJson(this);

  @override
  String toString() => toJson().toString();

  @override
  int get hashCode => id.hashCode;

  @override
  bool operator ==(dynamic other) {
    return id == other.id;
  }
}
