import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/page/selectItemPage.dart';
import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:flutter/material.dart';

class AddHomeworkPage extends StatefulWidget {
  const AddHomeworkPage({super.key});

  @override
  State<AddHomeworkPage> createState() => _AddHomeworkPageState();
}

class _AddHomeworkPageState extends State<AddHomeworkPage> {
  DateTime startTime = DateTime.now();
  DateTime deadline = DateTime.now().add(
    const Duration(days: 3),
  );
  List<ItemBank> itemBankList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar().build(
        context,
        "添加作业",
        null,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 40,
            child: Center(
              child: SizedBox(
                width: 400,
                child: bodyDetail(),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "取消",
                      style: MyTextStyle.textStyle,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "确认",
                      style: MyTextStyle.textStyle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bodyDetail() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "作业名称：",
                style: MyTextStyle.textStyle,
              ),
            ),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(10),
                ),
                textAlign: TextAlign.center,
                style: MyTextStyle.textStyle,
                onChanged: (value) {},
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              "作业开始时间：",
              style: MyTextStyle.textStyle,
            ),
            const Expanded(
              child: Text(""),
            ),
            TextButton(
              onPressed: () {
                startTimePressed();
              },
              child: Text(
                startTime.toString().substring(0, 16),
                style: MyTextStyle.textStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              "作业结束时间：",
              style: MyTextStyle.textStyle,
            ),
            const Expanded(
              child: Text(""),
            ),
            TextButton(
              onPressed: () {
                deadlinePressed();
              },
              child: Text(
                deadline.toString().substring(0, 16),
                style: MyTextStyle.textStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              "选择题目：",
              style: MyTextStyle.textStyle,
            ),
            const Expanded(
              child: Text(""),
            ),
            TextButton(
              onPressed: () {
                selectItemPressed();
              },
              child: Text(
                "共 ${itemBankList.length} 题",
                style: MyTextStyle.textStyle,
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ShadowContainer(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: ListView.builder(
              itemCount: itemBankList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(
                    itemBankList[index].type.toString(),
                    style: MyTextStyle.textStyle,
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }

  startTimePressed() async {
    showDatePicker(
      context: context,
      initialDate: startTime,
      firstDate: DateTime.now(),
      lastDate: startTime.add(
        const Duration(days: 365),
      ),
    ).then((dateTime) async {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(startTime),
      ).then((timeOfDay) {
        if (timeOfDay != null && dateTime != null) {
          startTime = dateTime.add(
            Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute),
          );
        }
        if (startTime.compareTo(deadline) > 0) {
          deadline = startTime;
        }
        setState(() {});
      });
    });
  }

  deadlinePressed() async {
    showDatePicker(
      context: context,
      initialDate: deadline,
      firstDate: startTime,
      lastDate: deadline.add(
        const Duration(days: 365),
      ),
    ).then((dateTime) async {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(deadline),
      ).then((timeOfDay) {
        if (timeOfDay != null && dateTime != null) {
          deadline = dateTime.add(
            Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute),
          );
        }
        setState(() {});
      });
    });
  }

  selectItemPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return const SelectItemPage();
      }),
    ).then((value) {
      if (value == null) {
        return;
      }
      Set<ItemBank> itemBankSet = value;
      itemBankList = itemBankSet.toList();
      setState(() {});
    });
  }
}
