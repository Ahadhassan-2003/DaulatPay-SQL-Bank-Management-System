import 'dart:convert';

import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:daulatpay/Constants.dart';
class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  var accountno=new TextEditingController();
  var amount=new TextEditingController();
  var obj=Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
         Padding(
           padding: const EdgeInsets.only(left: 35.0,right: 35,top: 15),
           child: TextFormField(
             controller: accountno,
            decoration: InputDecoration(
              hintText: 'Reciever Bank Account',
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
                 makeTransaction(accountno.text, amount.text as int);
               },
             ),
           ),
         )
        ],
      ),
    );
  }

  void makeTransaction(String recieveraccount,int amount)
  async
  {
    String url="${obj.ipaddress}/transaction?reciever=$recieveraccount&amount=$amount";
    obj.setheader();
    var data = await getData(url,obj.headers);
    print("4");
    var decodedObjects = jsonDecode(data);
    return decodedObjects["success"];

  }
}
