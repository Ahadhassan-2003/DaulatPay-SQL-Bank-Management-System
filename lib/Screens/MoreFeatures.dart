import 'package:daulatpay/Screens/Bill%20Payments.dart';
import 'package:daulatpay/Screens/BuyTickets.dart';
import 'package:flutter/material.dart';
class MoreFeatures extends StatefulWidget {
  MoreFeatures({super.key,
  required this.AccountNo});
  String AccountNo;

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
                  ReturnedContainer("Semester Fee","lib/assets/uni.png"),
                  ReturnedContainer("Mess Bill","lib/assets/nust.png"),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReturnedContainer("Sports Complex Fee","lib/assets/gym.png"),
                  ReturnedContainer("Saddle Club Fee","lib/assets/saddle.png"),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReturnedContainer("Hostel Fee","lib/assets/hostel.png"),
                  ReturnedContainer("Buy Tickets","lib/assets/ticket.png"),
                ],
              ),

            ]          ),
        ),
      ),
    );
  }
  Widget ReturnedContainer(String label,String image)
  {
    return GestureDetector(
      onTap: () {
        if (label != "Buy Tickets")
      {
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Bill_Payments(labelname: label,Accountno:widget.AccountNo,image: image,)));
      } else
          {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>BuyTickets(AccountNo: widget.AccountNo,)));
          }
       },
      child: Container(
        height: 140,
        width: 120,
        decoration: BoxDecoration(
          color: Color.fromARGB(255,120, 245, 200),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Container(child: Image.asset(image,height: 50,width: 40,),),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Text(label,textAlign: TextAlign.center,),
            ),
          ],
        ),
      ),
    );
  }
}
