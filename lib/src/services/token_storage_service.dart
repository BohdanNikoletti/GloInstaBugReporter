import 'package:shared_preferences/shared_preferences.dart';

class TokenStorageService {
  factory TokenStorageService() => _singleton;
  TokenStorageService._internal();

  static final TokenStorageService _singleton = TokenStorageService._internal();
  final String _storageKeyMobileToken = 'token';
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getMobileToken() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_storageKeyMobileToken) ?? '';
  }

  Future<bool> setMobileToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_storageKeyMobileToken, token);
  }
}

class ConfigStorageService {
  factory ConfigStorageService() => _singleton;
  ConfigStorageService._internal();

  static final ConfigStorageService _singleton =
      ConfigStorageService._internal();
  final String _storageKeyConfigBoardId = 'onfig_board_id';
  final String _storageKeyConfigColumnId = 'config_column_id';

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<Config> getConfig() async {
    final SharedPreferences prefs = await _prefs;
    final String boardId = prefs.getString(_storageKeyConfigBoardId);
    final String columnId = prefs.getString(_storageKeyConfigColumnId);
    return Config(boardId: boardId, columnId: columnId);
  }

  Future<void> setConfig(Config config) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(_storageKeyConfigBoardId, config.boardId);
    await prefs.setString(_storageKeyConfigColumnId, config.columnId);
  }
}

class Config {
  const Config({this.boardId, this.columnId});

  final String boardId;
  final String columnId;
}
