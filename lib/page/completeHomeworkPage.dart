import 'dart:convert';

import 'package:auto_test_front/entity/homework.dart';
import 'package:auto_test_front/entity/homeworkItem.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/result.dart';
import 'package:auto_test_front/entity/submit.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/completeChoice.dart';
import 'package:auto_test_front/widget/completeCompletion.dart';
import 'package:auto_test_front/widget/completeProgram.dart';
import 'package:auto_test_front/widget/completeShortAnswer.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CompleteHomeworkPage extends StatefulWidget {
  const CompleteHomeworkPage({
    super.key,
    required this.homework,
    required this.isSubmited,
    required this.resultList,
  });

  final Homework homework;
  final int isSubmited;
  final List<Result> resultList;

  @override
  State<CompleteHomeworkPage> createState() => _CompleteHomeworkPageState();
}

class _CompleteHomeworkPageState extends State<CompleteHomeworkPage> {
  List<ItemBank> itemBankList = [];
  List<Result> resultList = [];
  int isSubmited = 0;
  int ok = 0;
  int currentItem = 1;
  int submitCount = 0;
  List<int> isfavoriteList = [];

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
        widget.isSubmited == 0 ? "完成作业" : "提交详情",
        null,
      ),
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
    Status.completeHomework.clear();
    isSubmited = widget.isSubmited;
    if (isSubmited == 1) {
      resultList = widget.resultList;
    }
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
      response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/checkCollectByUserIdAndItemId?"
          "userId=${Status.user.id}&itemId=${itemBank.id}",
        ),
      );
      isfavoriteList.add(jsonDecode(utf8.decode(response.bodyBytes)));
    }
    response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getSubmitCountByUserIdAndHomeworkId?"
        "userId=${Status.user.id}&homeworkId=${widget.homework.id}",
      ),
    );
    submitCount = int.parse(utf8.decode(response.bodyBytes));
    if (isSubmited == 0 && submitCount >= widget.homework.count) {
      BotToast.showText(text: "已用完提交次数，因此本次提交不计入总成绩");
    }
    if (isSubmited == 0 &&
        widget.homework.deadline
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
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
            const Expanded(child: Text("")),
            IconButton(
              onPressed: () {
                onFavoritePressed(currentItem - 1);
              },
              icon: Icon(
                isfavoriteList[currentItem - 1] == 0
                    ? Icons.favorite_border
                    : Icons.favorite,
                color: Colors.red,
                size: 30,
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        if (itemBank.type == 1)
          CompleteChoice(
            itemBank: itemBank,
            idx: currentItem - 1,
          )
        else if (itemBank.type == 2)
          CompleteCompletion(
            itemBank: itemBank,
            idx: currentItem - 1,
            isSubmited: isSubmited,
          )
        else if (itemBank.type == 3)
          CompleteShortAnswer(
            itemBank: itemBank,
            idx: currentItem - 1,
            isSubmited: isSubmited,
          )
        else
          CompleteProgram(
            itemBank: itemBank,
            idx: currentItem - 1,
            isSubmited: isSubmited,
          ),
        const SizedBox(height: 20),
        if (isSubmited == 1)
          Row(
            children: [
              Text(
                "得分：",
                style: MyTextStyle.colorTextStyle,
              ),
              Text(
                resultList[currentItem - 1].score.toString(),
                style: MyTextStyle.colorTextStyle,
              ),
            ],
          ),
        if (isSubmited == 1)
          const SizedBox(
            height: 20,
          ),
        if (isSubmited == 1)
          ShadowContainer(
            child: Text(
              resultList[currentItem - 1].feedback,
              style: MyTextStyle.colorTextStyle,
            ),
          ),
        if (isSubmited == 1)
          const SizedBox(
            height: 20,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentItem != 1)
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
            if (currentItem != itemBankList.length)
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
            if (currentItem == itemBankList.length && isSubmited == 0)
              ElevatedButton(
                onPressed: () {
                  onSubmitPressed();
                },
                child: Text(
                  "提交",
                  style: MyTextStyle.textStyle,
                ),
              )
          ],
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  onFavoritePressed(int idx) async {
    BotToast.showLoading();
    if (isfavoriteList[idx] == 0) {
      await http.post(
        Uri.parse("${Status.baseUrl}/addCollect"),
        body: {
          "userId": Status.user.id.toString(),
          "itemId": itemBankList[idx].id.toString(),
        },
      );
      BotToast.showText(text: "收藏题目成功");
      isfavoriteList[idx] = 1;
    } else {
      await http.post(
        Uri.parse("${Status.baseUrl}/deleteCollectByUserIdAndItemId"),
        body: {
          "userId": Status.user.id.toString(),
          "itemId": itemBankList[idx].id.toString(),
        },
      );
      BotToast.showText(text: "取消收藏题目成功");
      isfavoriteList[idx] = 0;
    }
    setState(() {});
    BotToast.closeAllLoading();
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

  onSubmitPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "提示",
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          content: Text(
            "确定要提交这个作业的所有题目吗？",
            style: MyTextStyle.textStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "取消",
                style: MyTextStyle.textStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                submit();
              },
              child: Text(
                "确定",
                style: MyTextStyle.textStyle,
              ),
            ),
          ],
        );
      },
    );
  }

  submit() async {
    BotToast.showLoading();
    resultList.clear();
    var response = await http.post(
      Uri.parse("${Status.baseUrl}/submitHomework"),
      body: {
        "userId": Status.user.id.toString(),
        "homeworkId": widget.homework.id.toString(),
      },
    );
    var bodyObj = jsonDecode(utf8.decode(response.bodyBytes));
    Submit submit = Submit.objToSubmit(bodyObj);
    for (int i = 0; i < itemBankList.length; i++) {
      response = await http.post(
        Uri.parse("${Status.baseUrl}/submitHomeworkItem"),
        body: {
          "answer": Status.completeHomework[i].answer,
          "submitId": submit.id.toString(),
          "itemId": itemBankList[i].id.toString(),
        },
      );
      bodyObj = jsonDecode(utf8.decode(response.bodyBytes));
      Result result = Result.objToResult(bodyObj);
      resultList.add(result);
    }
    isSubmited = 1;
    setState(() {});
    BotToast.closeAllLoading();
  }
}
