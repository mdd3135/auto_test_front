import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/program.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteProgram extends StatefulWidget {
  const FavoriteProgram(
      {super.key, required this.program, required this.itemBank});

  final Program program;
  final ItemBank itemBank;

  @override
  State<FavoriteProgram> createState() => _FavoriteProgramState();
}

class _FavoriteProgramState extends State<FavoriteProgram> {
  late Program program;
  int isFavorite = 1;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
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
          maxLines: 10,
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
    Status.favoriteItem = program;
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

  initData() {
    program = widget.program;
    program.answer = "";
    Status.favoriteItem = program;
    setState(() {});
  }
}
