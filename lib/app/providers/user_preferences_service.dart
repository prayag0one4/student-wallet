import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../models/home_module.dart';

class UserPreferencesService extends ChangeNotifier {
  final SharedPreferences _prefs;
  HomeModule _homeModule = HomeModule.expenses;

  UserPreferencesService(this._prefs) {
    _load();
  }

  HomeModule get homeModule => _homeModule;

  void _load() {
    final saved = _prefs.getString(AppConstants.homeModuleKey);
    if (saved != null) {
      _homeModule = HomeModule.values.firstWhere(
        (e) => e.name == saved,
        orElse: () => HomeModule.expenses,
      );
    }
    notifyListeners();
  }

  Future<void> setHomeModule(HomeModule module) async {
    if (_homeModule == module) return;
    _homeModule = module;
    await _prefs.setString(AppConstants.homeModuleKey, module.name);
    notifyListeners();
  }
}
