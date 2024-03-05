import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:setup/service/database_service.dart';
import 'package:setup/ui/chat/widgets/message_tile.dart';
import 'package:setup/ui/group_info/group_info_page.dart';

class ChatPage extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;

  const ChatPage(
      {super.key,
      required this.userName,
      required this.groupId,
      required this.groupName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController controller = TextEditingController();
  String admin = "";
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    super.initState();
    getChatAdmin();
  }

  getChatAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
        print("---------getChatAdmin---------$val-------------");
      });
    });
    DatabaseService().groupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.groupName),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => GroupInfoPage(
                        userName: widget.userName,
                        groupId: widget.groupId,
                        adminName: admin,
                        groupName: widget.groupName,
                      ),
                    ));
              },
              icon: const Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: [
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10).r,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: "Send a message...",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16.sp),
                        border: InputBorder.none),
                  )),
                  12.horizontalSpace,
                  InkWell(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 40.r,
                      width: 40.r,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(50).r),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        print(
            "--------------snapshot------------${snapshot.data}-----------------");
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  print(
                      "================${snapshot.data.docs.length}=================");
                  return MessageTile(
                      message: snapshot.data.docs[index]['message'],
                      sender: snapshot.data.docs[index]['sender'],
                      sentByMe: widget.userName ==
                          snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (controller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": controller.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        controller.clear();
      });
    }
  }
}
