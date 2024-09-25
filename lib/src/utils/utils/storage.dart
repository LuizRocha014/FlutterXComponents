import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

late final FlutterSecureStorage secureStorage;
late final SharedPreferences sharedPreferences;

Future<void> initStorage() async {
  secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  sharedPreferences = await SharedPreferences.getInstance();
}

extension SecureStorageExtension on FlutterSecureStorage {
  Future<String?> readSecureStorage(String key) async {
    try {
      return await read(key: key);
    } catch (_) {
      return null;
    }
  }

  Future<void> writeSecureStorage(String key, String? value) async {
    await write(key: key, value: value);
  }

  Future<bool> containsKeySecureStorage(String key) async {
    return containsKey(key: key);
  }
}
