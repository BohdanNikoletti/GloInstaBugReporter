import 'package:json_annotation/json_annotation.dart';

part 'glo_config.g.dart';

//flutter packages pub run build_runner watch
@JsonSerializable()
class GloConfig {
  GloConfig({this.identifier, this.secret});
  factory GloConfig.fromJson(Map<String, dynamic> json) =>
      _$GloConfigFromJson(json);

  final String identifier;
  final String secret;

  Map<String, dynamic> toJson() => _$GloConfigToJson(this);

  @override
  String toString() => toJson().toString();
}
