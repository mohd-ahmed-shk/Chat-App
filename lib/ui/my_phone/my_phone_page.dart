// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:setup/constants/app_style.dart';
// import 'package:setup/ui/verify/verify_page.dart';
//
// class MyPhone extends StatefulWidget {
//   const MyPhone({super.key});
//   static String verify = "";
//
//   @override
//   State<MyPhone> createState() => _MyPhoneState();
// }
//
// class _MyPhoneState extends State<MyPhone> {
//   TextEditingController countryController = TextEditingController();
//   String number = "";
//
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     countryController.text = "+91";
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         margin: EdgeInsets.only(left: 25, right: 25),
//         alignment: Alignment.center,
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'assets/images/img1.png',
//                 width: 150,
//                 height: 150,
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Text(
//                 "Phone Verification",
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "We need to register your phone without getting started!",
//                 style: regular,
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(
//                 height: 30,
//               ),
//               Container(
//                 height: 55,
//                 decoration: BoxDecoration(
//                     border: Border.all(width: 1, color: Colors.grey),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     SizedBox(
//                       width: 10,
//                     ),
//                     SizedBox(
//                       width: 40,
//                       child: TextField(
//                         controller: countryController,
//                         keyboardType: TextInputType.number,
//                         decoration: InputDecoration(
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       "|",
//                       style: TextStyle(fontSize: 33, color: Colors.grey),
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                         child: TextField(
//                           onChanged: (value) {
//                             number = value;
//                           },
//                       keyboardType: TextInputType.phone,
//                       decoration: InputDecoration(
//                         border: InputBorder.none,
//                         hintText: "Phone",
//                       ),
//                     ))
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               SizedBox(
//                 width: double.infinity,
//                 height: 45,
//                 child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10))),
//                     onPressed: () async {
//                       await FirebaseAuth.instance.verifyPhoneNumber(
//                         phoneNumber: '${countryController.text + number}',
//                         verificationCompleted: (phoneAuthCredential) {},
//                         verificationFailed: (error) {},
//                         codeSent: (verificationId, forceResendingToken) {
//                           MyPhone.verify = verificationId;
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const MyVerify(),
//                               ));
//                         },
//                         codeAutoRetrievalTimeout: (verificationId) {},
//                       );
//                     },
//                     child: Text("Send the code")),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
