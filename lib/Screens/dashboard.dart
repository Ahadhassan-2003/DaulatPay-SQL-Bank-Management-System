import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.black45,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: GestureDetector(
                onTap: (){
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>Login()));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green
                  ),
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Text("Name"),
                      Text("Card No"),
                    ],
                  ),
                ),
              ),
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,right: 20,left: 20),
                    child: TextButton(
                    onPressed: (){},
                    child: Text("Send",style: TextStyle(color: Colors.white),),
                ),
                  ),),

                Container(
                  decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Padding(
                  padding: const EdgeInsets.only(top: 16.0,bottom: 16.0,right: 20,left: 20),
                  child: TextButton(
                    onPressed: (){},
                    child: Text("Request",style: TextStyle(color: Colors.white),),
                  ),
                ),)
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 36.0),
                  child: Text("Transactions"),
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
