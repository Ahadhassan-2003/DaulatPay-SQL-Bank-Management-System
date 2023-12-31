import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var otpvalue;
  bool otpverified=false;
  var AccountNumber;
  bool otpsent=false;
  var otpentered= new TextEditingController();
  var email=new TextEditingController();
  var newpass=new TextEditingController();
  var conpass=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top:MediaQuery.of(context).size.height*0.1),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(35.0),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Registered Email Address"
                  ),
                ),
              ),
              TextButton(onPressed: (){
                sendOtp();
              }, child: Text("Send OTP")),
              otpsent?Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: TextFormField(
                        controller:otpentered,
                        decoration: InputDecoration(
                          labelText: 'Enter OTP',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ),
                    TextButton(onPressed: (){
                      if(otpvalue.toString() == otpentered.text)
                        {
                          setState(() {
                            otpverified=true;
                          });
                        }
                      
                    }, child: Text("Change Password"))
                  ],
                ),
              ):Row(),
              otpverified?Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: TextFormField(
                        controller: newpass,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Enter new Password"
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: TextFormField(
                        controller: conpass,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Confirm New Password"
                        ),
                      ),
                    ),
                    TextButton(onPressed: (){
                      if(newpass.text==conpass.text)
                      {changepass(newpass.text);
                    }
                      else
                        {
                          CherryToast.error(title: Text("Password Doesnot Match")).show(context);
                        }
                      }, child:Text("Change Password"))
                  ],
                ),
              ):Row()
            ],
          ),
        ),
      ),
    );
  }
  Future<void> sendOtp() async {
    Constants obj=new Constants();
    obj.setheader();
    String url=
        "${obj.ipaddress}/forget_password?email=${email.text}";
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects["otp"]);
    setState(() {
       otpvalue= decodedObjects["otp"];
       AccountNumber=decodedObjects["account_number"];
       otpsent=true;
    });
  }
  Future<bool> changepass(String password) async {
    Constants obj=new Constants();
    obj.setheader();
    String url=
        "${obj.ipaddress}/change_password?password=$password&account_no=${AccountNumber}";
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects["success"]);
    return decodedObjects["success"];
  }
}
