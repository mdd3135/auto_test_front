import 'dart:async';
import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/program.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteProgram extends StatefulWidget {
  const CompleteProgram({super.key, required this.itemBank, required this.idx});

  final ItemBank itemBank;
  final int idx;

  @override
  State<CompleteProgram> createState() => _CompleteProgramState();
}

class _CompleteProgramState extends State<CompleteProgram> {
  late Program program;
  int itemId = 0;
  int ok = 0;
  late Timer timer;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (itemId != widget.itemBank.id) {
        setState(() {});
      }
    });
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
            "编程题",
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
            "编程语言：",
            style: MyTextStyle.textStyle,
          ),
          Text(
            program.language,
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
          program.content,
          style: MyTextStyle.textStyle,
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
                  fontWeight: FontWeight.w500,
                  fontFamily: "nomo",
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "样例输出${i + 1}：",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
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
              width: 20,
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
    columns.addAll([
      const Row(
        children: [
          Text(
            "题目答案：",
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
        child: TextFormField(
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              gapPadding: 0,
            ),
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            fontFamily: "mono",
          ),
          controller: controller,
          onChanged: (value) {
            updateAnswer(value);
          },
        ),
      ),
    ]);
    return Column(
      children: columns,
    );
  }

  updateAnswer(String text) {
    program.answer = text;
    Status.completeHomework[widget.idx] = program;
  }

  initData() async {
    BotToast.showLoading();
    itemId = widget.itemBank.id;
    if (Status.completeHomework.length > widget.idx) {
      program = Status.completeHomework[widget.idx];
    } else {
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getProgramById?id=${widget.itemBank.questionId}",
        ),
      );
      String bodyString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> map = json.decode(bodyString);
      program = Program.objToProgram(map);
      program.answer = "";
      Status.completeHomework.add(program);
    }
    controller = TextEditingController(text: program.answer);
    ok = 1;
    BotToast.closeAllLoading();
    setState(() {});
  }
}
