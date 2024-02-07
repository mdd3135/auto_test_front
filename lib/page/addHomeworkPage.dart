import 'package:auto_test_front/widget/myAppBar.dart';
import 'package:auto_test_front/widget/shadowContainer.dart';
import 'package:flutter/cupertino.dart';
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

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
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
                width: 600,
                height: height - 120,
                child: SingleChildScrollView(
                  child: bodyDetail(),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "取消",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "确认",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
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
      children: [
        TextFormField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            label: Text(
              "作业名称",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          onChanged: (value) {},
        ),
        const SizedBox(
          height: 20,
        ),
        ShadowContainer(
          child: Row(
            children: [
              const Text(
                "作业开始时间：",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        ShadowContainer(
          child: Row(
            children: [
              const Text(
                "作业结束时间：",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
        ),
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
}
