
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coffee_shop_app/src/core/constants.dart';

abstract class OnboardingLocalDataSource {
  Future<bool> getHasSeenWelcomeScreen();
  Future<void> setHasSeenWelcomeScreen(bool value);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  final SharedPreferences _prefs;
  OnboardingLocalDataSourceImpl(this._prefs);

  @override
  Future<bool> getHasSeenWelcomeScreen() async {
    return _prefs.getBool(kHasSeenWelcomeScreenKey) ?? false;
  }

  @override
  Future<void> setHasSeenWelcomeScreen(bool value) async {
    await _prefs.setBool(kHasSeenWelcomeScreenKey, value);
  }
}