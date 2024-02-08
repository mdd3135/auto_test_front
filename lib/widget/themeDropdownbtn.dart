import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:flutter/material.dart';

class ThemeDropDownbtn extends StatefulWidget {
  const ThemeDropDownbtn({super.key});

  @override
  State<ThemeDropDownbtn> createState() => _ThemeDropDownbtnState();
}

class _ThemeDropDownbtnState extends State<ThemeDropDownbtn> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      focusColor: Colors.transparent,
      items: [
        DropdownMenuItem(
          value: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Text(
                "红",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
        DropdownMenuItem(
          value: 1,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.purple,
              ),
              const SizedBox(width: 10),
              Text(
                "紫",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
        DropdownMenuItem(
          value: 2,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.blue,
              ),
              const SizedBox(width: 10),
              Text(
                "蓝",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
        DropdownMenuItem(
          value: 3,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.cyan,
              ),
              const SizedBox(width: 10),
              Text(
                "青",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
        DropdownMenuItem(
          value: 4,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.teal,
              ),
              const SizedBox(width: 10),
              Text(
                "茶",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
        DropdownMenuItem(
          value: 5,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.green,
              ),
              const SizedBox(width: 10),
              Text(
                "绿",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
        DropdownMenuItem(
          value: 6,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 20,
                width: 20,
                color: Colors.orange,
              ),
              const SizedBox(width: 10),
              Text(
                "橙",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        ),
      ],
      value: Status.colorId,
      onChanged: (value) {
        onColorChanged(value);
      },
    );
  }

  onColorChanged(int? value) {
    Status.colorId = value ?? 2;
    Status.prefs.setInt("colorId", Status.colorId);
    setState(() {});
  }
}
