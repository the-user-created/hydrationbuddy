import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HydrationProvider with ChangeNotifier {
  int _dailyGoal = 2000;
  int _totalConsumed = 0;
  DateTime _lastResetDate = DateTime.now();
  bool _mustCongratulate = false;

  int get dailyGoal => _dailyGoal;
  int get totalConsumed => _totalConsumed;
  double get progress => (_totalConsumed / _dailyGoal).clamp(0.0, 1.0);
  bool get shouldCongratulate => (_totalConsumed >= _dailyGoal) && _mustCongratulate;

  HydrationProvider() {
    _loadPreferences();
    _checkForReset();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _totalConsumed = prefs.getInt('totalConsumed') ?? 0;
    _lastResetDate = DateTime.parse(prefs.getString('lastResetDate') ?? DateTime.now().toString());
    _mustCongratulate = prefs.getBool('mustCongratulate') ?? false;
    _checkForReset();
    notifyListeners();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyGoal', _dailyGoal);
    prefs.setInt('totalConsumed', _totalConsumed);
    prefs.setString('lastResetDate', _lastResetDate.toString());
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

  void _checkForReset() {
    DateTime now = DateTime.now();
    if (_lastResetDate.day != now.day) {
      _resetDailyConsumption();
    }
  }

  void _resetDailyConsumption() {
    _totalConsumed = 0;
    _lastResetDate = DateTime.now();
    _mustCongratulate = false;
    _savePreferences();
    notifyListeners();
  }
}
