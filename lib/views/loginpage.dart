import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/model/user_model.dart';
import 'package:ecommerce_app/service/farebase.dart';
import 'package:ecommerce_app/service/ui_helper.dart';
import 'package:ecommerce_app/views/Homepage.dart';
import 'package:ecommerce_app/views/Sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isHidden = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void checkValues() {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email == "" || password == "") {
      UIHelper.showAlertDialog(
          context, "Incomplited Data", "Please fill all the fields");
      print('please fill All fields!');
    } else {
      //login
      logIn(email, password);
    }
  }

  void logIn(String email, String password) async {
    UserCredential? userCredential;
    UIHelper.showLoadingDialog(context, "Logging In..");
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (ex) {
      //Close the Loading Dialog

      Navigator.pop(context);
      //Show Alert Dialog
      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
      print(ex.message.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("users").doc(uid).get();
      UserModel userModel =
          UserModel.fromMap(userData.data() as Map<String, dynamic>);
      //go to Homepage
      print('Login successful');
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Homepage(
                userModel: userModel, firebaseUser: userCredential!.user!),
          ));
    }
  }

  void signUpGoogle() async {
    UserCredential? userCredential;
    UIHelper.showLoadingDialog(context, "GoogleSign in...");

    try {
      userCredential = await FirebaseHelper().signInWithGoogle();
    } on FirebaseAuthException catch (ex) {
      Navigator.pop(context);
      UIHelper.showAlertDialog(
          context, "An error occured", ex.message.toString());
      print(ex.code.toString());
    }
    if (userCredential != null) {
      String uid = userCredential.user!.uid;
      UserModel newUser = UserModel(
          uid: uid,
          email: userCredential.user!.email,
          fullName: userCredential.user!.displayName,
          profilepic: userCredential.user!.photoURL);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .set(newUser.toMap())
          .then(
        (value) {
          print('New user Created');
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Homepage(
                      userModel: newUser, firebaseUser: userCredential!.user!)
                  // CompliteProfile(
                  //     userModel: newUser, firebaseUser: userCredential!.user!),
                  ));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.black),
        child: Center(
          child: SingleChildScrollView(
              child: Column(
            children: [
              Text(
                "Welcome To E-commerce App",
                style: GoogleFonts.abhayaLibre(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: Colors.white),
              ),
              SizedBox(
                height: 1,
              ),
              Text('Login to your account',
                  style: GoogleFonts.abhayaLibre(
                      color: Colors.white, fontSize: 24)),
              const SizedBox(
                height: 30,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: size.height * 0.074,
                width: size.width * 0.89,
                child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    )),
              ),
              const SizedBox(
                height: 19,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)),
                height: size.height * 0.074,
                width: size.width * 0.89,
                child: TextFormField(
                    obscureText: isHidden,
                    controller: passwordController,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: togglePasswordView,
                          child: Icon(
                            isHidden ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                          )),
                      hintText: "Password",
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () {
                      checkValues();
                    },
                    child: Text(
                      "Login",
                      style: GoogleFonts.abhayaLibre(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'OR',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                    onPressed: (() {
                      signUpGoogle();
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    child: Row(children: <Widget>[
                      Image.asset(
                        'assets/image/Google.png',
                        height: 30,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Expanded(
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ])),
              ),
            ],
          )),
        ),
      )),
      bottomNavigationBar: Container(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            "Don't have an account?",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          CupertinoButton(
            child: const Text(
              'Sign Up',
              style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ));
            },
          )
        ]),
      ),
    );
  }

  togglePasswordView() {
    setState(() {
      isHidden = !isHidden;
    });
  }
}
