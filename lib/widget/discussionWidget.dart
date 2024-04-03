import 'package:auto_test_front/entity/discussion.dart';
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
  String msg = "";

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
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
            child: ListView(
              shrinkWrap: true,
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
                    border: InputBorder.none,
                  ),
                  style: MyTextStyle.textStyle,
                  minLines: 5,
                  maxLines: 5,
                  onChanged: (value) {
                    msg = value;
                  },
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

  initData() {}

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
    initData();
    BotToast.closeAllLoading();
  }
}
