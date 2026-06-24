import 'package:flutter/material.dart';
import '_add_note_.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("H O M E")
      ),
      body: const Center(
        child: Text("TO CREATE THE NOTE"),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const  Addnotepage(),
              ),
            );
          },
          child: const Icon(Icons.add)),
    );
  
  }
}
