import 'dart:convert';

import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';

class Bill_Payments extends StatefulWidget {
  Bill_Payments({super.key,
  required this.labelname});
  String labelname;
  @override
  State<Bill_Payments> createState() => _Bill_PaymentsState();
}

class _Bill_PaymentsState extends State<Bill_Payments> {
  var obj=new Constants();
  @override
  var invoiceno=new TextEditingController();
  var amount=new TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(widget.labelname),
          Padding(
            padding: const EdgeInsets.only(left: 35.0,right: 35,top: 15),
            child: TextFormField(
              controller: invoiceno,
              decoration: InputDecoration(
                  hintText: widget.labelname=="Mobile Load"?"Mobile No":'Invoice No',
                  border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35.0,right: 35,top: 15),
            child: TextFormField(
              controller: amount,
              decoration: InputDecoration(
                  hintText: 'Enter Amount',
                  border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text("Enter Amount between 50 and 50,000"),
          ),
          Padding(
            padding: const EdgeInsets.only(left:35.0,right:35.0,top:15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child:TextButton(
                child: Text("Send",style: TextStyle(color: Colors.white),),
                onPressed: (){
                  PayBills();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
void PayBills()
async
  {
    String url="${obj.ipaddress}/bill_payment?amount=${amount.text}&billtype=${widget.labelname}";
    obj.setheader();
    var data = await getData(url,obj.headers);
    print("4");
    var decodedObjects = jsonDecode(data);
    return decodedObjects["success"];

  }
}
