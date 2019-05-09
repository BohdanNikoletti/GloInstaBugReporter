import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:glo_insta_bug_reporter/src/models/attachment.dart';
import 'package:glo_insta_bug_reporter/src/models/glo_board.dart';
import 'package:glo_insta_bug_reporter/src/models/glo_card.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'token_storage_service.dart';

const String _SERVER_ROOT = 'https://gloapi.gitkraken.com/v1/glo/';

Future<GloCard> create(
  GloCard card,
  String boardId,
) async {
  final String token = await TokenStorageService().getMobileToken();
  final String newCardJSON = json.encode(card.toJson());
  final http.Response response =
      await http.post('${_SERVER_ROOT}boards/$boardId/cards',
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application\/json'
          },
          body: newCardJSON);
  if (response.statusCode == 201 || response.statusCode == 200) {
    return GloCard.fromJson(json.decode(response.body));
  } else {
    TokenStorageService().setMobileToken('');
    throw Exception(json.decode(response.body));
  }
}

Future<List<GloBoard>> getBoards({int page, int perPage}) async {
  const String fieldsParam = 'fields=name,columns';
  final String pageParam = 'page=$page';
  final String perPageParam = 'per_page=$perPage';
  final String token = await TokenStorageService().getMobileToken();
  final http.Response response = await http.get(
      '${_SERVER_ROOT}boards?$fieldsParam&&$pageParam&&$perPageParam',
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $token'
      });
  if (response.statusCode == 200) {
    final List<dynamic> responseArray = json.decode(response.body);
    return responseArray
        .map((dynamic item) => GloBoard.fromJson(item))
        .toList(growable: false);
  } else {
    TokenStorageService().setMobileToken('');
    throw Exception(json.decode(response.body));
  }
}

Future<GloCard> updateCard(GloCard card, String boardId) async {
  final String token = await TokenStorageService().getMobileToken();
  final String newCardJSON = json.encode(card.toJson());
  final http.Response response =
      await http.post('${_SERVER_ROOT}boards/$boardId/cards/${card.id}',
          headers: <String, String>{
            HttpHeaders.authorizationHeader: 'Bearer $token',
            HttpHeaders.contentTypeHeader: 'application\/json'
          },
          body: newCardJSON);
  if (response.statusCode == 200) {
    return GloCard.fromJson(json.decode(response.body));
  } else {
    TokenStorageService().setMobileToken('');
    throw Exception(json.decode(response.body));
  }
}

Future<Attachment> upload(
    {ui.Image image, String boardId, String cardId}) async {
  final ByteData byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List imgBytes = byteData.buffer.asUint8List();
  final String token = await TokenStorageService().getMobileToken();
  final Uri uri =
      Uri.parse('${_SERVER_ROOT}boards/$boardId/cards/$cardId/attachments');
  final http.MultipartRequest request = http.MultipartRequest('POST', uri);
  request.headers.addAll(<String, String>{
    HttpHeaders.contentTypeHeader: 'multipart/form-data',
    HttpHeaders.authorizationHeader: 'Bearer $token',
  });
  request.files.add(http.MultipartFile.fromBytes('file', imgBytes,
      filename: 'screenShot.png', contentType: MediaType('image', 'png')));
  final http.Response response =
      await http.Response.fromStream(await request.send());
  if (response.statusCode == 201) {
    final Map<String, dynamic> decodedResponse = json.decode(response.body);
    return Attachment.fromJson(decodedResponse);
  } else {
    TokenStorageService().setMobileToken('');
    throw Exception(json.decode(response.body));
  }
}
