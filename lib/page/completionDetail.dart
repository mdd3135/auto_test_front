import 'dart:convert';

import 'package:auto_test_front/entity/completion.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompletionDetail extends StatefulWidget {
  const CompletionDetail({super.key, required this.itemBank});
  final ItemBank itemBank;

  @override
  State<CompletionDetail> createState() => _CompletionDetailState();
}

class _CompletionDetailState extends State<CompletionDetail> {
  late Completion completion;
  int ok = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(
        context,
        "题目详情",
        null,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            child: detailBody(),
            width: 800,
          ),
        ),
      ),
    );
  }

  detailBody() {
    if (ok == 0) {
      return;
    }
    List<Widget> columns = [
      const SizedBox(
        height: 40,
      ),
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
          completion.content,
          style: MyTextStyle.textStyle,
        ),
      ),
    ];
    String answerString = completion.answer;
    List<dynamic> answerList = jsonDecode(answerString);
    for (int i = 0; i < answerList.length; i++) {
      String answer = answerList[i];
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
            child: Text(
              answer,
              style: MyTextStyle.textStyle,
            ),
          ),
        ],
      );
    }
    columns.addAll(
      [
        const SizedBox(
          height: 20,
        ),
        const Row(
          children: [
            Text(
              "解析：",
              style: TextStyle(
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
          child: Text(
            completion.analysis,
            style: MyTextStyle.textStyle,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
    return Column(
      children: columns,
    );
  }

  initData() async {
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
