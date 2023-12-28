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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: (Text("Buy Tickets")),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10)
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("Mess Bill"),
              ),
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
