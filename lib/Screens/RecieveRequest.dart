import 'package:flutter/material.dart';

class RecieveRequest extends StatefulWidget {
  const RecieveRequest({super.key});

  @override
  State<RecieveRequest> createState() => _RecieveRequestState();
}

class _RecieveRequestState extends State<RecieveRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35.0,right: 35,top: 15),
            child: TextFormField(
              decoration: InputDecoration(
                  hintText: 'Sender Bank Account',
                  border: OutlineInputBorder()
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 35.0,right: 35,top: 15),
            child: TextFormField(
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
                child: Text("Request",style: TextStyle(color: Colors.white),),
                onPressed: (){},
              ),
            ),
          )
        ],
      ),
    );
  }
}
