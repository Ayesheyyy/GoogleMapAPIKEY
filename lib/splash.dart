import'package:flutter/material.dart';
import 'dart:async';
import 'Validation_screens/login.dart';
class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final String gifUrl = 'images/Gif2.gif';
  @override
  void initState(){
    super.initState();
    Timer(
        Duration(seconds: 5),
            () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen())));

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text('GOOGLEMAP API-KEY', style: TextStyle(color: Colors.purple,
          fontSize: 17, fontWeight: FontWeight.bold),),
        ),
      ),
      body: Column(

        children: [
        Image.asset('images/Gif2.gif'),

          SizedBox(height: 15,),

          Center(
            child: Text(
              'Welcome! Use the googlemap ',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

          Center(
            child: Text(
                'to check your live location',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),

          SizedBox(height: 120,),

          CircularProgressIndicator(
            color: Colors.purpleAccent,
          )
      ],
      ),
    );
  }
}

