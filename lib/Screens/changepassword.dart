import 'dart:convert';

import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ChangePassword extends StatefulWidget {
  ChangePassword({super.key,
    required this.AccountNo,
  });
  String AccountNo;
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool otpsent=false;
  int? otpvalue;
  Constants obj=new Constants();
  var oldpass=new TextEditingController();
  var newpass=new TextEditingController();
  var conpass=new TextEditingController();
  var otp=new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 35.0,right: 35,top: 10,bottom: 10),
          child: TextFormField(
            controller: oldpass,
            decoration: InputDecoration(
              hintText: 'Enter old password',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0,right: 35,top: 10,bottom: 10),
          child: TextFormField(
            controller: newpass,
            decoration: InputDecoration(
              hintText: 'Enter new password',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0,right: 35,top: 10,bottom: 10),
          child: TextFormField(
            controller: conpass,
            decoration: InputDecoration(
              hintText: "Confirm new password",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 35.0,right: 35,top: 10,bottom: 10),
          child: TextFormField(
            controller: otp,
            decoration: InputDecoration(
              hintText: "Enter OTP sent to your email.",
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:10.0,bottom: 10,left: 35,right: 35),
          child: Container(
            width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextButton(onPressed: () async {
                if(otpsent)
                  {
                    print(otpvalue);
                    print(otp.text);
                    print((otp.text)==otpvalue.toString());
                   if(otp.text==otpvalue.toString())
                   {  print(12);
                    if(await changePassword(newpass.text))
                      {
                        print(13);
                        print("Password Changed Successfully");
                      }
                   }
                  }
                else {
                  if (newpass.text == conpass.text) {

                    if (await CheckPassword(oldpass.text)) {
                      await sendOtp();
                      setState(() async {
                        otpsent = true;
                        print(true);
                      });
                    }
                  }
                }
              }, child: Text("Change Password",style: GoogleFonts.oswald(
                color: Colors.white,
              ),))),
        ),

      ],
      ),
    );
  }

  Future<bool> CheckPassword(String password)
  async
  {
    obj.setheader();
    String url=
        "${obj.ipaddress}/get_old_password?account_no=${widget.AccountNo}";
      var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects["Password"]);
    print(password);
    print(password==decodedObjects["Password"]);
    if(password==decodedObjects["Password"])
      {

        return true;
      }
    else
      {
        return false;
      }
  }

  Future<void> sendOtp() async {
    obj.setheader();
    String url=
        "${obj.ipaddress}/generate_otp?account_no=${widget.AccountNo}";
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects["otp"]);
    setState(() {
      otpvalue= decodedObjects["otp"];
    });
     }
  Future<bool> changePassword(String password) async {
    obj.setheader();
    String url=
        "${obj.ipaddress}/change_password?password=$password&account_no=${widget.AccountNo}";
    var data = await getData(url,obj.headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects["success"]);
    return decodedObjects["success"];
  }

}
