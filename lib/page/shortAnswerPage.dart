import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/shortAnswer.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;

class ShortAnswerPage extends StatefulWidget {
  const ShortAnswerPage({super.key, required this.itemBank});

  final ItemBank itemBank;

  @override
  State<ShortAnswerPage> createState() => _ShortAnswerPageState();
}

class _ShortAnswerPageState extends State<ShortAnswerPage> {
  int ok = 0;
  late ShortAnswer shortAnswer;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "题目详情",
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () {
              windowManager.minimize();
            },
            icon: const Icon(Icons.remove),
          ),
          const SizedBox(
            width: 10,
          ),
          IconButton(
            onPressed: () {
              windowManager.close();
            },
            icon: const Icon(Icons.close),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
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
      const Row(
        children: [
          Text(
            "题目类型：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "简答题",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          const Text(
            "分值：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            widget.itemBank.score.toString(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      const Row(
        children: [
          Text(
            "题目描述：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: Text(
          widget.itemBank.description,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      const Row(
        children: [
          Text(
            "题目内容：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: Text(
          shortAnswer.content,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      const Row(
        children: [
          Text(
            "题目答案：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: Text(
          shortAnswer.answer,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      const Row(
        children: [
          Text(
            "解析：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      const SizedBox(
        height: 5,
      ),
      ShadowContainer(
        child: Text(
          shortAnswer.analysis,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
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
