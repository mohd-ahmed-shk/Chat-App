import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/helper/helper_function.dart';
import 'package:setup/service/auth_service.dart';
import 'package:setup/ui/auth/user_login/user_login_page.dart';
import 'package:setup/ui/home/home_page.dart';

import '../../../widgets/app_button.dart';
import '../../../widgets/app_text_field.dart';
import '../../../widgets/base_app_bar.dart';

class UserSignInPage extends StatefulWidget {
  const UserSignInPage({super.key});

  @override
  State<UserSignInPage> createState() => _UserSignInPageState();
}

class _UserSignInPageState extends State<UserSignInPage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _confirmController = TextEditingController();

  AuthService authService = AuthService();
  bool _isLoading = false;

  void register() async {
    setState(() {
      _isLoading = true;
    });
    await authService.registerUserWithEmailAndPassword(_nameController.text, _emailController.text ,_passController.text).then((value) async {
      if(value == true) {
        await HelperFunction.saveUserLoggedInStatus(true);
        await HelperFunction.saveUserEmailSF(_emailController.text);
        await HelperFunction.saveUserNameSF(_nameController.text);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage(),));

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20).r,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          "Chat Application",
                          style:
                              TextStyle(color: Colors.black, fontSize: 30.sp),
                        ),
                        10.verticalSpace,
                        Text(
                          "Welcome",
                          style:
                              TextStyle(fontSize: 20.sp, color: Colors.black),
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
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            "or signup with",
                            style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey.withOpacity(0.4)),
                          ),
                        ),
                        20.verticalSpace,
                        AppTextField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          hintText: 'Full name',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
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
                          textInputAction: TextInputAction.next,
                          hintText: 'Password',
                          prefixIcon: const Icon(
                            Icons.lock_outline_rounded,
                          ),
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const UserLoginPage(),
                                    ));
                              },
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                            AppButton(
                                width: 200.w,
                                onPressed: () {
                                  if (_nameController.text.isEmpty) {
                                    showSnackBar("Enter your full name");
                                  } else if (_emailController.text.isEmpty) {
                                    showSnackBar("Enter your email");
                                  } else if (_passController.text.isEmpty) {
                                    showSnackBar("Enter password");
                                  } else {
                                    register();
                                  }
                                },
                                title: "Continue")
                          ],
                        )
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
