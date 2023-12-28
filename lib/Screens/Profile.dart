import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Ammar Bin Akram",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10)
                ),
                child:Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Account Statement"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Change MPIN"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Help"),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Privacjy Policy"),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text("Logout"),
                ),),
            )
          ],
        ),
      ),
    );
  }
}
