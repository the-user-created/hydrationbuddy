import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HydrationProvider with ChangeNotifier {
  int _dailyGoal = 2000;
  int _totalConsumed = 0;
  DateTime _lastResetDate = DateTime.now();

  int get dailyGoal => _dailyGoal;
  int get totalConsumed => _totalConsumed;

  double get progress => _totalConsumed / _dailyGoal;

  HydrationProvider() {
    _loadPreferences();
    _checkForReset();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _totalConsumed = prefs.getInt('totalConsumed') ?? 0;
    _lastResetDate = DateTime.parse(prefs.getString('lastResetDate') ?? DateTime.now().toString());
    _checkForReset();
    notifyListeners();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyGoal', _dailyGoal);
    prefs.setInt('totalConsumed', _totalConsumed);
    prefs.setString('lastResetDate', _lastResetDate.toString());
  }

  void addWater(int amount) {
    _totalConsumed += amount;
    _savePreferences();
    notifyListeners();
  }

  void setGoal(int goal) {
    _dailyGoal = goal;
    _savePreferences();
    notifyListeners();
  }

  void resetWaterConsumption() {
    _totalConsumed = 0;
    _savePreferences();
    notifyListeners();
  }

  void _checkForReset() {
    DateTime now = DateTime.now();
    if (_lastResetDate.day != now.day || _lastResetDate.month != now.month || _lastResetDate.year != now.year) {
      _resetDailyConsumption();
    }
  }

  void _resetDailyConsumption() {
    _totalConsumed = 0;
    _lastResetDate = DateTime.now();
    _savePreferences();
    notifyListeners();
  }
}
