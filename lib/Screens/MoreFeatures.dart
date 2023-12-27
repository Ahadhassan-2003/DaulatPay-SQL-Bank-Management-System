import 'package:flutter/material.dart';
class MoreFeatures extends StatefulWidget {
  const MoreFeatures({super.key});

  @override
  State<MoreFeatures> createState() => _MoreFeaturesState();
}

class _MoreFeaturesState extends State<MoreFeatures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Container(
              child: (Text("Buy Tickets")),
            ),
            Container(
              child: Text("Mess Bill"),
            ),
            Container(
              child: Text("Sports Complex Fee"),
            ),
            Container(
              child: Text("Semester Fee"),
            )
          ],
        ),
      ),
    );
  }
}
