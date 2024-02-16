import 'dart:convert';

import 'package:auto_test_front/entity/homework.dart';
import 'package:auto_test_front/entity/homeworkItem.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
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
    await initItem(itemBankList[0]);
    BotToast.closeAllLoading();
  }

  initItem(ItemBank itemBank) async {}

  bodyDetail() {
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
        )
      ],
    );
  }
}
