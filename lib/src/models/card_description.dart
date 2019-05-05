import 'package:json_annotation/json_annotation.dart';

part 'card_description.g.dart';

//flutter packages pub run build_runner watch
@JsonSerializable()
class CardDescription {
  CardDescription({this.text, this.createdDate, this.updatedDate});
  factory CardDescription.fromJson(Map<String, dynamic> json) =>
      _$CardDescriptionFromJson(json);

  final String text;
  @JsonKey(name: 'created_date')
  final String createdDate;
  @JsonKey(name: 'updated_date')
  final String updatedDate;


  Map<String, dynamic> toJson() => _$CardDescriptionToJson(this);

  @override
  String toString() => toJson().toString();
}
