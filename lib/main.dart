import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/helper/helper_function.dart';
import 'package:setup/shared/constants.dart';
import 'package:setup/ui/add_todo/add_todo_page.dart';
import 'package:setup/ui/auth/user_login/user_login_page.dart';
import 'package:setup/ui/home/home_page.dart';
import 'package:setup/ui/my_phone/my_phone_page.dart';
import 'package:setup/ws_cube/ui/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: Constants.apiKey,
            appId: Constants.appId,
            messagingSenderId: Constants.messagingSenderId,
            projectId: Constants.projectId
        ));
  } else if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: Constants.apiKey,
          appId: Constants.appId,
          messagingSenderId: Constants.messagingSenderId,
          projectId: Constants.projectId
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   bool _isSignedIn = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getUserLoggedInStatus();
//   }
//   getUserLoggedInStatus() async {
//     await HelperFunction.getUserLoggedInStatus().then((value) {
//       if(value != null) {
//         _isSignedIn = value;
//       }
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: _isSignedIn ? const HomePage() : UserLoginPage(),
//     );
//   }
// }



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSignedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLoggedInStatus();
  }
  getUserLoggedInStatus() async {
    await HelperFunction.getUserLoggedInStatus().then((value) {
      if(value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
    print("++++++++++Main++++++++++++++++++++++${_isSignedIn}+++++++++++++++++++++++++++++++++");
  }
  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_ , child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'First Method',
          // You can use the library anywhere in the app even in theme
          home: child,
        );
      },
      child: _isSignedIn ? const HomePage() : const UserLoginPage(),

    );
  }
}
