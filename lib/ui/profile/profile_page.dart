import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/ui/home/home_page.dart';

import '../../helper/helper_function.dart';
import '../../service/auth_service.dart';
import '../auth/user_login/user_login_page.dart';
import '../search/search_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;
  const ProfilePage({super.key, required this.userName, required this.userEmail});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchPage(),
                    ));
              },
              icon: const Icon(Icons.search))
        ],
        elevation: 0,
        backgroundColor: Colors.grey.withOpacity(0.8),
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.white, fontSize: 30.sp),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 170).r,
        child: Column(
          children: [
            Icon(
              Icons.account_circle,
              size: 200.r,
              color: Colors.grey[700],
            ),
            15.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Full Name",style: buildTextStyle(),),
                Text(widget.userName,style: buildTextStyle(),),
              ],
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Email",style: buildTextStyle(),),
                Text(widget.userEmail,style: buildTextStyle(),),
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50).r,
          children: [
            Icon(
              Icons.account_circle,
              size: 150.r,
              color: Colors.grey[700],
            ),
            15.verticalSpace,
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            30.verticalSpace,
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },

              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5).r,
              leading: const Icon(Icons.group),
              title: Text(
                "Groups",
                style: buildTextStyle(),
              ),
            ),
            ListTile(
              onTap: () {

              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5).r,
              leading: const Icon(Icons.person),
              selectedColor: Colors.orange,
              selected: true,
              title: Text(
                "Profile",
                style: buildTextStyle(),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        "LogOut",
                        style: buildTextStyle(),
                      ),
                      content: Text(
                        "Are you sure you want to logout",
                        style: buildTextStyle(),
                      ),
                      actions: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                            )),
                        IconButton(
                            onPressed: () async {
                              await authService.signOut().whenComplete(() {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const UserLoginPage(),
                                    ));
                              });
                            },
                            icon: const Icon(
                              Icons.exit_to_app,
                              color: Colors.green,
                            )),
                      ],
                    );
                  },
                );

              },
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5).r,
              leading: const Icon(Icons.exit_to_app),
              title: Text(
                "LogOut",
                style: buildTextStyle(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  TextStyle buildTextStyle() => const TextStyle(color: Colors.black);

}
