import 'dart:convert';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:daulatpay/Constants.dart';
import 'package:daulatpay/Screens/Login.dart';
import 'package:daulatpay/Screens/changepassword.dart';
import 'package:flutter/material.dart';
class Profile extends StatefulWidget {
  Profile({super.key,
  required this.name,
  required this.AccountNo,
  });
  String name;
  String AccountNo;
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
                    color: Color.fromARGB(255, 120, 245, 200)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 8),
                        child: Image.asset("lib/assets/user.png",height: 50,width: 50,),
                      ),
                      Text("${widget.name}",textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 120, 245, 200),
                borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left:30,right: 30,top: 10),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("Settings"),
                      Padding(
                        padding: const EdgeInsets.only(left:30,right: 30,top: 10),
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>GetAccountStatement( AccountNo: widget.AccountNo,)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child:Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Account Statement"),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:30,right: 30,top: 10,bottom: 15),
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>ChangePassword(AccountNo: widget.AccountNo,)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Change Password"),
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
           Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 120, 245, 200)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(padding: const EdgeInsets.only(left:30,right: 30,top: 10),
                      child: Text("Info"),),
                      Padding(
                        padding: const EdgeInsets.only(left:30,right: 30,top: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text("Help"),
                          ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left:30,right: 30,top: 10),
                        child: GestureDetector(
                          onTap: ()
                          {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>PrivacyPolicy(AccountNo: widget.AccountNo,)));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text("Privacy Policy"),
                            ),),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:30,right: 30,top: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 120, 245, 200)),
                child: Padding(
                  padding: const EdgeInsets.only(left:30,right: 30,top: 10,bottom: 10),
                  child: GestureDetector(
                    onTap: ()
                    {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Login()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child:Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text("Account Statement"),
                      ),
                    ),
                  ),
                ))),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Made in 🇵🇰 with ❤️ for 🌎",textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Version 1.0.01 v"),
            )
          ],
        ),
      ),
    );
  }
}
class GetAccountStatement extends StatefulWidget {
   GetAccountStatement({super.key,
    required this.AccountNo});
  String AccountNo;
  @override
  State<GetAccountStatement> createState() => _GetAccountStatementState();
}

class _GetAccountStatementState extends State<GetAccountStatement> {
  Constants obj=new Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("Why Request an Account Statement?\n-> Keep track of your transactions.\n-> Verify deposits, withdrawals, and transfers.\n-> Stay informed about your account status.\n-> Statements will be sent to your registered email address.\nFor security reasons, ensure your contact information is up to date."),
            ),
            Padding(
              padding: const EdgeInsets.only(left:35.0,right: 35),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.green
                ),
                child: TextButton(
                  child: Text("Request",style: TextStyle(color: Colors.white),),
                  onPressed: (){RequestAccountStatement();},
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> RequestAccountStatement() async {
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
    String url=
        "${obj.ipaddress}/generate_statement?AccountNumber=${widget.AccountNo}";
    var data = await getData(url,headers);
    var decodedObjects = jsonDecode(data);
    print( decodedObjects["success"]);
  }

}
class PrivacyPolicy extends StatefulWidget {
  PrivacyPolicy({required this.AccountNo});
  String AccountNo;
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  Constants obj=new Constants();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Last Updated: [Insert Last Update Date]',
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              '1. Introduction',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Welcome to [Your App Name], operated by [Your Company Name]. This Privacy Policy outlines our practices regarding the collection, use, and disclosure of personal information when you use our app.',
            ),
            SizedBox(height: 16.0),
            Text(
              '2. Information We Collect',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may collect personal information such as your name, email address, phone number, and transaction details to provide and improve our services. This information is collected when you register, make transactions, or interact with our app.',
            ),
            SizedBox(height: 8.0),
            Text(
              'Additionally, we may automatically collect device information, such as your device type, operating system, and IP address, to enhance app functionality and security.',
            ),
            SizedBox(height: 8.0),
            Text(
              'We do not sell, rent, or share your information with third parties, except as outlined in this Privacy Policy.',
            ),
            SizedBox(height: 16.0),
            Text(
              '3. How We Use Your Information',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We use the collected information to:',
            ),
            SizedBox(height: 4.0),
            Text('- Provide and maintain our services.'),
            Text('- Process transactions and send notifications.'),
            Text('- Improve and personalize user experience.'),
            Text('- Respond to customer service requests.'),
            Text('- Send periodic emails regarding your account and updates.'),
            SizedBox(height: 8.0),
            Text(
              'We may use aggregated, anonymized data for statistical analysis and marketing purposes.',
            ),
            SizedBox(height: 16.0),
            Text(
              '4. Information Sharing and Disclosure',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may share your personal information with:',
            ),
            SizedBox(height: 4.0),
            Text('- Service providers to facilitate our services.'),
            Text('- Financial institutions for transaction processing.'),
            Text('- Legal authorities in response to legal requests or to comply with the law.'),
            SizedBox(height: 8.0),
            Text(
              'We do not share your information for marketing purposes without your explicit consent.',
            ),
            SizedBox(height: 16.0),
            Text(
              '5. Security',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We take reasonable measures to protect your personal information from unauthorized access or disclosure. However, no method of transmission over the internet or electronic storage is completely secure.',
            ),
            SizedBox(height: 8.0),
            Text(
              'You are responsible for maintaining the confidentiality of your account credentials. Notify us immediately of any unauthorized access or security breach.',
            ),
            SizedBox(height: 16.0),
            Text(
              '6. Your Choices and Rights',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'You have the right to:',
            ),
            SizedBox(height: 4.0),
            Text('- Access, correct, or delete your personal information.'),
            Text('- Opt-out of marketing communications.'),
            Text('- Close your account.'),
            SizedBox(height: 8.0),
            Text(
              'To exercise these rights, contact us at [your contact email]. We will respond to your requests within a reasonable timeframe.',
            ),
            SizedBox(height: 16.0),
            Text(
              '7. Changes to this Privacy Policy',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'We may update this Privacy Policy to reflect changes in our practices or for legal compliance. We will notify you of any significant changes through the app or via email. Please review this policy periodically.',
            ),
            SizedBox(height: 16.0),
            Text(
              '8. Contact Us',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'If you have any questions or concerns regarding this Privacy Policy, please contact us at [your contact email].',
            ),
          ],
        ),
      ),
    );
  }

}
