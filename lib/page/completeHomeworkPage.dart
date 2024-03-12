import 'dart:convert';

import 'package:auto_test_front/entity/homework.dart';
import 'package:auto_test_front/entity/homeworkItem.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/completeChoice.dart';
import 'package:auto_test_front/widget/completeCompletion.dart';
import 'package:auto_test_front/widget/completeProgram.dart';
import 'package:auto_test_front/widget/completeShortAnswer.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteHomeworkPage extends StatefulWidget {
  const CompleteHomeworkPage({super.key, required this.homework});

  final Homework homework;

  @override
  State<CompleteHomeworkPage> createState() => _CompleteHomeworkPageState();
}

class _CompleteHomeworkPageState extends State<CompleteHomeworkPage> {
  List<ItemBank> itemBankList = [];
  int ok = 0;
  int currentItem = 1;
  int submitCount = 0;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(context, "完成作业", null),
      body: Center(
        child: SizedBox(
          width: 800,
          child: bodyDetail(),
        ),
      ),
    );
  }

  initData() async {
    BotToast.showLoading();
    var response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getHomeworkItemByHomeworkId?homeworkId=${widget.homework.id}",
      ),
    );
    List<dynamic> responseObj = json.decode(utf8.decode(response.bodyBytes));
    for (int i = 0; i < responseObj.length; i++) {
      HomeworkItem homeworkItem =
          HomeworkItem.objToHomeworkItem(responseObj[i]);
      var response2 = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getItemBankById?id=${homeworkItem.itemId}",
        ),
      );
      Map<String, dynamic> responseObj2 = json.decode(
        utf8.decode(response2.bodyBytes),
      );
      ItemBank itemBank = ItemBank.objToItemBank(responseObj2);
      itemBankList.add(itemBank);
    }
    response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getSubmitCountByUserIdAndHomeworkId?"
        "userId=${Status.user.id}&homeworkId=${widget.homework.id}",
      ),
    );
    submitCount = int.parse(utf8.decode(response.bodyBytes));
    if (submitCount >= widget.homework.count) {
      BotToast.showText(text: "已用完提交次数，因此本次提交不计入总成绩");
    }
    if (widget.homework.deadline
            .compareTo(DateTime.now().millisecondsSinceEpoch.toString()) <
        0) {
      BotToast.showText(text: "已超过截止时间，因此本次提交不计入总成绩");
    }
    ok = 1;
    BotToast.closeAllLoading();
  }

  bodyDetail() {
    if (ok != 1) {
      return;
    }
    ItemBank itemBank = itemBankList[currentItem - 1];
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              "第 $currentItem/${itemBankList.length} 题",
              style: MyTextStyle.textStyle,
            ),
            const SizedBox(width: 20),
            Text(
              "可提交 $submitCount/${widget.homework.count} 次",
              style: MyTextStyle.textStyle,
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (itemBank.type == 1)
          CompleteChoice(itemBank: itemBank)
        else if (itemBank.type == 2)
          CompleteCompletion(itemBank: itemBank)
        else if (itemBank.type == 3)
          CompleteShortAnswer(itemBank: itemBank)
        else
          CompleteProgram(itemBank: itemBank),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                preItem();
              },
              child: Text(
                "上一题",
                style: MyTextStyle.textStyle,
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                nextItem();
              },
              child: Text(
                "下一题",
                style: MyTextStyle.textStyle,
              ),
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () {
                submit();
              },
              child: Text(
                "提交",
                style: MyTextStyle.textStyle,
              ),
            )
          ],
        )
      ],
    );
  }

  preItem() {
    if (currentItem <= 1) {
      BotToast.showText(text: "已经是第一题了");
      return;
    }
    currentItem--;
    setState(() {});
  }

  nextItem() {
    if (currentItem >= itemBankList.length) {
      BotToast.showText(text: "已经是最后一题了");
      return;
    }
    currentItem++;
    setState(() {});
  }

  submit() {}
}
