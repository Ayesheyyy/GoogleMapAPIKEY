import 'package:failedtoconnect/Validation_screens/signup.dart';
import 'package:failedtoconnect/variables/gloabl-var.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Screens/homepage.dart';
import '../methods/firstmethod.dart';
import '../mywidgets/loadingbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  TextEditingController EmailTextEditingController = TextEditingController();
  TextEditingController PasswordTextEditingController = TextEditingController();
  bool _passwordVisible = false;
  Methods_for_IntConnection cmethods = Methods_for_IntConnection();
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  NetworkAvailabilty() {
    cmethods.checkConnectivity(context);
    SignInFormValidation();
  }

  SignInFormValidation(){

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(EmailTextEditingController.text)){
      cmethods.showToastMessage("Enter valid Email",context);
    }
    else if(PasswordTextEditingController.text.trim().length<4){
      cmethods.showToastMessage("Enter Strong password", context);
    }
    else{
      SignInusers();
    }
  }

  SignInusers()async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context)=> Loadingbar(msg: "Loading"),
    );

    final User? userfirebase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: EmailTextEditingController.text.trim(),
            password: PasswordTextEditingController.text.trim()
        ).catchError((ErrorMsg){
          cmethods.showToastMessage(ErrorMsg.toString(),context);
        }
        )
    ).user;

    if(!context.mounted)return;
    Navigator.pop(context);

    if(userfirebase != null){
      DatabaseReference UsersRef = FirebaseDatabase.instance.ref().child("Users").child(userfirebase.uid);
      UsersRef.once().then((snap){
        if(snap.snapshot.value != null){
          if((snap.snapshot.value as Map)["AccountStatus"]=="No"){
            UserName = (snap.snapshot.value as Map)["Name"];
            Navigator.push(context, MaterialPageRoute(builder: (c)=>Homepage()));
          }
          else{
            FirebaseAuth.instance.signOut();
            cmethods.showToastMessage("Blocked! Contact with: aslamaisha810@gmail.com", context);
          }
        }
        else{
          FirebaseAuth.instance.signOut();
          cmethods.showToastMessage("Please Signup First", context);
        }
      });
    }
  }


  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        await handleSignIn(user);
      }
    } catch (e) {
      cmethods.showToastMessage(e.toString(), context);
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 10),
                    child: Image.asset(
                      "images/Per.png",
                      width: 250,
                      height: 230,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Text(
                    "Login as a User",
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF093E67),
                    ),
                  ),
                  // Text Field (Allows user to enter text)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: EmailTextEditingController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A7777),
                            ),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF152A8C),
                          ),
                        ),

                        SizedBox(height: 10,),

                        TextField(
                          controller: PasswordTextEditingController,
                          obscureText: !_passwordVisible,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7A7777),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                color: Color(0xFF152A8C),
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                          ),
                          style: const TextStyle(
                            color: Color(0xFF152A8C),
                          ),
                        ),
                        SizedBox(height: 15,),

                        ElevatedButton(
                            onPressed: (){
                              NetworkAvailabilty();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF06295E),
                                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10)
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontWeight:FontWeight.bold,
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            )
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: signInWithGoogle,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    ),
                    child: Text(
                      "Login with Google",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=> Signup()));
                    },
                    child: Text(
                      "Don\'t have an account? SignUp here",
                      style: TextStyle(
                        color: Color(0xFF061450),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  handleSignIn(User user) {}
}
