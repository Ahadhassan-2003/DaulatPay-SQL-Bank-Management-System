import 'package:daulatpay/Screens/Login.dart';
import 'package:daulatpay/Screens/RecieveRequest.dart';
import 'package:daulatpay/Screens/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
class Dashboard extends StatefulWidget {
  Dashboard({
    super.key,
  required this.AccountNo,
  required this.name,
  required this.cash,
  required this.transactions
  });
  var AccountNo;
  var cash;
  var name;
  List? transactions;
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0,top: 10,bottom: 20,right: 15),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255,120, 245, 200)
                      ),
                      height: 310,
                      width: MediaQuery.of(context).size.width*0.55,
                      child:  Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text('${widget.name}',style: GoogleFonts.dosis(
                                fontWeight: FontWeight.bold,
                                fontSize: 25
                              ),),
                            ),
                          ),
                          //Text('${widget.AccountNo}',style: TextStyle(fontSize: 20)),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(right:10.0,bottom: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('${widget.cash}',style: GoogleFonts.mukta(fontSize: 30),),
                                    Icon(Icons.arrow_forward_outlined),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Transaction()));
                      },
                      child: Container(
                        height: 150,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255,255, 135, 150),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0,bottom: 16.0,right: 20,left: 20),
                              child: TextButton(
                                onPressed: (){},
                                child: Text("Send",style: TextStyle(color: Colors.white,fontSize: 15),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(child: Image.asset("lib/assets/transfer.png",height: 50,width: 50,color: Colors.white,),),
                            ),
                          ],
                        ),),
                    ),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: ()
                      {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>RecieveRequest()));
                      },
                      child: Container(
                        height: 150,
                        width: 130,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255,149, 189, 255),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,right: 20,left: 20),
                                child: TextButton(
                                  onPressed: (){},
                                  child: Text("Request",style: TextStyle(color: Colors.white,fontSize: 15),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(child: Image.asset("lib/assets/profit.png",height: 50,width: 50,color: Colors.white,),),
                            )
                          ],
                        ),),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Text("TRANSACTIONS",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),
              ],
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                    itemCount: widget.transactions?.length,
                    itemBuilder: (context,index)
                    {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10)
                          ),
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
                                  children:
                                  [
                                    Text("Amount: "),
                                    Text(widget.transactions?[index]["Amount"]),
                                  ],
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text("Date: "),
                                Text(widget.transactions?[index]["TransactionDate"]),
                              ],
                            ),

                          ),
                        ),
                      );
                    }
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
