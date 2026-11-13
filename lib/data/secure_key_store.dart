import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stores the user's LLM API key in the Android Keystore-backed storage.
class SecureKeyStore {
  SecureKeyStore([FlutterSecureStorage? storage])
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _apiKey = 'llm_api_key';

  Future<String?> read() => _storage.read(key: _apiKey);
  Future<void> write(String key) => _storage.write(key: _apiKey, value: key);
  Future<void> clear() => _storage.delete(key: _apiKey);
}
