import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class ModifyScoreDialog extends StatefulWidget {
  const ModifyScoreDialog({super.key, required this.score});

  final double score;

  @override
  State<ModifyScoreDialog> createState() => _ModifyScoreDialogState();
}

class _ModifyScoreDialogState extends State<ModifyScoreDialog> {
  String scoreString = "";

  @override
  void initState() {
    super.initState();
    scoreString = widget.score.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "修改分值",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            label: Text(
              "新的分值",
              style: MyTextStyle.textStyle
            ),
          ),
          textAlign: TextAlign.center,
          initialValue: scoreString,
          style: MyTextStyle.textStyle,
          onChanged: (value) {
            scoreString = value;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "取消",
            style: MyTextStyle.textStyle,
          ),
          onPressed: () {
            Navigator.of(context).pop({"isModify": false});
          },
        ),
        TextButton(
          child: Text(
            "确定",
            style: MyTextStyle.textStyle,
          ),
          onPressed: () {
            onConfirmPressed();
          },
        ),
      ],
    );
  }

  onConfirmPressed() {
    try {
      double score = double.parse(scoreString);
      Navigator.of(context).pop(
        {
          "isModify": true,
          "score": score,
        },
      );
    } catch (e) {
      BotToast.showText(text: "你输入的分值不正确,请重新输入");
    }
  }
}
