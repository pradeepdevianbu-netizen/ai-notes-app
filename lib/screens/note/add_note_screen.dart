import 'package:flutter/material.dart';

class Addnotepage extends StatefulWidget {
  const Addnotepage({super.key});

  @override
  State<Addnotepage> createState() => _AddnotepageState();
}

class _AddnotepageState extends State<Addnotepage> {
  final TextEditingController notecontroller = TextEditingController();

  @override
  void dispose() {
    notecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text("ADD NOTE"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]),
              child: TextField(
                controller: notecontroller,
                keyboardType: TextInputType.multiline,
                
                maxLines: 15,
                minLines: 15,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "enter your note",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ),
        
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(247, 114, 202, 249),
          onPressed: () {
            if (notecontroller.text.trim().isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("please enter the note")),
              );
              return;
            }
            Navigator.pop(context, notecontroller.text.trim());
          },
          child: const Icon(Icons.save),
        ));
  }
}
