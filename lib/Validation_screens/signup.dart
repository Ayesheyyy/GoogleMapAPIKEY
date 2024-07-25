import 'package:failedtoconnect/Screens/homepage.dart';
import 'package:failedtoconnect/Validation_screens/login.dart';
import 'package:failedtoconnect/mywidgets/loadingbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import '../methods/firstmethod.dart';
class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  bool _passwordVisible = false;
  Methods_for_IntConnection cmethods = Methods_for_IntConnection();

  NetworkAvailabilty() {
    cmethods.checkConnectivity(context);
    SignUpFormValidation();
  }

SignUpFormValidation(){
    if(nameTextEditingController.text.trim().length<4 || !RegExp(r'^[a-z A-Z ]+$').hasMatch(nameTextEditingController.text.trim())){
     cmethods.showToastMessage("name must be above 4 characters or valid",context);
    }
    else if(phoneTextEditingController.text.trim().length<9 || !RegExp(r'^\d+$').hasMatch(phoneTextEditingController.text.trim())){
      cmethods.showToastMessage("Number Must be Valid or above 9 characters",context);
    }
    else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailTextEditingController.text)){
      cmethods.showToastMessage("Enter valid Email",context);
    }
    else if(passwordTextEditingController.text.trim().length<4){
      cmethods.showToastMessage("Enter Strong password", context);
    }
    else{
      Registerusers();
    }
  }

  Registerusers() async{
    showDialog(
       context: context,
       barrierDismissible: false,
      builder: (BuildContext context)=> Loadingbar(msg: "Please wait for registeration"),
    );

    final User? userfirebase = (
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim()
    ).catchError((ErrorMsg){
      cmethods.showToastMessage(ErrorMsg.toString(),context);
    }
    )
    ).user;
    if(!context.mounted)return;
    Navigator.pop(context);

    DatabaseReference UsersRef = FirebaseDatabase.instance.ref().child("Users").child(userfirebase!.uid);

    Map userdata =
        {
          "Name" : nameTextEditingController.text.trim(),
          "Email": emailTextEditingController.text.trim(),
          "Phoneno": phoneTextEditingController.text.trim(),
          "id" : userfirebase.uid,
          "AccountStatus": "No",
        };

    UsersRef.set(userdata);

    Navigator.push(context, MaterialPageRoute(builder: (c)=>Homepage()));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 20, left: 10),
                  child: Image.asset(
                    "images/Per.png",
                    width: 250,
                    height: 230,
                    fit: BoxFit.contain,
                  ),
                ),
                const Text(
                  "Create a User's account",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF093E67), // Changed color to dark blue
                  ),
                ),

                // Text Field (Allows user to enter text)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "User's Name",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5,),

                      TextField(
                        controller: phoneTextEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5,),

                      TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),

                      SizedBox(height: 5,),

                      TextField(
                        controller: passwordTextEditingController,
                        obscureText: !_passwordVisible,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF7A7777), // Changed color to dark blue
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xFF152A8C), // Changed color to dark blue
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF152A8C), // Changed color to dark blue
                        ),
                      ),
                      SizedBox(height: 15,),

                      ElevatedButton(
                        onPressed: (){
                          NetworkAvailabilty();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF06295E), // Changed color to dark blue
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                        ),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // TextButton
                TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=> LoginScreen()));
                  },
                  child: Text(
                    "Already have an account? Login here",
                    style: TextStyle(
                      color: Color(0xFF061450), // Changed color to dark blue
                    ),
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



