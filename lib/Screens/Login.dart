
import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Navigation.dart';
import 'package:daulatpay/Screens/ForgotPassword.dart';
import 'package:daulatpay/Screens/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

Future<String> getData(String url,Map<String,String> header) async {
  try {
    http.Response response = await http.get(Uri.parse(url),headers: header);
    return response.body;
  } catch (e) {
    print(e);
    return '';
  }
}

class _LoginState extends State<Login> {
  bool isLoggingin=false;
  Constants obj=new Constants();
  var email=new TextEditingController();
  var password=new TextEditingController();
  var name;
  var status;
  var accountno;
  var currentamount;
  List? transactions;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.05),
          child: Column(
            children: [
              Image.asset("lib/assets/logo.png",height: 300,width: 300,),
              Padding(
                padding: const EdgeInsets.only(
                    left: 35.0, right: 35.0, top: 15),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 35.0, right: 35, top: 15),
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:10.0,bottom: 10.0,right: 35,left:35),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: TextButton(
                      onPressed: () async {
                        if (email.text.isEmpty || password.text.isEmpty) {
                          CherryToast.warning(title: Text(
                              "Please fill out both fields")).show(context);
                        }
                        else {
                          setState(() {
                            isLoggingin = true;
                          });
                          bool success = await userLogin(email.text,
                              password.text);
                          if (success) {
                            setState(() {
                              isLoggingin = false;
                            });
                            CherryToast.success(title: Text("Login Successful"))
                                .show(context);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) =>
                                    Navigation(
                                      name: name,
                                      AccountNo: accountno,
                                      cash: currentamount,
                                      transactions: transactions,
                                    )));
                          }
                          else if(status=="UNBLOCKED") {
                            CherryToast.error(
                                title: Text("Username or Password Incorrect"))
                                .show(context);
                            setState(() {
                              isLoggingin = false;
                            });
                          }
                          else if(status=="BLOCKED")
                            {
                            setState(() {
                            isLoggingin = false;
                            });
                            }
                              CherryToast.error(title: Text("Account Blocked!\nPlease contact your Aministrator")).show(context);
                            }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top:10.0,bottom: 10,right: 35,left: 35),
                        child: isLoggingin?LoadingAnimationWidget.threeArchedCircle(color: Colors.white, size: 20):Text("Login",
                        style: GoogleFonts.actor(
                          color: Colors.white
                        ),
                        ),
                      )),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Don't have an Account"),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(onPressed:(){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>SignUp()));
    }
        , child: Text("Sign Up Now",style: GoogleFonts.montserrat(color: Colors.white),),),
      ),
    ]),
              Padding(
                padding: const EdgeInsets.only(top:10.0,bottom: 10.0,right: 35,left:35),
                child: Container(
                  child: Row(
                    children: [
                      TextButton(child:Text("Forgot Password?"),
                        onPressed: (){
                        Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>ForgotPassword()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
    ])
    )));
  }

  Future<bool> userLogin(String username, String password) async {
    String user = 'amaan';
    String pass = '12345';

    // Combine the username and password into a single string
    String credentials = base64.encode(utf8.encode('$user:$pass'));

    // Set up the request headers with Basic Authentication
    Map<String, String> headers = {
      'Authorization': 'Basic $credentials',
      'Content-Type': 'application/json',
    };

    // Encode the username and password in the URL
    String url = "${obj.ipaddress}/login?Username=$username&Password=$password";
    print("3");
    var data = await getData(url, headers);
    var decodedObjects = jsonDecode(data);
    print(decodedObjects);
    if (decodedObjects["AccountStatus"]=="UNBLOCKED")
    {
      name = decodedObjects["FirstName"];
      currentamount = decodedObjects["CashAmount"];
      transactions = decodedObjects["Transactions"];
      accountno = decodedObjects["AccountNumber"];
      status=decodedObjects["AccountStatus"];
      return decodedObjects["success"];
    }
    else
      {
        return false;
      }
  }
}
