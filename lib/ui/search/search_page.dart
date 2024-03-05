import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/helper/helper_function.dart';
import 'package:setup/service/database_service.dart';
import 'package:setup/ui/chat/chat_page.dart';
import 'package:setup/widgets/app_text_field.dart';

import '../../widgets/base_app_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  bool _isLoading = false;
  bool isJoined = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserIdAndName();
  }

  getCurrentUserIdAndName() async {
    await HelperFunction.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
      user = FirebaseAuth.instance.currentUser;
    });
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search",
          style: TextStyle(color: Colors.white, fontSize: 20.sp),
        ),
        automaticallyImplyLeading: true,
        backgroundColor: Colors.orange,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10).r,
            child: Row(
              children: [
                Expanded(
                    child: AppTextField(
                  controller: searchController,
                  hintText: "Search groups....",
                  style: const TextStyle(color: Colors.white),
                  suffixIcon: IconButton(
                    onPressed: () {
                      initiateSearchMethod();
                    },
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12).r,
                ))
              ],
            ),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator.adaptive(),
                )
              : groupList()
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]["groupId"],
                searchSnapshot!.docs[index]["groupName"],
                searchSnapshot!.docs[index]["admin"],
              );
            },
          )
        : Container();
  }

  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        isJoined = value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5).r,
      leading: CircleAvatar(
        radius: 30.r,
        backgroundColor: Colors.orange,
        child: Text(
          groupName.substring(0, 1).toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        groupName,
        style:
            const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Admin: ${getName(admin)}',
        style: TextStyle(color: Colors.black.withOpacity(0.5)),
      ),
      trailing: InkWell(
          onTap: () async {
            await DatabaseService(uid: user!.uid)
                .toggleGroupJoin(groupName, groupId, userName);
            if (isJoined) {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar("Joined Group");
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                            userName: userName,
                            groupId: groupId,
                            groupName: groupName),
                      ));
                },
              );
            } else {
              setState(() {
                isJoined = !isJoined;
              });
              showSnackBar("Left Group");
            }
          },
          child: isJoined
              ? Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                          .r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10).r,
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Text(
                    "Joined",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10)
                          .r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10).r,
                    color: Colors.orange,
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Text(
                    "Join Now",
                    style: TextStyle(color: Colors.white),
                  ),
                )),
    );
  }

  showSnackBar(String text) {
    return ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
