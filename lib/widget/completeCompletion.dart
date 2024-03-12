import 'dart:async';
import 'dart:convert';

import 'package:auto_test_front/entity/completion.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteCompletion extends StatefulWidget {
  const CompleteCompletion({super.key, required this.itemBank});
  final ItemBank itemBank;

  @override
  State<CompleteCompletion> createState() => _CompleteCompletionState();
}

class _CompleteCompletionState extends State<CompleteCompletion> {
  late Completion completion;
  int itemId = 0;
  int ok = 0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    initData();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (itemId != widget.itemBank.id) {
          initData();
        }
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ok == 0) {
      return Container();
    }
    List<Widget> columns = [
      const SizedBox(height: 40),
      Row(
        children: [
          Text(
            "题目类型：",
            style: MyTextStyle.textStyle,
          ),
          Text(
            "填空题",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            "分值：",
            style: MyTextStyle.textStyle,
          ),
          Text(
            widget.itemBank.score.toString(),
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            "题目描述：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(height: 5),
      ShadowContainer(
        child: Text(
          widget.itemBank.description,
          style: MyTextStyle.textStyle,
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            "题目内容：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(height: 5),
      ShadowContainer(
        child: Text(
          completion.content,
          style: MyTextStyle.textStyle,
        ),
      ),
    ];
    return Column(
      children: columns,
    );
  }

  initData() async {
    itemId = widget.itemBank.id;
    BotToast.showLoading();
    var response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getCompletionById?id=${widget.itemBank.questionId}",
      ),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> map = json.decode(bodyString);
    completion = Completion.objToCompletion(map);
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
