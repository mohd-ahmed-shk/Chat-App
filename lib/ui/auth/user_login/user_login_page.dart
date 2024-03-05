import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/helper/helper_function.dart';
import 'package:setup/service/auth_service.dart';
import 'package:setup/service/database_service.dart';
import 'package:setup/ui/auth/user_signin/user_signin_page.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/base_app_bar.dart';
import '../../home/home_page.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({super.key});

  @override
  State<UserLoginPage> createState() => _UserLoginPageState();
}

class _UserLoginPageState extends State<UserLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  bool hidePass = true;

  bool _isLoading = false;
  AuthService authService = AuthService();

  void login() async {
    setState(() {
      _isLoading = true;
    });
    await authService
        .loginWithEmailAndPassword(_emailController.text, _passController.text)
        .then((value) async {
      if (value == true) {
        QuerySnapshot snapshot =
            await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                .gettingUserData(_emailController.text);

        // saving the values to our shared preferences
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(_emailController.text);
        await HelperFunction.saveUserNameSF(snapshot.docs[0]["fullName"]);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(),
            ));
      } else {
        showSnackBar(value);
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20).r,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        50.verticalSpace,
                        Text(
                          "Chat Application",
                          style:
                              TextStyle(color: Colors.black, fontSize: 30.sp),
                        ),
                        20.verticalSpace,
                        Text(
                          "Welcome back!",
                          style: TextStyle(fontSize: 35.sp),
                        ),
                        20.verticalSpace,
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text.rich(
                            TextSpan(
                                text: "New here? ",
                                style: TextStyle(
                                    fontSize: 15.sp, color: Colors.grey),
                                children: [
                                  TextSpan(
                                      text: "Create Account",
                                      style: const TextStyle(
                                          color: Color(0xFFD5715B)),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const UserSignInPage(),
                                              ));
                                        })
                                ]),
                          ),
                        ),
                        20.verticalSpace,
                        AppTextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          hintText: 'Email Address',
                          prefixIcon: const Icon(Icons.alternate_email_rounded),
                        ),
                        20.verticalSpace,
                        AppTextField(
                          controller: _passController,
                          obscureText: hidePass,
                          textInputAction: TextInputAction.done,
                          hintText: 'Password',
                          prefixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePass = !hidePass;
                              });
                            },
                            icon: hidePass
                                ? const Icon(Icons.lock_outline_rounded)
                                : const Icon(Icons.lock_open_rounded),
                          ),
                        ),
                        30.verticalSpace,
                        AppButton(
                          onPressed: () {
                            if (_emailController.text.isEmpty) {
                              showSnackBar("Enter your email address");
                            } else if (_passController.text.isEmpty) {
                              showSnackBar("Enter your password");
                            } else {
                              login();
                            }
                          },
                          title: 'Login',
                        ),
                        35.verticalSpace,
                        Center(
                          child: Text(
                            "or login with",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                        ),
                        35.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30)
                                  .r,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40).r,
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4))),
                              child: Image.asset(
                                "assets/images/img_2.png",
                                width: 30.r,
                                height: 30.r,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30)
                                  .r,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40).r,
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4))),
                              child: Image.asset(
                                "assets/images/img.png",
                                width: 30.r,
                                height: 30.r,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 30)
                                  .r,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40).r,
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.4))),
                              child: Image.asset(
                                "assets/images/img_1.png",
                                width: 30.r,
                                height: 30.r,
                              ),
                            ),
                          ],
                        ),
                        20.verticalSpace,
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  showSnackBar(String text) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
