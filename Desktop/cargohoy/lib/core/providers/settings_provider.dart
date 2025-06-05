import 'package:flutter/material.dart';
import 'package:shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  static const String _notificationsKey = 'notifications_enabled';
  late SharedPreferences _prefs;
  bool _notificationsEnabled = true;
  String _language = 'es';
  bool _locationEnabled = true;
  String _userName = '';
  String _userEmail = '';
  String? _userPhotoUrl;

  bool get notificationsEnabled => _notificationsEnabled;
  String get language => _language;
  bool get locationEnabled => _locationEnabled;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String? get userPhotoUrl => _userPhotoUrl;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = _prefs.getBool(_notificationsKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleNotifications() async {
    _notificationsEnabled = !_notificationsEnabled;
    await _prefs.setBool(_notificationsKey, _notificationsEnabled);
    notifyListeners();
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? photoUrl,
  }) async {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    if (photoUrl != null) _userPhotoUrl = photoUrl;
    notifyListeners();
  }

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void toggleLocation() {
    _locationEnabled = !_locationEnabled;
    notifyListeners();
  }
} 