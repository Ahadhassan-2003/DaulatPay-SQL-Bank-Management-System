import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class BuyTickets extends StatefulWidget {
  BuyTickets({Key? key
  ,
  required this.AccountNo}) : super(key: key);
  String AccountNo;
  @override
  State<BuyTickets> createState() => _BuyTicketsState();
}

class _BuyTicketsState extends State<BuyTickets> {
  List<String> descriptions = [];
  List<dynamic> tickets=[];
  var date;
  bool buypressed=false;
  var price;
  var count;
  var id;
  var dest;
  var type;
  var ticketsbought=new TextEditingController();
  @override
  void initState() {
    super.initState();
    getTicketDetails();
  }

  var selectedDescription;
  bool GotDetails=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset("lib/assets/ticket.png",height: 100,width: 100,),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Choose Ticket from the menu",style: GoogleFonts.montserrat(fontSize: 20),),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: DropdownButton(
                value: selectedDescription,
                  items:descriptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                    );
                    }).toList(), onChanged: (value){
                setState(() {
                      selectedDescription=value;
                    });

                showDetails(selectedDescription);
              }),
            ),
            GotDetails?Text("Event Type: $selectedDescription\nEvent Date: $date\nLocation: $dest\nTickets Available: $count\nPrice: $price"):Row(),
          GotDetails?Padding(
            padding: const EdgeInsets.only(top: 10.0,bottom: 10,right: 35,left: 35),
            child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
              child: TextButton(onPressed: (){
                setState(() {
                  buypressed=true;
                });
              }, child: Text("Buy Tickets",style: GoogleFonts.montserrat(color: Colors.white),)),
            ),
          ):Row(),
            buypressed?Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: TextFormField(
                      controller: ticketsbought,
                      decoration: InputDecoration(
                        hintText: "Enter Ticket Quantity",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 10,right: 35,left: 35),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(onPressed: () async {
                        if(await buyTic(ticketsbought.text))
                        {
                          CherryToast.success(title: Text("Ticket Bought Successfully")).show(context);
                        }
                      }, child: Text("Buy Now",style: GoogleFonts.montserrat(color: Colors.white),)),
                    ),
                  )
                ],
              ),
            ):Row(),
          ],
        ),
      ),
    );
  }
  Future<bool> buyTic(String amount)
  async { Constants obj=new Constants();
  obj.setheader();
  String url="${obj.ipaddress}/buy_tickets?account_no=${widget.AccountNo}&ticket_id=$id&tickets_bought=$amount&ticket_price=$price";
  obj.setheader();
  var data = await getData(url,obj.headers);
  var decodedObjects = jsonDecode(data);
  print(decodedObjects);
  print(decodedObjects["success"]);
  return decodedObjects["success"];
  }

  Future<void> getTicketDetails() async {
    Constants obj = new Constants();
    obj.setheader();
    String url = "${obj.ipaddress}/ticket_info";
    obj.setheader();
    var data = await getData(url, obj.headers);
    Map<String, dynamic> jsonDataMap = jsonDecode(data);
    tickets = jsonDataMap['tickets'];
    print(tickets);
    List<String> desc =
    tickets.map((ticket) => ticket['Description'] as String).toList();
    setState(() {
      descriptions = desc.whereType<String>().toList();
    });
    print(descriptions);
  }

  void showDetails(String label)
  {
    var details = tickets.where((element) => element['Description']==label);
    List det=details.toList();
    setState(() {
      dest=det[0]['Destination'];
      date=det[0]['EventDate'];
      price=det[0]['TicketPrice'];
      count=det[0]['TicketCount'];
      id=det[0]['TicketID'];
      GotDetails=true;
    });
    }

}
