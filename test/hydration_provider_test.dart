import 'package:flutter_test/flutter_test.dart';
import 'package:hydrationbuddy/providers/hydration_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Clear shared preferences before each test to avoid test interference
    SharedPreferences.setMockInitialValues({});
  });

  group('HydrationProvider', () {
    test('initial values are correct', () {
      final provider = HydrationProvider();

      expect(provider.dailyGoal, 2000);
      expect(provider.totalConsumed, 0);
      expect(provider.progress, 0.0);
      expect(provider.shouldCongratulate, false);
    });

    test('setGoal updates dailyGoal and mustCongratulate', () async {
      final provider = HydrationProvider();
      provider.setGoal(1500);

      expect(provider.dailyGoal, 1500);
      expect(provider.shouldCongratulate, false);

      provider.addWater(1500);

      expect(provider.shouldCongratulate, true);
    });

    test('addWater increases totalConsumed and progress', () async {
      final hydrationProvider = HydrationProvider();
      hydrationProvider.addWater(500);

      expect(hydrationProvider.totalConsumed, 500);
      expect(hydrationProvider.progress, 0.25);
      expect(hydrationProvider.shouldCongratulate, false);
    });

    test('addWater increases totalConsumed and sets mustCongratulate if goal reached', () async {
      final provider = HydrationProvider();
      provider.addWater(2000);

      expect(provider.totalConsumed, 2000);
      expect(provider.shouldCongratulate, true);
    });

    test('userResetWaterConsumption resets totalConsumed and progress', () async {
      final hydrationProvider = HydrationProvider();
      hydrationProvider.addWater(500);
      hydrationProvider.userResetWaterConsumption();

      expect(hydrationProvider.totalConsumed, 0);
      expect(hydrationProvider.progress, 0.0);
      expect(hydrationProvider.shouldCongratulate, false);
    });

    test('userResetWaterConsumption resets totalConsumed and mustCongratulate', () async {
      final provider = HydrationProvider();
      provider.addWater(2000);
      provider.userResetWaterConsumption();

      expect(provider.totalConsumed, 0);
      expect(provider.shouldCongratulate, false);
    });

    test('daily consumption resets at midnight', () async {
      final provider = HydrationProvider();
      provider.addWater(2000);
      provider.lastResetDate = DateTime.now().subtract(const Duration(days: 1));
      provider.checkForReset();

      expect(provider.totalConsumed, 0);
      expect(provider.shouldCongratulate, false);
    });

    test('loadPreferences loads saved values', () async {
      SharedPreferences.setMockInitialValues({
        'dailyGoal': 2500,
        'totalConsumed': 1000,
        'lastResetDate': DateTime.now().subtract(const Duration(minutes: 1)).toString(),
        'mustCongratulate': true,
      });

      final provider = HydrationProvider();
      await Future.delayed(const Duration(milliseconds: 50)); // Small delay to allow preferences to load

      expect(provider.dailyGoal, 2500);
      expect(provider.totalConsumed, 1000);
      expect(provider.shouldCongratulate, false); // should reset due to date change
    });

    test('savePreferences saves current values', () async {
      final provider = HydrationProvider();
      provider.setGoal(3000);
      provider.addWater(1500);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('dailyGoal'), 3000);
      expect(prefs.getInt('totalConsumed'), 1500);
      expect(prefs.getBool('mustCongratulate'), false);
    });

    test('resetDailyConsumption resets values and saves preferences', () async {
      final provider = HydrationProvider();
      provider.addWater(2000);
      provider.resetDailyConsumption();

      expect(provider.totalConsumed, 0);
      expect(provider.shouldCongratulate, false);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('totalConsumed'), 0);
      expect(prefs.getBool('mustCongratulate'), false);
    });
  });
}