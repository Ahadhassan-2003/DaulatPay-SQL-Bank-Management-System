import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:daulatpay/Navigation.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:daulatpay/Screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:daulatpay/Constants.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class Transaction extends StatefulWidget {
  Transaction({super.key,
  required this.userAccount,
    required this.name,
    required this.cash,
    required this.transactions
  });
  String userAccount;
  var name;
  var transactions;
  var cash;

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  bool isSending=false;
  var accountno=new TextEditingController();
  var amount=new TextEditingController();
  var obj=Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), onPressed: () { Navigator.push(context,MaterialPageRoute(builder: (context)=>Navigation(AccountNo: widget.userAccount, name: widget.name, cash: widget.cash, transactions: widget.transactions))); },

        ),
      ),
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
               child: isSending?LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 20):Text("Send",style: TextStyle(color: Colors.white),),
               onPressed: ()
               async {
                 setState(() {
                   isSending=true;
                 });
                 if(await makeTransaction(accountno.text, amount.text))
                   {
                      CherryToast.success(title: Text("Sent Successfully"),
                      toastPosition: Position.top,
                        
                      ).show(context);
                     setState(() {
                       isSending=false;
                     });
                   }
                 else
                   {
                     CherryToast.error(title: Text("There's an issue. Please try again later")).show(context);
                     setState(() {
                       isSending=false;
                     });
                   }
               },
             ),
           ),
         )
        ],
      ),
    );
  }

  Future<bool> makeTransaction(String recieveraccount,String amount)
  async
  {
    String url="${obj.ipaddress}/money_transfer?saccount=${widget.userAccount}&raccount=${recieveraccount}&amount=$amount";
    obj.setheader();
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    return decodedObjects["success"];

  }
}
