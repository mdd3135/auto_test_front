import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/shortAnswer.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteShortAnswer extends StatefulWidget {
  const CompleteShortAnswer({super.key, required this.itemBank});

  final ItemBank itemBank;

  @override
  State<CompleteShortAnswer> createState() => _CompleteShortAnswerState();
}

class _CompleteShortAnswerState extends State<CompleteShortAnswer> {
  int ok = 0;
  late ShortAnswer shortAnswer;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    if (ok == 0) {
      return Container();
    }
    List<Widget> columns = [
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "题目类型：",
            style: MyTextStyle.textStyle,
          ),
          Text(
            "简答题",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
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
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "题目描述：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: Text(
          widget.itemBank.description,
          style: MyTextStyle.textStyle,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "题目内容：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: Text(
          shortAnswer.content,
          style: MyTextStyle.textStyle,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
    return Column(
      children: columns,
    );
  }

  initData() async {
    BotToast.showLoading();
    var response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getShortAnswerById?id=${widget.itemBank.questionId}",
      ),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> map = json.decode(bodyString);
    shortAnswer = ShortAnswer.objToShortAnswer(map);
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
