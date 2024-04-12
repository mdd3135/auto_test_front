import 'dart:convert';

import 'package:auto_test_front/entity/choice.dart';
import 'package:auto_test_front/entity/completion.dart';
import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/program.dart';
import 'package:auto_test_front/entity/result.dart';
import 'package:auto_test_front/entity/shortAnswer.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/favoriteChoice.dart';
import 'package:auto_test_front/widget/favoriteCompletion.dart';
import 'package:auto_test_front/widget/favoriteProgram.dart';
import 'package:auto_test_front/widget/favoriteShortAnswer.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoriteDetailPage extends StatefulWidget {
  const FavoriteDetailPage({
    super.key,
    required this.itemBank,
    required this.isSubmited,
    required this.result,
  });

  final ItemBank itemBank;
  final int isSubmited;
  final Result result;

  @override
  State<FavoriteDetailPage> createState() => _FavoriteDetailPageState();
}

class _FavoriteDetailPageState extends State<FavoriteDetailPage> {
  int ok = 0;
  int isSubmited = 0;
  late Result result;
  late Completion completion;
  late Choice choice;
  late ShortAnswer shortAnswer;
  late Program program;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(context, "收藏的题目", null),
      body: Center(
        child: SizedBox(
          width: 800,
          child: bodyDetail(),
        ),
      ),
    );
  }

  bodyDetail() {
    if (ok == 0) {
      return;
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      children: [
        const SizedBox(height: 20),
        if (widget.itemBank.type == 1)
          FavoriteChoice(
            choice: choice,
            itemBank: widget.itemBank,
          )
        else if (widget.itemBank.type == 2)
          FavoriteCompletion(
            completion: completion,
            itemBank: widget.itemBank,
            isSubmited: isSubmited,
          )
        else if (widget.itemBank.type == 3)
          FavoriteShortAnswer(
            shortAnswer: shortAnswer,
            itemBank: widget.itemBank,
            isSubmited: isSubmited,
          )
        else
          FavoriteProgram(
            program: program,
            itemBank: widget.itemBank,
            isSubmited: isSubmited,
          ),
        const SizedBox(
          height: 20,
        ),
        if (isSubmited == 0)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ElevatedButton(
                  onPressed: () {
                    onSubmitPressed();
                  },
                  child: Text(
                    "提交",
                    style: MyTextStyle.textStyle,
                  ),
                ),
              )
            ],
          ),
        if (isSubmited == 0)
          const SizedBox(
            height: 20,
          ),
        if (isSubmited == 1)
          Row(
            children: [
              Text(
                "得分：",
                style: MyTextStyle.colorTextStyle,
              ),
              Text(
                result.score.toString(),
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
              result.feedback,
              style: MyTextStyle.colorTextStyle,
            ),
          ),
        if (isSubmited == 1)
          const SizedBox(
            height: 20,
          )
      ],
    );
  }

  onSubmitPressed() async {
    BotToast.showLoading();
    ItemBank itemBank = widget.itemBank;
    var response = await http.post(
      Uri.parse("${Status.baseUrl}/submitItem"),
      body: {
        "userId": Status.user.id.toString(),
        "itemId": itemBank.id.toString(),
        "answer": Status.favoriteItem.answer,
      },
    );
    result = Result.objToResult(
      jsonDecode(utf8.decode(response.bodyBytes)),
    );
    isSubmited = 1;
    setState(() {});
    BotToast.closeAllLoading();
  }

  initData() async {
    BotToast.showLoading();
    isSubmited = widget.isSubmited;
    if (isSubmited == 1) {
      result = widget.result;
    }
    if (widget.itemBank.type == 1) {
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getChoiceById?id=${widget.itemBank.questionId}",
        ),
      );
      var resObj = jsonDecode(utf8.decode(response.bodyBytes));
      choice = Choice.objToChoice(resObj);
    } else if (widget.itemBank.type == 2) {
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getCompletionById?id=${widget.itemBank.questionId}",
        ),
      );
      var resObj = jsonDecode(utf8.decode(response.bodyBytes));
      completion = Completion.objToCompletion(resObj);
    } else if (widget.itemBank.type == 3) {
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getShortAnswerById?id=${widget.itemBank.questionId}",
        ),
      );
      var resObj = jsonDecode(utf8.decode(response.bodyBytes));
      shortAnswer = ShortAnswer.objToShortAnswer(resObj);
    } else if (widget.itemBank.type == 4) {
      var response = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getProgramById?id=${widget.itemBank.questionId}",
        ),
      );
      var resObj = jsonDecode(utf8.decode(response.bodyBytes));
      program = Program.objToProgram(resObj);
    }
    setState(() {});
    ok = 1;
    BotToast.closeAllLoading();
  }
}
