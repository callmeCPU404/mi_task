import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
      appBar: AppBar(title: const Text("Task Manager")),
      body: const Center(
        child: Text(
          "Welcome to your Task Manager!",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}