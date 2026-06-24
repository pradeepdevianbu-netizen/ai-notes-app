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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: 20,
              ),
              child: TextField(
                controller: notecontroller,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "enter your note",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                      ),
                      contentPadding:const EdgeInsets.only(
                       top: 20,
                       left: 16,
                       right: 16,
                       bottom: 400, 
                      ),
                ),
              
              ),
            ),
           
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(247, 114, 202, 249),
          onPressed: () {
            print(notecontroller.text);
          },
          child: const Text("save")),
    );
  }
}
