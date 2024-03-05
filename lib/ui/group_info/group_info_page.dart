import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/service/database_service.dart';

class GroupInfoPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String adminName;
  final String groupName;

  const GroupInfoPage(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.adminName,
      required this.groupName});

  @override
  State<GroupInfoPage> createState() => _GroupInfoPageState();
}

class _GroupInfoPageState extends State<GroupInfoPage> {
  Stream? members;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMembers();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        members = value;
      });
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
        title: const Text('Group Info'),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20).r,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20).r,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30).r,
                  color: Colors.orange.withOpacity(0.2)),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: Colors.orange,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 12.sp),
                    ),
                  ),
                  20.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(color: Colors.black, fontSize: 15.sp),
                      ),
                      5.verticalSpace,
                      Text("Admin: ${getName(widget.adminName)}",
                          style:
                              TextStyle(color: Colors.black, fontSize: 15.sp))
                    ],
                  ),
                ],
              ),
            ),
            memberList()
          ],
        ),
      ),
    );
  }

  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10)
                            .r,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30.r,
                        backgroundColor: Colors.orange,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toLowerCase(),
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.bold,color: Colors.white),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  "NO MEMBERS",
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                ),
              );
            }
          } else {
            return Center(
              child: Text(
                "NO MEMBERS",
                style: TextStyle(color: Colors.black, fontSize: 20.sp),
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }
}
