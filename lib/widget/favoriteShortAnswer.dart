import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/shortAnswer.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteShortAnswer extends StatefulWidget {
  const FavoriteShortAnswer({
    super.key,
    required this.shortAnswer,
    required this.itemBank,
    required this.isSubmited,
  });

  final ShortAnswer shortAnswer;
  final ItemBank itemBank;
  final int isSubmited;

  @override
  State<FavoriteShortAnswer> createState() => _FavoriteShortAnswerState();
}

class _FavoriteShortAnswerState extends State<FavoriteShortAnswer> {
  late ShortAnswer shortAnswer;
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
            "简答题",
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
          shortAnswer.content,
          style: MyTextStyle.textStyle,
        ),
      ),
      const SizedBox(
        height: 20,
      ),
    ];
    if (widget.isSubmited == 0) {
      columns.addAll([
        Row(
          children: [
            Text(
              "题目答案：",
              style: MyTextStyle.textStyle,
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
            style: MyTextStyle.textStyle,
            onChanged: (value) {
              updateAnswer(value);
            },
          ),
        ),
      ]);
    }
    return Column(
      children: columns,
    );
  }

  initData() {
    shortAnswer = widget.shortAnswer;
    shortAnswer.answer = "";
    Status.favoriteItem = shortAnswer;
  }

  updateAnswer(String text) {
    shortAnswer.answer = text;
    Status.favoriteItem = shortAnswer;
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
