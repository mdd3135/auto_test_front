import 'dart:convert';

import 'package:auto_test_front/entity/completion.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteCompletion extends StatefulWidget {
  const FavoriteCompletion({
    super.key,
    required this.completion,
    required this.itemBank,
    required this.isSubmited,
  });
  final Completion completion;
  final ItemBank itemBank;
  final int isSubmited;

  @override
  State<FavoriteCompletion> createState() => _FavoriteCompletionState();
}

class _FavoriteCompletionState extends State<FavoriteCompletion> {
  late Completion completion;
  int isFavorite = 1;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> columns = [
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
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
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            "题目描述：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(height: 5),
      ShadowContainer(
        child: Text(
          widget.itemBank.description,
          style: MyTextStyle.textStyle,
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Text(
            "题目内容：",
            style: MyTextStyle.textStyle,
          ),
        ],
      ),
      const SizedBox(height: 5),
      ShadowContainer(
        child: Text(
          completion.content,
          style: MyTextStyle.textStyle,
        ),
      ),
    ];
    List<dynamic> answerList = jsonDecode(completion.answer);
    for (int i = 0; i < answerList.length; i++) {
      if (widget.isSubmited == 1) {
        break;
      }
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
            child: TextFormField(
              maxLines: 1,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  gapPadding: 0,
                ),
              ),
              style: MyTextStyle.textStyle,
              onChanged: (value) {
                updateAnswer(i, value);
              },
            ),
          ),
        ],
      );
    }
    return Column(
      children: columns,
    );
  }

  initData() {
    completion = widget.completion;
    List<dynamic> answerList = jsonDecode(completion.answer);
    for (int i = 0; i < answerList.length; i++) {
      answerList[i] = "";
    }
    completion.answer = jsonEncode(answerList);
    Status.favoriteItem = completion;
  }

  updateAnswer(int idx, String text) {
    List<dynamic> answerList = jsonDecode(completion.answer);
    answerList[idx] = text;
    completion.answer = jsonEncode(answerList);
    Status.favoriteItem = completion;
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
