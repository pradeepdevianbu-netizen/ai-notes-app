import 'package:first_app/screens/home/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
  title: "Connections",
  subtitle: "128 Friends",
  actions: [
    IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
    ),
    ]),
      body: const Center(
        child: Text(
          "Connections",
          style: TextStyle(fontSize: 22),
        ),
      ),
      );
    
  }
}