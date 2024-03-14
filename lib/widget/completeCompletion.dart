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
  const CompleteCompletion(
      {super.key, required this.itemBank, required this.idx});
  final ItemBank itemBank;
  final int idx;

  @override
  State<CompleteCompletion> createState() => _CompleteCompletionState();
}

class _CompleteCompletionState extends State<CompleteCompletion> {
  late Completion completion;
  int itemId = 0;
  int ok = 0;
  late Timer timer;
  List<TextEditingController> controllerList = [];

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
      const SizedBox(height: 20),
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
    List<dynamic> answerList = jsonDecode(completion.answer);
    for (int i = 0; i < answerList.length; i++) {
      String answer = answerList[i];
      controllerList.add(
        TextEditingController(text: answer),
      );
      columns.addAll(
        [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Text(
                "第${i + 1}空答案",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          ShadowContainer(
            child: TextFormField(
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
              ),
              style: MyTextStyle.textStyle,
              controller: controllerList[i],
              onChanged: (value) {
                updateAnswer(i, value);
              },
            ),
          ),
        ],
      );
    }
    return Column(
      children: columns,
    );
  }

  updateAnswer(int idx, String text) {
    List<dynamic> answerList = jsonDecode(completion.answer);
    answerList[idx] = text;
    completion.answer = jsonEncode(answerList);
    Status.completeHomework[widget.idx] = completion;
  }

  initData() async {
    BotToast.showLoading();
    itemId = widget.itemBank.id;
    controllerList.clear();
    if (Status.completeHomework.length > widget.idx) {
      //已经存在了，不用再初始化题目
      completion = Status.completeHomework[widget.idx];
    } else {
      //初始化这道题目
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getCompletionById?id=${widget.itemBank.questionId}",
        ),
      );
      String bodyString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = json.decode(bodyString);
      completion = Completion.objToCompletion(map);
      List<dynamic> answerList = json.decode(completion.answer);
      for (int i = 0; i < answerList.length; i++) {
        answerList[i] = "";
      }
      completion.answer = json.encode(answerList);
      Status.completeHomework.add(completion);
    }
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
