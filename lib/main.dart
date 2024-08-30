import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hydrationbuddy/providers/hydration_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HydrationProvider(),
      child: MaterialApp(
        title: 'Hydration Buddy',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final hydrationProvider = Provider.of<HydrationProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Hydration Buddy'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Water Intake Goal: ${hydrationProvider.dailyGoal} ml'),
          LinearProgressIndicator(
            value: hydrationProvider.progress,
          ),
          SizedBox(height: 20),
          Text('Total Consumed: ${hydrationProvider.totalConsumed} ml'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => hydrationProvider.addWater(200),
                child: Text('200 ml'),
              ),
              ElevatedButton(
                onPressed: () => hydrationProvider.addWater(500),
                child: Text('500 ml'),
              ),
              ElevatedButton(
                onPressed: () => hydrationProvider.addWater(750),
                child: Text('750 ml'),
              ),
            ],
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _setGoal(context, hydrationProvider),
            child: Text('Set Goal'),
          ),
        ],
      ),
    );
  }

  void _setGoal(BuildContext context, HydrationProvider hydrationProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController goalController = TextEditingController();
        return AlertDialog(
          title: Text('Set Daily Goal'),
          content: TextField(
            controller: goalController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'Enter goal in ml'),
          ),
          actions: [
            TextButton(
              child: Text('Set'),
              onPressed: () {
                int goal = int.parse(goalController.text);
                hydrationProvider.setGoal(goal);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
