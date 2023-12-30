import 'dart:convert';

class Constants{
  String ipaddress= "http://10.7.92.98:8000";
  String credentials = base64.encode(utf8.encode('amaan:12345'));
  late Map<String,String> headers;

void setheader()
{
     headers= {
    'Authorization': 'Basic $credentials',
    'Content-Type': 'application/json',
  };
}


}