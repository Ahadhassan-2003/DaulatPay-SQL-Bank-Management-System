import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var email = new TextEditingController();
  var password = new TextEditingController();
  var conpassword = new TextEditingController();
  var username = new TextEditingController();
  var firstname = new TextEditingController();
  var lastname = new TextEditingController();
  var cms = new TextEditingController();
  var address = new TextEditingController();
  var dob = new TextEditingController();
  var phone = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Padding(
          padding: EdgeInsets.only(),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35.0, top: 15),
                  child: TextFormField(
                    controller: email,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: password,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: conpassword,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: username,
                    decoration: InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: firstname,
                    decoration: InputDecoration(
                      labelText: "First Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: lastname,
                    decoration: InputDecoration(
                      labelText: "Last Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: cms,
                    decoration: InputDecoration(
                      labelText: "CMS",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: "Addresss",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: dob,
                    decoration: InputDecoration(
                      labelText: "Date of Birth",
                      hintText: 'YYYY-MM-DD',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 35.0, right: 35, top: 15),
                  child: TextFormField(
                    controller: phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Container(
                  child: TextButton(
                      onPressed: () async {
                        await userSignup(
                            username.text,
                            password.text,
                            firstname.text,
                            lastname.text,
                            dob.text,
                            phone.text,
                            email.text,
                            cms.text);
                      },
                      child: Text("SignUp")),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text("Already have an Account"),
                    Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Login()));
                            },
                            child: Text(
                              "Login in Now",
                              style: TextStyle(color: Colors.white),
                            )))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> userSignup(
      String username,
      String password,
      String fname,
      String lname,
      String dob,
      String phoneno,
      String email,
      String cms) async {
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
    String url =
        "http://10.7.93.97:8000/signup?Username=$username&Password=$password&FirstName=$fname&LastName=$lname&Email=$email&CMS=$cms&Address=${address.text}&DOB=$dob&Phone=${phone.text}";
    var data = await getData(url, headers);
    var decodedObjects = jsonDecode(data);
    if(decodedObjects["success"])
      {
        CherryToast.success(title: Text("Account Successfully created\nPlease Login Again")).show(context);
        Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
      }
    else
    {
      CherryToast.success(title: Text("Account Not Created.\nTry Again Later")).show(context);
    }
  }
}
