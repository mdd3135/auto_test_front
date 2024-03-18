import 'dart:convert';

import 'package:auto_test_front/entity/choice.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteChoice extends StatefulWidget {
  const FavoriteChoice(
      {super.key, required this.choice, required this.itemBank});

  final Choice choice;
  final ItemBank itemBank;

  @override
  State<FavoriteChoice> createState() => _FavoriteChoiceState();
}

class _FavoriteChoiceState extends State<FavoriteChoice> {
  late Choice choice;
  int isFavorite = 1;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    String subType = choice.isMultiple == 1 ? "多选" : "单选";
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
            "选择题（$subType）",
            style: MyTextStyle.textStyle,
          ),
          const Expanded(
            child: Text(""),
          ),
          IconButton(
            onPressed: () {
              onFavoritePressed();
            },
            icon: Icon(
              isFavorite == 0 ? Icons.favorite_border : Icons.favorite,
              color: Colors.red,
              size: 30,
            ),
          )
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
          choice.content,
          style: MyTextStyle.textStyle,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Text(
            "选项：",
            style: MyTextStyle.textStyle,
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
          child: InkWell(
            onTap: () {
              onSelectAnswer(key);
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "$key：${optionMap[key]}",
                    textAlign: TextAlign.left,
                    style: MyTextStyle.textStyle,
                  ),
                ),
                if (isTrue)
                  const Icon(
                    Icons.check,
                  )
              ],
            ),
          ),
        ),
      );
    }
    columns.addAll(
      [
        ShadowContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: textList,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
    return Column(
      children: columns,
    );
  }

  initData() {
    choice = widget.choice;
    choice.answer = "[]";
    Status.favoriteItem = choice;
    setState(() {});
  }

  onSelectAnswer(String key) {
    if (choice.isMultiple == 0) {
      choice.answer = "[\"$key\"]";
    } else {
      List<dynamic> answerList = jsonDecode(choice.answer);
      if (answerList.contains(key)) {
        answerList.remove(key);
      } else {
        answerList.add(key);
      }
      choice.answer = jsonEncode(answerList);
    }
    Status.favoriteItem = choice;
    setState(() {});
  }

  onFavoritePressed() async {
    BotToast.showLoading();
    if (isFavorite == 0) {
      await http.post(
        Uri.parse("${Status.baseUrl}/addCollect"),
        body: {
          "userId": Status.user.id.toString(),
          "itemId": widget.itemBank.id.toString(),
        },
      );
      BotToast.showText(text: "收藏题目成功");
      isFavorite = 1;
    } else {
      await http.post(
        Uri.parse("${Status.baseUrl}/deleteCollectByUserIdAndItemId"),
        body: {
          "userId": Status.user.id.toString(),
          "itemId": widget.itemBank.id.toString(),
        },
      );
      BotToast.showText(text: "取消收藏题目成功");
      isFavorite = 0;
    }
    setState(() {});
    BotToast.closeAllLoading();
  }
}
