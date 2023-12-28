import 'package:daulatpay/Screens/Login.dart';
import 'package:daulatpay/Screens/RecieveRequest.dart';
import 'package:daulatpay/Screens/Transaction.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                      child: const Column(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Ammar"),
                          Text("123451234511"),
                          Text("1000",style: TextStyle(fontSize: 30),),
                          Padding(
                            padding: EdgeInsets.only(right:10.0,bottom: 10),
                            child: Row(mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.arrow_forward_outlined),
                              ],
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
                child: ListView(
                  children: [
                    ListTile(title: Text("500"),),
                    ListTile(title: Text("500"),),
                    ListTile(title: Text("1000"),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
