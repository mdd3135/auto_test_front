import 'dart:convert';

import 'package:auto_test_front/entity/discussion.dart';
import 'package:auto_test_front/entity/user.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class DiscussionWidget extends StatefulWidget {
  const DiscussionWidget({super.key, required this.homeworkId});

  final int homeworkId;

  @override
  State<DiscussionWidget> createState() => _DiscussionWidgetState();
}

class _DiscussionWidgetState extends State<DiscussionWidget> {
  List<Discussion> discussionList = [];
  List<User> senderList = [];
  List<Widget> discussionTileList = [];
  String msg = "";
  ScrollController scrollController = ScrollController();
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "讨论区：",
          style: MyTextStyle.textStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        ShadowContainer(
          child: SizedBox(
            height: 600,
            child: ListView.builder(
              itemCount: discussionList.length,
              itemBuilder: (BuildContext context, int index) {
                return discussionTileList[index];
              },
              controller: scrollController,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ShadowContainer(
          child: SizedBox(
            height: 160,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: "在此输入您想发送的内容",
                    border: InputBorder.none,
                  ),
                  style: MyTextStyle.textStyle,
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (value) {
                    msg = value;
                  },
                  controller: textEditingController,
                ),
                ElevatedButton(
                  onPressed: () {
                    onSendDiscussionPressed(msg);
                  },
                  child: Text(
                    "发送",
                    style: MyTextStyle.textStyle,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  initData() async {
    BotToast.showLoading();
    discussionList.clear();
    senderList.clear();
    discussionTileList.clear();
    var response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/findDiscussionByHomeworkId?"
        "homeworkId=${widget.homeworkId}",
      ),
    );
    List<dynamic> objList = jsonDecode(utf8.decode(response.bodyBytes));
    for (int i = 0; i < objList.length; i++) {
      Discussion discussion = Discussion.objToDiscussion(objList[i]);
      var response2 = await http.get(
        Uri.parse(
          "${Status.baseUrl}/findUserById?id=${discussion.userId}",
        ),
      );
      User user = User.objToUser(jsonDecode(utf8.decode(response2.bodyBytes)));
      senderList.add(user);
      discussionList.add(discussion);
    }
    // ok = 1;
    initDiscussionTileList();
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      },
    );
    BotToast.closeAllLoading();
  }

  initDiscussionTileList() {
    for (int i = 0; i < discussionList.length; i++) {
      ListTile listTile = ListTile(
        leading: Text("${senderList[i].name}:"),
        leadingAndTrailingTextStyle: MyTextStyle.colorTextStyle,
        title: Text(
          discussionList[i].content,
          style: MyTextStyle.textStyle,
        ),
      );
      discussionTileList.add(listTile);
    }
    setState(() {});
  }

  onSendDiscussionPressed(String msg) {
    BotToast.showLoading();
    BotToast.showText(text: "发送成功");
    http.post(
      Uri.parse("${Status.baseUrl}/addDiscussion"),
      body: {
        "homeworkId": widget.homeworkId.toString(),
        "userId": Status.user.id.toString(),
        "content": msg,
        "isTop": "0",
      },
    );
    discussionTileList.add(ListTile(
      leading: Text("${Status.user.name}:"),
      leadingAndTrailingTextStyle: MyTextStyle.colorTextStyle,
      title: Text(
        msg,
        style: MyTextStyle.textStyle,
      ),
    ));
    senderList.add(Status.user);
    discussionList.add(Discussion(0, 0, Status.user.id, msg, 0));
    setState(() {});
    Future.delayed(
      const Duration(milliseconds: 100),
      () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      },
    );
    textEditingController.clear();
    BotToast.closeAllLoading();
  }
}
