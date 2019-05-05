import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:glo_insta_bug_reporter/src/services/token_storage_service.dart';
import 'package:http/http.dart' as http;
import 'package:oauth2/oauth2.dart' as oauth2;
import 'package:glo_insta_bug_reporter/src/models/glo_config.dart';
import 'package:flutter/services.dart' show rootBundle;

class AuthorizationService {
  factory AuthorizationService() => _singleton;
  AuthorizationService._internal() {
    _flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (!url.startsWith(_redirectUrl.toString())) {
        return;
      }
      final Uri encoded = Uri.parse(url);
      final String code = encoded.queryParameters['code'];
      _loadToken(code).then((bool succeeded) {
        if (!succeeded) {
          return;
        }
        _flutterWebViewPlugin.close();
        onSignedIn();
      });
    });
  }
  final String _serverRoot = 'https://api.gitkraken.com/oauth/';
  final Uri _authorizationEndpoint =
      Uri.parse('https://app.gitkraken.com/oauth/authorize');
  final Uri _redirectUrl = Uri.parse('http://geekowl.com.ua');
  final Uri _tokenEndpoint =
      Uri.parse('https://api.gitkraken.com/oauth/access_token');

  static final AuthorizationService _singleton =
      AuthorizationService._internal();
  final FlutterWebviewPlugin _flutterWebViewPlugin = FlutterWebviewPlugin();
  Function onSignedIn;

  Future<void> login(BuildContext context) async {
    final String token = await TokenStorageService().getMobileToken();
    if (token.isNotEmpty) {
      onSignedIn();
      return;
    }
    final GloConfig gloConfig = await _readConfig();
    final oauth2.AuthorizationCodeGrant grant = oauth2.AuthorizationCodeGrant(
        gloConfig.identifier, _authorizationEndpoint, _tokenEndpoint,
        secret: gloConfig.secret);
    final String launchURL = grant.getAuthorizationUrl(_redirectUrl,
        scopes: <String>['board:write']).toString();
    _flutterWebViewPlugin.launch(
      launchURL,
      rect: Rect.fromLTWH(
        0.0,
        0.0,
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height,
      ),
    );
  }

  Future<bool> _loadToken(String code) async {
    final GloConfig gloConfig = await _readConfig();
    final http.Response response =
        await http.post('${_serverRoot}access_token', body: <String, String>{
      'grant_type': 'authorization_code',
      'client_id': gloConfig.identifier,
      'client_secret': gloConfig.secret,
      'code': code
    });
    final Map<String, dynamic> jsonData = json.decode(response.body);
    final String token = jsonData['access_token'];
    if (token == null || token.isEmpty) {
      return false;
    }
    TokenStorageService().setMobileToken(token);
    return true;
  }

  Future<GloConfig> _readConfig() async {
    final String fileData =
        await rootBundle.loadString('assets/glo_config.json');
    final Map<String, String> jsonData =
        Map<String, String>.from(json.decode(fileData));
    return GloConfig.fromJson(jsonData);
  }
}
