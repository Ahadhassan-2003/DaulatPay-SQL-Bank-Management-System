import 'package:daulatpay/Screens/Bill%20Payments.dart';
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
        child: Padding(
          padding: const EdgeInsets.only(left: 20,right: 20),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReturnedContainer("Semester Fee"),
                  ReturnedContainer("Mess Bill"),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReturnedContainer("Sports Complex Fee"),
                  ReturnedContainer("Saddle Club Fee"),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReturnedContainer("Hostel Fee"),
                  ReturnedContainer("Bill Payment"),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReturnedContainer("Buy Tickets"),
                  ReturnedContainer("Mobile Load"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget ReturnedContainer(String label)
  {
    return GestureDetector(
      onTap: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Bill_Payments(labelname: label,)));
      },
      child: Container(
        height: 110,
        width: 90,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label,textAlign: TextAlign.center,),
        ),
      ),
    );
  }
}
