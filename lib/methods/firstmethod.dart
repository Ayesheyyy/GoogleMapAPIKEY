import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Methods_for_IntConnection
{
  checkConnectivity(BuildContext context) async {
    var InternetConnection = await Connectivity().checkConnectivity();

    if(ConnectivityResult.mobile!= InternetConnection && ConnectivityResult.wifi!=InternetConnection) {
      if (!context.mounted) return;
      // showToastMessage("Retry!",context);
    }
  }
  void showToastMessage(String message, context) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.purple,
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}