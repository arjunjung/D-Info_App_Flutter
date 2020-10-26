// import 'dart:async';
// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:testing_book/screens/welcomescreen.dart';
// import 'package:http/http.dart' as http;

// // ignore: must_be_immutable
// class VerifiyEmail extends StatefulWidget {
//   VerifiyEmail({Key key}) : super(key: key);

//   @override
//   _VerifiyEmailState createState() => _VerifiyEmailState();
// }

// class _VerifiyEmailState extends State<VerifiyEmail> {
//   @override
//   Widget build(BuildContext context) {
//     _checkUserChanges();
//     return MaterialApp(
//       title: "Verify Email ",
//       home: _verifyEmailBody(),
//     );
//   }

//   bool _isUserEmailVerified;
//   Timer _timer;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     Future(() async {
//       _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
//         await FirebaseAuth.instance.currentUser
//           ..reload();
//         final user = await FirebaseAuth.instance.currentUser;
//         if (user.emailVerified) {
//           setState(() {
//             _isUserEmailVerified = user.emailVerified;
//           });
//           timer.cancel();
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     if (_timer != null) {
//       _timer.cancel();
//     }
//   }

//   Future<void> _sendEmail() async {
//     User user = FirebaseAuth.instance.currentUser;

//     return FutureBuilder(
//       future: user.sendEmailVerification(),
//       builder: (context, snapshot) {
//         if (snapshot.hasError) {
//           print("Error while send email");
//         }
//         if (snapshot.connectionState == ConnectionState.done) {
//           print("Email sent successfully");
//         }
//       },
//     );
//   }

//   Widget _verifyEmailBody() {
//     _sendEmail();
//     return Scaffold(
//       appBar: AppBar(title: Text("Verify Email ")),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             _isUserEmailVerified == true ? _goToWelcome() : Text("Email has been sent, please verify."),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _goToWelcome() {
//     final User user = FirebaseAuth.instance.currentUser;
//     final String token = user.uid.toString();
//     // final Future<http.Response> response = _addToken(token);

//     // FutureBuilder(
//     //     future: response,
//     //     builder: (context, snapshot) {
//     //       if (snapshot.hasError) {
//     //         print("Error in adding token");
//     //       }
//     //       if (snapshot.connectionState == ConnectionState.done) {
//     //         if (snapshot.data == 201) {
//     //           print("Resonse is ${snapshot.data}");
//     //         }
//     //         print("successfully added token to the backend");
//     //       }
//     //     });


//     return SizedBox(height: 2);
//   }

//   void _checkCode(String code) async {
//     try {
//       await FirebaseAuth.instance.checkActionCode(code);
//       await FirebaseAuth.instance.applyActionCode(code);
//     } on FirebaseAuthException catch (e) {
//       print(e.message.toString());
//       print("Code mismatched.");
//     } finally {
//       print("Code matched");
//     }
//   }

//   void _listenUser() {
//     FirebaseAuth.instance.authStateChanges().listen((User user) {
//       if (user == null) {
//         print('User is currently signed out!');
//       } else {
//         print('User is signed in!');
//       }
//     });
//   }

//   void _checkUserChanges() {
//     FirebaseAuth.instance.userChanges();
//   }

// //api calling to do post
//   Future<http.Response> _addToken(String token) {
//     return http.post(
//       'http://127.0.0.1:8000/api/createtoken/',
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{"token": token, "free_trial_until": null, "membership_until": null}),
//     );
//   }
// }
