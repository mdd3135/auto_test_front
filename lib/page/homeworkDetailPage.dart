import 'dart:convert';

import 'package:auto_test_front/entity/homework.dart';
import 'package:auto_test_front/entity/homeworkItem.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/page/choiceDetail.dart';
import 'package:auto_test_front/page/completionDetail.dart';
import 'package:auto_test_front/page/programPage.dart';
import 'package:auto_test_front/page/shortAnswerPage.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/discussionWidget.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeworkDetailPage extends StatefulWidget {
  const HomeworkDetailPage({super.key, required this.homework});

  final Homework homework;

  @override
  State<HomeworkDetailPage> createState() => _HomeworkDetailPageState();
}

class _HomeworkDetailPageState extends State<HomeworkDetailPage> {
  List<ItemBank> itemBankList = [];

  @override
  void initState() {
    super.initState();
    initDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(
        context,
        "作业详情",
        null,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 400,
                  child: bodyDetail(),
                ),
                const SizedBox(width: 40),
                SizedBox(
                  width: 400,
                  child: DiscussionWidget(
                    homeworkId: widget.homework.id,
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "确认",
                  style: MyTextStyle.textStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bodyDetail() {
    DateTime createTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.homework.createTime));
    DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
        int.parse(widget.homework.deadline));
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "作业名称：${widget.homework.homeworkName}",
              style: MyTextStyle.textStyle,
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "可提交次数：${widget.homework.count}",
          style: MyTextStyle.textStyle,
        ),
        const SizedBox(height: 20),
        Text(
          "作业开始时间：${createTime.toString().substring(0, 16)}",
          style: MyTextStyle.textStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          "作业结束时间：${deadline.toString().substring(0, 16)}",
          style: MyTextStyle.textStyle,
        ),
        const SizedBox(height: 20),
        Text(
          "已选择题目：共 ${itemBankList.length} 题",
          style: MyTextStyle.textStyle,
        ),
        const SizedBox(height: 20),
        ShadowContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 600),
            child: ListView.builder(
              itemCount: itemBankList.length,
              itemBuilder: (context, index) {
                ItemBank itemBank = itemBankList[index];
                String type = "";
                if (itemBank.type == 1) {
                  type = "选择题";
                } else if (itemBank.type == 2) {
                  type = "填空题";
                } else if (itemBank.type == 3) {
                  type = "简答题";
                } else if (itemBank.type == 4) {
                  type = "编程题";
                }
                return ListTile(
                  leading: Text(
                    type,
                    style: MyTextStyle.textStyle,
                  ),
                  title: Text(
                    itemBank.description,
                    style: MyTextStyle.textStyle,
                  ),
                  trailing: Text(
                    itemBank.score.toStringAsFixed(1),
                    style: MyTextStyle.textStyle,
                  ),
                  onTap: Status.user.type == 1
                      ? () {
                          showItemDetailPressed(itemBank);
                        }
                      : null,
                );
              },
            ),
          ),
        )
      ],
    );
  }

  initDate() async {
    BotToast.showLoading();
    var response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getHomeworkItemByHomeworkId?homeworkId=${widget.homework.id}",
      ),
    );
    List<dynamic> bodyObj = json.decode(utf8.decode(response.bodyBytes));
    for (int i = 0; i < bodyObj.length; i++) {
      HomeworkItem homeworkItem = HomeworkItem.objToHomeworkItem(bodyObj[i]);
      var response2 = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getItemBankById?id=${homeworkItem.itemId}",
        ),
      );
      Map<String, dynamic> bodyObj2 = json.decode(
        utf8.decode(response2.bodyBytes),
      );
      itemBankList.add(ItemBank.objToItemBank(bodyObj2));
    }
    BotToast.closeAllLoading();
  }

  showItemDetailPressed(ItemBank itemBank) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      if (itemBank.type == 1) {
        return ChoiceDetail(
          itemBank: itemBank,
        );
      } else if (itemBank.type == 2) {
        return CompletionDetail(
          itemBank: itemBank,
        );
      } else if (itemBank.type == 3) {
        return ShortAnswerPage(
          itemBank: itemBank,
        );
      } else if (itemBank.type == 4) {
        return ProgramPage(
          itemBank: itemBank,
        );
      }
      return Container();
    }));
  }
}
