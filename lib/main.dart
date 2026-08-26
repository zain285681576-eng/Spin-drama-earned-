
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spin Drama Earned',
      theme: ThemeData(primarySwatch: Colors.blue),
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

  @override
  void initState() {
    super.initState();
    _loadCoins();
  }

  _loadCoins() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      coins = prefs.getInt('coins') ?? 0;
    });
  }

  _
