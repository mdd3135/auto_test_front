import 'package:auto_test_front/entity/scoreAnalysis.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class ScoreAnalysisDialog extends StatefulWidget {
  const ScoreAnalysisDialog({
    super.key,
    required this.scoreAnalysisList,
    required this.userName,
  });

  final List<ScoreAnalysis> scoreAnalysisList;
  final String userName;

  @override
  State<ScoreAnalysisDialog> createState() => _ScoreAnalysisDialogState();
}

class _ScoreAnalysisDialogState extends State<ScoreAnalysisDialog> {
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
            "作业名称：",
            style: MyTextStyle.colorTextStyle,
          ),
          Text(
            scoreAnalysis.homeworkName,
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
          "全部作业统计",
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
      title: Text(
        "${widget.userName}的成绩分析",
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Container(
        padding: const EdgeInsets.only(top: 20),
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
