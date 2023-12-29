
import 'dart:convert';
import 'package:daulatpay/Navigation.dart';
import 'package:daulatpay/Screens/SignUp.dart';
import 'package:daulatpay/Screens/dashboard.dart';
import 'package:flutter/material.dart';


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
  var email=new TextEditingController();
  var password=new TextEditingController();
  var name;
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
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.2),
          child: Column(
            children: [
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
              Container(
                child: TextButton(
                    onPressed: () async{
                      bool success=await userLogin(email.text, password.text);
                      if(success)
                      {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>Navigation(
                          name: name,
                          AccountNo: accountno,
                          cash: currentamount,
                          transactions: transactions,
                        )));
                      }
                    },
                    child: Text("Login")),
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

        ),
      ),
    );
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
    String url="http://10.7.94.25:8000/login?Username=$username&Password=$password";  print("3");
    var data = await getData(url,headers);
    print("4");
    var decodedObjects = jsonDecode(data);
    print(decodedObjects);
    name=decodedObjects["FirstName"];
    currentamount=decodedObjects["CashAmount"];
    transactions=decodedObjects["Transactions"];
    accountno=decodedObjects["AccountNumber"];
    return decodedObjects["success"];
  }

}
