
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';


import 'Dashboard UI.dart';

const String appId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
const String clientKey = '1N9033LOw5A018zPw8p5hY0oeifTMv3a7Oqhgb1r';
const String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';
const String serverUrl = 'https://parseapi.back4app.com';

void main() async{
  const keyApplicationId = 'SpzDQ8AKK7WEBVBSUkwU4C9Xsxfyjsboz4PwXyjW';
  const keyClientKey = '1N9033LOw5A018zPw8p5hY0oeifTMv3a7Oqhgb1r';
  const keyParseServerUrl = 'https://parseapi.back4app.com';
  const String masterKey = 'lbcdkueIQFQEnm7gM5jj114myeNO8YCsdFVKIxSd';

  await Parse().initialize(
    keyApplicationId,
    keyParseServerUrl,
    clientKey: keyClientKey,
    masterKey:masterKey,
    autoSendSessionId: true,
    debug: true,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Dashboard',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home:LiveStreamDashboardApp());
  }}
