import 'dart:convert';

import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:daulatpay/Screens/RecieveRequest.dart';
import 'package:daulatpay/Screens/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Dashboard extends StatefulWidget {
  Dashboard(
      {super.key,
      required this.AccountNo,
      required this.name,
      required this.cash,
      required this.transactions});
  var AccountNo;
  var cash;
  var name;
  List? transactions;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool gotdetails=false;
@override
  void initState() {
    // TODO: implement initState
  upDatedDeatils();
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: Container(),
      ),
      backgroundColor: Colors.white70,
      body: gotdetails?Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 10, bottom: 20, right: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 120, 245, 200)),
                    height: 310,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text('${widget.name}',style: GoogleFonts.dosis(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 25
                                      ),),
                                    )),
                                //Text('${widget.AccountNo}',style: TextStyle(fontSize: 20)),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10.0, bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${widget.cash}',style: GoogleFonts.mukta(fontSize: 30),),
                                        ],
                                      ),
                                    ),
                                  ),
                                )

                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0,right: 20,bottom: 10),
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Transaction(userAccount: widget.AccountNo,name: widget.name,transactions: widget.transactions,cash: widget.cash,)));
                                  },
                                  child: Container(
                                    height: 75,
                                    width: 120,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 135, 150),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 25.0, bottom: 25.0, right: 10, left: 10),
                                          child: Text(
                                            "Send",
                                            style: TextStyle(
                                                color: Colors.white, fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                        ],
                    ),
                  ),
                ),

              ],
            ),
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      height: 10,
                    ),

                  ],
                ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Text(
                    "TRANSACTIONS",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: widget.transactions?.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Container(child: (widget.AccountNo==widget.transactions?[index]["ReceiverAccountNumber"])?Image.asset("lib/assets/down-arrow.png",width: 40,height: 40,color: Colors.green,):Image.asset("lib/assets/upward-arrow.png",width: 40,height: 40,color: Colors.red,),),
                            title: Column(
                              children: [
                                Row(
                                  children:
                                  [
                                    (widget.AccountNo==widget.transactions?[index]["ReceiverAccountNumber"])?Text("From: "):Text("To: "),
                                    (widget.AccountNo==widget.transactions?[index]["ReceiverAccountNumber"])?Text(widget.transactions?[index]["SenderAccountNumber"]):Text(widget.transactions?[index]["ReceiverAccountNumber"]),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Amount: "),
                                    Text(widget.transactions?[index]["Amount"]),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text("Date: "),
                                Text(widget.transactions?[index]
                                    ["TransactionDate"]),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ):Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Color.fromARGB(255, 120, 245, 200), size: 50),),
    );
  }
  Future<void> upDatedDeatils() async {
    Constants obj=new Constants();
    obj.setheader();
    // Encode the username and password in the URL
    String url="${obj.ipaddress}/updated_details?AccountNumber=${widget.AccountNo}";
    print("3");
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects);
    setState(() {
      widget.cash=decodedObjects["CashAmount"];
      widget.transactions=decodedObjects["Transactions"];
      gotdetails=true;
    });
    return decodedObjects["success"];
  }

}
