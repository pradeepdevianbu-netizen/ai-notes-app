import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Viewnotepage extends StatelessWidget {
  final String note;
  const Viewnotepage({
    super.key,
    required this.note,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor:  const Color.fromARGB(255, 48, 55, 60),
          title: const Text(
            "v i e w  p a g e",
            style: TextStyle(color: Color.fromARGB(248, 255, 255, 255)),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(note),
      ),
    );
  }
}
