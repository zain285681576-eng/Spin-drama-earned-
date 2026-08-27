import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin Drama Earned',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int coins = 0;
  StreamController<int> controller = StreamController<int>();
  List<int> rewards = [10, 20, 50, 100, 5, 25]; // wheel pe ye coins milege

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  _loadCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins')?? 0;
    });
  }

  _saveCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('coins', coins);
  }

  _spinWheel() {
    int randomIndex = Random().nextInt(rewards.length);
    controller.add(randomIndex); // wheel ghumao
    
    // 4 sec baad coins add karo
    Future.delayed(const Duration(seconds: 4), () {
      setState(() {
        coins += rewards[randomIndex];
      });
      _saveCoins();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Spin Drama Earned')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Your Coins: $coins', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: FortuneWheel(
              selected: controller.stream,
              items: [
                for (var reward in rewards) FortuneItem(child: Text('$reward')),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)
            ),
            onPressed: _spinWheel,
            child: const Text('SPIN NOW', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
