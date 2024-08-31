import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HydrationProvider with ChangeNotifier {
  int _dailyGoal = 2000;  // Default goal is 2000 ml
  int _totalConsumed = 0;
  DateTime lastResetDate = DateTime.now();
  bool _mustCongratulate = false;

  int get dailyGoal => _dailyGoal;
  int get totalConsumed => _totalConsumed;
  double get progress => (_totalConsumed / _dailyGoal).clamp(0.0, 1.0);
  bool get shouldCongratulate => (_totalConsumed >= _dailyGoal) && _mustCongratulate;

  HydrationProvider() {
    _loadPreferences();
    checkForReset();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _totalConsumed = prefs.getInt('totalConsumed') ?? 0;
    lastResetDate = DateTime.parse(prefs.getString('lastResetDate') ?? DateTime.now().toString());
    _mustCongratulate = prefs.getBool('mustCongratulate') ?? false;
    checkForReset();
    notifyListeners();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyGoal', _dailyGoal);
    prefs.setInt('totalConsumed', _totalConsumed);
    prefs.setString('lastResetDate', lastResetDate.toString());
    prefs.setBool('mustCongratulate', _mustCongratulate);
  }

  void addWater(int amount) {
    _totalConsumed += amount;
    if (_totalConsumed >= _dailyGoal) {
      _mustCongratulate = true;
    }
    _savePreferences();
    notifyListeners();
  }

  void setGoal(int goal) {
    _dailyGoal = goal;
    _mustCongratulate = (_totalConsumed >= _dailyGoal);
    _savePreferences();
    notifyListeners();
  }

  void userResetWaterConsumption() {
    _totalConsumed = 0;
    _mustCongratulate = false;
    _savePreferences();
    notifyListeners();
  }

  void checkForReset() {
    DateTime now = DateTime.now();
    if (lastResetDate.day != now.day) {
      resetDailyConsumption();
    }
  }

  void resetDailyConsumption() {
    _totalConsumed = 0;
    lastResetDate = DateTime.now();
    _mustCongratulate = false;
    _savePreferences();
    notifyListeners();
  }
}
