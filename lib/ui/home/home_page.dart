import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/helper/helper_function.dart';
import 'package:setup/service/auth_service.dart';
import 'package:setup/service/database_service.dart';
import 'package:setup/ui/auth/user_login/user_login_page.dart';
import 'package:setup/ui/home/widget/group_tile.dart';
import 'package:setup/ui/profile/profile_page.dart';
import 'package:setup/ui/search/search_page.dart';
import 'package:setup/ws_cube/ui/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String userEmail = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunction.getUserEmailFromSF().then((value) {
      setState(() {
        userEmail = value!;
      });
    });

    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });

    // getting the list of snapshot in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

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
          "Chat",
          style: TextStyle(color: Colors.white, fontSize: 30.sp),
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
              userName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            30.verticalSpace,
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () {},
              selectedColor: Colors.orange,
              selected: true,
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
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(
                        userEmail: userEmail,
                        userName: userName,
                      ),
                    ));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5).r,
              leading: const Icon(Icons.person),
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
                                      builder: (context) =>
                                          const UserLoginPage(),
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

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  print("++++++++++++++${snapshot.data['fullName']}========================");
                  int reverse = snapshot.data['groups'].length - index - 1; // cool
                  return GroupTile(

                      groupId: getId(snapshot.data['groups'][reverse]),
                      groupName : getName(snapshot.data['groups'][reverse]),
                      userName: snapshot.data['fullName']);
                },
              );
            } else {
              return noGroupsWidget();
            }
          } else {
            return noGroupsWidget();
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  noGroupsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25).r,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              size: 75.r,
            ),
          ),
          20.verticalSpace,
          const Text(
            "You've not joined any groups, tap on the add icon to create group or also search from top searchbutton",
            style: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Create a group",
            style: buildTextStyle(),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _isLoading == true
                  ? const Center(
                      child: CircularProgressIndicator.adaptive(),
                    )
                  : TextFormField(
                      onChanged: (value) {
                        groupName = value;
                      },
                    )
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "CANCEL",
                  style: buildTextStyle(),
                )),
            ElevatedButton(
                onPressed: () async {
                  if (groupName != "") {
                    setState(() {
                      _isLoading = true;
                    });
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .createGroup(userName,
                            FirebaseAuth.instance.currentUser!.uid, groupName)
                        .whenComplete(() {
                      setState(() {
                        _isLoading = false;
                      });
                    });
                    Navigator.pop(context);
                    showSnackBar("Group created successfully");
                  }
                },
                child: Text(
                  "CREATE",
                  style: buildTextStyle(),
                )),
          ],
        );
      },
    );
  }

  TextStyle buildTextStyle() => const TextStyle(color: Colors.black);

  showSnackBar(String text) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
