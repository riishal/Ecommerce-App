import 'package:ecommerce_app/views/Loginpage/Sign_up.dart';
import 'package:ecommerce_app/controller/farebase.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  void despose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _formkey,
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Center(
                  child: Text(
                'Welcome To E-commerce App',
                // child: Text(
                //   'Welcome to Ecommerce App',
                style: GoogleFonts.abhayaLibre(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
                // ),
              )),
              const SizedBox(
                height: 30,
              ),
              Text('Login to your account',
                  style: GoogleFonts.abhayaLibre(
                      color: Colors.white, fontSize: 17)),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'value is empty';
                    }
                    return null;
                  },
                  controller: _emailcontroller,
                  decoration: InputDecoration(
                      hintText: 'Email / Mobile',
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.1,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'value is empty';
                    }
                    return null;
                  },
                  controller: _passwordcontroller,
                  obscureText: _passwordVisible,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black,
                          )),
                      hintStyle: const TextStyle(color: Colors.grey),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20))),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 220),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        // checkLogin();
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: _emailcontroller.text.trim(),
                            password: _passwordcontroller.text.trim());
                      } else {
                        ('data empty');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        backgroundColor: Colors.blue),
                    child: const Text('Login'),
                  ),
                ),
              ),
              TextButton(
                  onPressed: (() {}),
                  child: const Text(
                    'Forgot your password ?',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(
                height: 0,
              ),
              const Text('OR', style: TextStyle(color: Colors.white)),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                    onPressed: (() {
                      Google_Signin().signInWithGoogle();
                    }),
                    style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(246, 234, 236, 240)),
                    child: Row(children: <Widget>[
                      Image.network(
                        'https://cdn1.iconfinder.com/data/icons/google-s-logo/150/Google_Icons-09-512.png',
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
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SigninPage(),
                        ));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 14, 2, 0),
      ),
    );
  }

  // void checkLogin() {
  //   final emil = _emailcontroller.text;
  //   final password = _passwordcontroller.text;
  //   if (emil == password) {
  //   } else {
  //     const errorMessage = 'username password does not match';
  //     //snackBar
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         backgroundColor: Colors.red,
  //         margin: EdgeInsets.all(15),
  //         duration: Duration(seconds: 3),
  //         behavior: SnackBarBehavior.floating,
  //         content: Text(errorMessage)));
  //   }
  // }
}
