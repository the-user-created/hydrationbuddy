import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hydrationbuddy/providers/hydration_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HydrationProvider(),
      child: MaterialApp(
        title: 'Hydration Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late TextEditingController goalController;

  @override
  void initState() {
    super.initState();
    goalController = TextEditingController();
  }

  @override
  void dispose() {
    goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hydrationProvider = Provider.of<HydrationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydration Buddy'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Water Intake Goal: ${hydrationProvider.dailyGoal} ml',
            style: const TextStyle(fontSize: 18),
          ),
          Container(
            height: 20,
            width: 300,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: hydrationProvider.progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                    hydrationProvider.progress >= 1.0 ? Colors.green : Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Total Consumed: ${hydrationProvider.totalConsumed} ml',
            style: const TextStyle(fontSize: 18),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _addWaterAndCheckGoal(hydrationProvider, 250),
                child: const Text('250 ml'),
              ),
              ElevatedButton(
                onPressed: () => _addWaterAndCheckGoal(hydrationProvider, 500),
                child: const Text('500 ml'),
              ),
              ElevatedButton(
                onPressed: () => _addWaterAndCheckGoal(hydrationProvider, 750),
                child: const Text('750 ml'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _setGoal(context, hydrationProvider),
            child: const Text('Set Goal'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _resetWaterConsumption(hydrationProvider),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _addWaterAndCheckGoal(HydrationProvider hydrationProvider, int amount) {
    hydrationProvider.addWater(amount);
    if (hydrationProvider.shouldCongratulate) {
      _showCongratulatoryDialog(context);
    }
  }

  void _showCongratulatoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have reached your daily water intake goal!'),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();  // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _setGoal(BuildContext context, HydrationProvider hydrationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Daily Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter goal in ml'),
          ),
          actions: [
            TextButton(
              child: const Text('Set'),
              onPressed: () {
                final goalText = goalController.text;
                if (goalText.isNotEmpty && int.tryParse(goalText) != null) {
                  int goal = int.parse(goalText);
                  if (goal > 0) {
                    hydrationProvider.setGoal(goal);
                    goalController.clear();
                    Navigator.of(context).pop();
                    if (hydrationProvider.shouldCongratulate) {
                      _showCongratulatoryDialog(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a positive number greater than 0'),
                    ));
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a valid number'),
                  ));
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _resetWaterConsumption(HydrationProvider hydrationProvider) {
    hydrationProvider.userResetWaterConsumption();
  }
}
