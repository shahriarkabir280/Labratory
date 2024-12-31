import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:testapp/authentications/loginScreen.dart';
import 'package:testapp/Models/DataModel.dart';
import 'package:testapp/features/splashScreen.dart';





void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DataModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) =>splashScreen(),
          '/home':(context)=>loginScreen(),
        },
      ),
    );
  }
}





