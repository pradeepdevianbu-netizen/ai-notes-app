import 'package:first_app/screens/connection/widgets/pending_requests_section.dart';
import 'package:flutter/material.dart';
import 'package:first_app/screens/home/widgets/custom_app_bar.dart';


class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0F172A),

      appBar: CustomAppBar(
        title: "Connections",
        subtitle: "Connect • Grow • Network",
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Pending Requests",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            PendingRequestsSection(),

            SizedBox(height: 30),

            Text(
              "My Connections",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            // Next Part

            SizedBox(height: 30),

            Text(
              "Suggested Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            // Next Part

            SizedBox(height: 30),

            Text(
              "Trending Students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 15),

            // Next Part
          ],
        ),
      ),
    );
  }
}