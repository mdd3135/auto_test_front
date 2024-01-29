import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/program.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:http/http.dart' as http;

class ProgramPage extends StatefulWidget {
  const ProgramPage({super.key, required this.itemBank});

  final ItemBank itemBank;

  @override
  State<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends State<ProgramPage> {
  int ok = 0;
  late Program program;

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
            "编程题",
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
      Row(
        children: [
          const Text(
            "编程语言：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            program.language,
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
          program.content,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
    List<dynamic> input = jsonDecode(program.input);
    List<dynamic> output = jsonDecode(program.output);
    for (int i = 0; i < input.length; i++) {
      columns.addAll([
        Row(
          children: [
            Expanded(
              child: Text(
                "样例输入${i + 1}：",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "nomo",
                ),
              ),
            ),
            Expanded(
              child: Text(
                "样例输出${i + 1}：",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "nomo",
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: ShadowContainer(
                child: Text(
                  input[i],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: "mono",
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ShadowContainer(
                child: Text(
                  output[i],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: "mono",
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ]);
    }
    columns.addAll(
      [
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
            program.answer,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              fontFamily: "mono",
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
            program.analysis,
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
        "${Status.baseUrl}/getProgramById?id=${widget.itemBank.questionId}",
      ),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    Map<String, dynamic> map = json.decode(bodyString);
    program = Program.objToProgram(map);
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
