import 'dart:async';
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
  const CompleteShortAnswer(
      {super.key, required this.itemBank, required this.idx});

  final ItemBank itemBank;
  final int idx;

  @override
  State<CompleteShortAnswer> createState() => _CompleteShortAnswerState();
}

class _CompleteShortAnswerState extends State<CompleteShortAnswer> {
  int ok = 0;
  late ShortAnswer shortAnswer;
  int itemId = 0;
  late Timer timer;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) {
        if (itemId != widget.itemBank.id) {
          initData();
        }
      },
    );
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
      Row(
        children: [
          Text(
            "题目答案：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: TextFormField(
          maxLines: 10,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
          ),
          style: MyTextStyle.textStyle,
          controller: controller,
          onChanged: (value) {
            updateAnswer(value);
          },
        ),
      ),
    ];
    return Column(
      children: columns,
    );
  }

  updateAnswer(String text) {
    shortAnswer.answer = text;
    Status.completeHomework[widget.idx] = shortAnswer;
  }

  initData() async {
    BotToast.showLoading();
    itemId = widget.itemBank.id;
    if (Status.completeHomework.length > widget.idx) {
      shortAnswer = Status.completeHomework[widget.idx];
    } else {
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getShortAnswerById?id=${widget.itemBank.questionId}",
        ),
      );
      String bodyString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = json.decode(bodyString);
      shortAnswer = ShortAnswer.objToShortAnswer(map);
      shortAnswer.answer = "";
      Status.completeHomework.add(shortAnswer);
    }
    controller = TextEditingController(text: shortAnswer.answer);
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
