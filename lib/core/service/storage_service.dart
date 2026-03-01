import 'package:drugvet_master/core/value/constant.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  late final SharedPreferences _prefs;
  late final FlutterSecureStorage _secureStorage;

  String? _cachedToken;

  Future<StorageService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    _cachedToken = await _secureStorage.read(
      key: AppConstants.STORAGE_USER_TOKEN_KEY,
    );
    return this;
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<void> setSecureToken(String token) async {
    await _secureStorage.write(
      key: AppConstants.STORAGE_USER_TOKEN_KEY,
      value: token,
    );
    _cachedToken = token;
  }

  bool getDeviceFirstOpen() {
    return _prefs.getBool(AppConstants.STORAGE_DEVICE_OPEN_FIRST_TIME) ?? false;
  }

  bool getIsLoggedIn() {
    return _cachedToken != null && _cachedToken!.isNotEmpty;
  }

  Future<bool> remove(String key) async {
    return await _prefs.remove(key);
  }

  String getUserToken() {
    return _cachedToken ?? "";
  }

  Future<String> getUserTokenAsync() async {
    _cachedToken = await _secureStorage.read(
      key: AppConstants.STORAGE_USER_TOKEN_KEY,
    );
    return _cachedToken ?? "";
  }

  String getUserName() {
    return _prefs.getString(AppConstants.STORAGE_USER_NAME) ?? "مرحباً بك";
  }

  Future<void> setUserId(int id) async {
    await _prefs.setString(AppConstants.STORAGE_USER_ID, id.toString());
  }

  String getUserId() {
    return _prefs.getString(AppConstants.STORAGE_USER_ID) ?? "";
  }

  Future<void> logout() async {
    await _secureStorage.delete(key: AppConstants.STORAGE_USER_TOKEN_KEY);
    _cachedToken = null;
    await _prefs.remove(AppConstants.STORAGE_USER_NAME);
    await _prefs.remove(AppConstants.STORAGE_USER_ID);
    await _prefs.remove(AppConstants.STORAGE_IS_GUEST);
  }

  Future<void> setGuestLogin() async {
    await _prefs.setBool(AppConstants.STORAGE_IS_GUEST, true);
  }

  bool isGuest() {
    return _prefs.getBool(AppConstants.STORAGE_IS_GUEST) ?? false;
  }
}
