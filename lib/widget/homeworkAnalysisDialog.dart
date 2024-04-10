import 'package:auto_test_front/entity/scoreAnalysis.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class HomeworkAnalysisDialog extends StatefulWidget {
  const HomeworkAnalysisDialog({
    super.key,
    required this.scoreAnalysisList,
  });

  final List<ScoreAnalysis> scoreAnalysisList;

  @override
  State<HomeworkAnalysisDialog> createState() => _HomeworkAnalysisDialogState();
}

class _HomeworkAnalysisDialogState extends State<HomeworkAnalysisDialog> {
  List<Widget> widgetList = [];

  @override
  void initState() {
    double gainedScore = 0;
    double totalScore = 0;
    for (int i = 0; i < widget.scoreAnalysisList.length; i++) {
      ScoreAnalysis scoreAnalysis = widget.scoreAnalysisList[i];
      gainedScore = gainedScore + scoreAnalysis.gainedScore;
      totalScore = totalScore + scoreAnalysis.totalScore;
      var row = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "姓名：",
            style: MyTextStyle.colorTextStyle,
          ),
          Text(
            scoreAnalysis.userName,
            style: MyTextStyle.textStyle,
          ),
          const Expanded(child: Text("")),
          Text(
            "获得分数：",
            style: MyTextStyle.colorTextStyle,
          ),
          Text(
            "${scoreAnalysis.gainedScore.toStringAsFixed(1)}/"
            "${scoreAnalysis.totalScore.toStringAsFixed(1)}",
            style: MyTextStyle.textStyle,
          ),
        ],
      );
      widgetList.add(row);
    }
    widgetList.add(Row(
      children: [
        Text(
          "全部学生统计",
          style: MyTextStyle.colorTextStyle,
        ),
        const Expanded(child: Text("")),
        Text(
          "获得分数：",
          style: MyTextStyle.colorTextStyle,
        ),
        Text(
          "${gainedScore.toStringAsFixed(1)}/${totalScore.toStringAsFixed(1)}",
          style: MyTextStyle.textStyle,
        ),
      ],
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "作业统计",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Container(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        height: 400,
        width: 600,
        child: ListView(
          children: widgetList,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "确定",
            style: MyTextStyle.textStyle,
          ),
        ),
      ],
    );
  }
}
