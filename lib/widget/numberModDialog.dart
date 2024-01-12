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
      content: TextFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          label: Text(
            "新学号",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        textAlign: TextAlign.center,
        initialValue: number,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        onChanged: (value) {
          number = value;
        },
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            "取消",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop({"isModify": false});
          },
        ),
        TextButton(
          child: const Text(
            "确定",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
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
