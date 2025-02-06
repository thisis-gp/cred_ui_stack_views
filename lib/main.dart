import 'dart:convert';

import 'package:cred_assignment/StackFramework/stack_framework.dart';
import 'package:cred_assignment/views/view1.dart';
import 'package:cred_assignment/views/view2.dart';
import 'package:cred_assignment/views/view3.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color.fromARGB(255, 23, 23, 47),
      ),
      debugShowCheckedModeBanner: true,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _currentAmount = 150000;
  double _selectedEmiAmount = 0; // Initialize with a default value
  int _selectedEmiDuration = 0; // Initialize with a default value
  List<dynamic> _apiData = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.mocklets.com/p6764/test_mint'),
      );

      if (response.statusCode == 200) {
        _apiData = jsonDecode(response.body)['items'];
        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Failed to load data. Status Code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
      );
    }
    return Scaffold(
      body: CustomStackWidget(
        views: [
          View1(
            apiData: _apiData[0],
            onAmountChanged: (amount) {
              setState(() {
                _currentAmount =
                    amount; // Update the amount when it changes in View1
              });
            },
          ),
          View2(
            apiData: _apiData[1],
            creditAmount: _currentAmount,
            onEmiSelected: (amount, duration) {
              // Callback from View2
              setState(() {
                _selectedEmiAmount = amount;
                _selectedEmiDuration = duration;
              });
            },
          ), // Pass _currentAmount to View2
          View3(
            apiData: _apiData[2],
            creditAmount: _currentAmount,
            emiAmount: _selectedEmiAmount,
            emiDuration: _selectedEmiDuration,
          ),
        ],
        ctas: _apiData.map((item) => item['cta_text'] as String).toList(),
        cycle: false,
      ),
    );
  }
}
