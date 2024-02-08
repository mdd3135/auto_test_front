import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class NumberModDialog extends StatefulWidget {
  const NumberModDialog({super.key, required this.number});

  final String number;

  @override
  State<NumberModDialog> createState() => _NumberModDialogState();
}

class _NumberModDialogState extends State<NumberModDialog> {
  String number = "";

  @override
  initState() {
    super.initState();
    number = widget.number;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "修改学号",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: Container(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            label: Text("新学号", style: MyTextStyle.textStyle),
          ),
          textAlign: TextAlign.center,
          initialValue: number,
          style: MyTextStyle.textStyle,
          onChanged: (value) {
            number = value;
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
            Navigator.of(context).pop({
              "isModify": true,
              "number": number,
            });
          },
        ),
      ],
    );
  }
}
