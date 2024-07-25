import 'package:flutter/material.dart';
class Loadingbar extends StatelessWidget {

  String msg;

  Loadingbar({super.key, required this.msg,});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17),
        ),
        backgroundColor: Color(0xFF06295E),
        child: Container(
          margin: EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFF093E67),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 5,),

                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),

                SizedBox(height: 8,),

                Text(
                  msg,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
