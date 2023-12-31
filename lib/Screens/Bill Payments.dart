import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
class Bill_Payments extends StatefulWidget {
  Bill_Payments({super.key,
  required this.labelname,
    required this.image,
  required this.Accountno});
  var labelname;
  var Accountno;
  var image;
  @override
  State<Bill_Payments> createState() => _Bill_PaymentsState();
}

class _Bill_PaymentsState extends State<Bill_Payments> {
  var obj=new Constants();
  var id;
  var amount;
  var status;
  var type;
  var date;
  bool issearching=false;
  @override
  var invoiceno=new TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Image.asset(widget.image,width: 100,height: 100,),
          Text(widget.labelname,style: GoogleFonts.montserrat(fontSize: 20,fontWeight: FontWeight.bold),),
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
            padding: const EdgeInsets.only(left:35.0,right:35.0,top:15),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child:TextButton(
                child: issearching?LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 40):Text("Get Details",style: TextStyle(color: Colors.white),),
                onPressed: () async {
                  setState(() {
                    issearching=true;
                  });
                  var success=await billInfo(invoiceno.text);
                  if(success)
                    {
                      setState(() {
                        issearching=false;

                      });
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>InvoicePay(amount: amount, status: status, type: type, date: date, AccountNo: widget.Accountno, invoice: id,),));
                    }
                  else
                    {
                      setState(() {
                        issearching=false;
                      });
                      CherryToast.error(title: Text("Bill does not Exist")).show(context);
                    }
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

  Future<bool> billInfo(String BillID)
  async
  {
    String url="${obj.ipaddress}/get_bill_info?bill_id=$BillID&bill_type=${widget.labelname}";
    obj.setheader();
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects);
    if(decodedObjects["success"]){
    setState(() {
      amount=decodedObjects["amount"];
      status=decodedObjects["bill_status"];
      type=decodedObjects["bill_type"];
      date=decodedObjects["due_date"];
      id=decodedObjects["bill_id"];
      print(decodedObjects["amount"]);
      print(amount);
    });}
    return decodedObjects["success"];
  }
}

class InvoicePay extends StatefulWidget {
  InvoicePay({super.key,
  required this.amount,
    required this.status,
    required this.type,
    required this.date,
    required this.invoice,
    required this.AccountNo,
  });
  var amount;
  var status;
  var type;
  var date;
  var AccountNo;
  var invoice;
  @override
  State<InvoicePay> createState() => _InvoicePayState();
}

class _InvoicePayState extends State<InvoicePay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(top: MediaQuery
              .of(context)
              .size
              .height * 0.1),
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset("lib/assets/nust.png", height: 150, width: 150,),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Amount:",style: GoogleFonts.montserrat(fontSize: 20),),
                  Text("${widget.amount}",style: GoogleFonts.montserrat(fontSize: 20),),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Bill Status:",style: GoogleFonts.montserrat(fontSize: 20),),
                  Text("${widget.status}",style: GoogleFonts.montserrat(fontSize: 20),),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Bill Type:",style: GoogleFonts.montserrat(fontSize: 20),),
                  Text("${widget.type}",style: GoogleFonts.montserrat(fontSize: 20),),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Due Date:",style: GoogleFonts.montserrat(fontSize: 20),),
                  Text("${widget.date}",style: GoogleFonts.montserrat(fontSize: 20),),
                ],
              ),
              widget.status!="Paid"?TextButton(onPressed: () async {

                if(await paybill(widget.invoice.toString()))
                  {
                    CherryToast.success(title: Text("Bill Paid Successfully")).show(context);
                    setState(() {
                      widget.status="Paid";
                    });
                  }


                }, child: Text("Pay Now",style: GoogleFonts.montserrat(fontSize: 20),)):Row()
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> paybill(String InvoiceId)
  async { Constants obj=new Constants();
  obj.setheader();
  String url="${obj.ipaddress}/bill_payment?account_no=${widget.AccountNo}&bill_id=$InvoiceId";
  print(url);
  obj.setheader();
  var data = await getData(url,obj.headers);
  var decodedObjects = jsonDecode(data);
  return decodedObjects["success"];
  }
}
