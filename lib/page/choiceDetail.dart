import 'dart:convert';

import 'package:auto_test_front/entity/choice.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;

class ChoiceDetail extends StatefulWidget {
  const ChoiceDetail({super.key, required this.itemBank});

  final ItemBank itemBank;

  @override
  State<ChoiceDetail> createState() => _ChoiceDetailState();
}

class _ChoiceDetailState extends State<ChoiceDetail> {
  int ok = 0;
  late Choice choice;

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
          child: SizedBox(child: detailBody(), width: 800),
        ),
      ),
    );
  }

  detailBody() {
    if (ok == 0) {
      return;
    }
    String subType = choice.isMultiple == 1 ? "多选" : "单选";
    List<Widget> columns = [
      const SizedBox(
        height: 40,
      ),
      Row(
        children: [
          const Text(
            "题目类型：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "选择题（$subType）",
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
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          color: Theme.of(context).colorScheme.background,
        ),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(
          minWidth: 800,
        ),
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
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          color: Theme.of(context).colorScheme.background,
        ),
        padding: const EdgeInsets.all(10),
        constraints: const BoxConstraints(minWidth: 800),
        child: Text(
          choice.content,
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
            "选项：",
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
    ];
    List<dynamic> answerList = jsonDecode(choice.answer);
    Map<String, dynamic> optionMap = jsonDecode(choice.options);
    List<Widget> textList = [];
    for (String key in optionMap.keys) {
      bool isTrue = false;
      if (answerList.contains(key)) {
        isTrue = true;
      }
      textList.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: isTrue
                ? Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5)
                : Theme.of(context).colorScheme.background,
          ),
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  "$key：${optionMap[key]}",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                ),
              ),
              if (isTrue)
                const Icon(
                  Icons.check,
                )
            ],
          ),
        ),
      );
    }
    columns.addAll(
      [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            color: Theme.of(context).colorScheme.background,
          ),
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(minWidth: 800),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: textList,
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            color: Theme.of(context).colorScheme.background,
          ),
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints(minWidth: 800),
          child: Text(
            choice.analysis,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
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
        "${Status.baseUrl}/getChoiceById?id=${widget.itemBank.questionId}",
      ),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> map = json.decode(bodyString);
    choice = Choice.objToChoice(map);
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
