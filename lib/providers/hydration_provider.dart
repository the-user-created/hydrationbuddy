import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HydrationProvider with ChangeNotifier {
  int _dailyGoal = 2000;
  int _totalConsumed = 0;

  int get dailyGoal => _dailyGoal;
  int get totalConsumed => _totalConsumed;

  double get progress => _totalConsumed / _dailyGoal;

  HydrationProvider() {
    _loadPreferences();
  }

  void _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _dailyGoal = prefs.getInt('dailyGoal') ?? 2000;
    _totalConsumed = prefs.getInt('totalConsumed') ?? 0;
    notifyListeners();
  }

  void _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('dailyGoal', _dailyGoal);
    prefs.setInt('totalConsumed', _totalConsumed);
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
}
