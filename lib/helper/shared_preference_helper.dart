import 'package:mafatlal_ecommerce/features/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  //singletonInstance
  SharedPreferencesHelper._();
  static final SharedPreferencesHelper _instance = SharedPreferencesHelper._();
  static SharedPreferencesHelper get instance => _instance;

  late SharedPreferences _prefs;

  SharedPreferences get prefs => _prefs;

  // call on app initialization
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> clearPrefs() async {
    await _prefs.clear();
  }

  Future<bool> setAccessToken(String accessToken) async {
    return await _prefs.setString(accessTokenKey, accessToken);
  }

  String? getAccessToken() {
    return _prefs.getString(accessTokenKey);
  }

  Future<bool> setRefreshToken(String refreshToken) async {
    return await _prefs.setString(refreshTokenKey, refreshToken);
  }

  String? getRefreshToken() {
    return _prefs.getString(refreshTokenKey);
  }

  Future<bool> setCurrentUser(User userData) async {
    return await _prefs.setString(currentUser, userData.getUserDataString);
  }

  User? getCurrentUser() {
    final userData = _prefs.getString(currentUser);
    if (userData == null) {
      return null;
    }
    return User.fromJsonString(userData);
  }

  static const String accessTokenKey = "accesstoken";
  static const String refreshTokenKey = "refreshtoken";
  static const String currentUser = "CurrentUser";
}
