// import 'dart:async';

// import 'package:ecommerce_app/model/user_model.dart';
// import 'package:ecommerce_app/views/Homepage.dart';
// import 'package:ecommerce_app/views/loginpage.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';

// class SplashScreen extends StatefulWidget {
//   final UserModel userModel;
//   final User firebaseUser;
//   const SplashScreen({super.key, required this.userModel, required this.firebaseUser});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(const Duration(seconds: 6), (() {
//       navigateToMainScreen();
//     }));
//   }

//   void navigateToMainScreen() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(
//         builder: (context) => StreamBuilder<User?>(
//           stream: FirebaseAuth.instance.authStateChanges(),
//           builder: ((context, snapshot) {
//             if (snapshot.hasData) {
//               return SizedBox();
//               //  const Homepage();
//             } else {
//               return const LoginPage();
//             }
//           }),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 70,
//             ),
//             Lottie.asset('assets/image/69170-ecommerce-base.json'),
//             const SizedBox(height: 50),
//             Center(
//               child: Image.asset(
//                 "assets/image/main-qimg-23d132ec785b54705660e9bc1d95d43a-pjlq.jpeg",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
