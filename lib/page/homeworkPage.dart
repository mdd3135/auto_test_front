import 'dart:convert';

import 'package:auto_test_front/entity/homework.dart';
import 'package:auto_test_front/status.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage> {
  List<Homework> homeworkList = [];
  List<int> submitCountList = [];
  List<DataRow> dataRowList = [];
  List<bool> isSelectedList = [];
  int homeworkCount = 0;
  int currentPage = 1;
  int totalPage = 1;
  int countId = 1;
  bool isAllSelected = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Positioned(
          top: 80,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: height - 220,
              minHeight: height - 220,
            ),
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                  width: 2,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                vertical: BorderSide(
                  width: 1,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            child: SingleChildScrollView(
              child: DataTable(
                border: TableBorder.all(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                columns: dataColumn(),
                rows: dataRowList,
              ),
            ),
          ),
        ),
        Positioned(
          top: 20,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "添加作业",
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
                    "删除所选",
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
        Positioned(
          bottom: 20,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton(
                focusColor: Colors.transparent,
                value: countId,
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(
                      "10条",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(
                      "20条",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text(
                      "50条",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text(
                      "100条",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
                onChanged: (value) {
                  changeCountId(value);
                },
              ),
              const SizedBox(
                width: 20,
              ),
              IconButton(
                onPressed: () {
                  prePage();
                },
                icon: const Icon(
                  Icons.arrow_left,
                  size: 30,
                ),
              ),
              Text(
                "第$currentPage页/共$totalPage页",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              IconButton(
                onPressed: () {
                  nextPage();
                },
                icon: const Icon(
                  Icons.arrow_right,
                  size: 30,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Text(
                "共$homeworkCount条记录",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  initData() async {
    BotToast.showLoading();
    var response = await http.get(
      Uri.parse("${Status.baseUrl}/getHomeworkCount"),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    homeworkCount = int.parse(bodyString);
    int count = 0;
    if (countId == 0) {
      count = 10;
    } else if (countId == 1) {
      count = 20;
    } else if (countId == 2) {
      count = 50;
    } else if (countId == 3) {
      count = 100;
    }
    totalPage = (homeworkCount / count).ceil();
    response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getAllHomework?count=$count&page=$currentPage",
      ),
    );
    bodyString = utf8.decode(response.bodyBytes);
    var bodyObj = jsonDecode(bodyString);
    homeworkList.clear();
    for (Map<String, dynamic> map in bodyObj) {
      Homework homework = Homework.objToHomework(map);
      homeworkList.add(homework);
      if (Status.user.type == 1) {
        //教师不需要在此知道提交次数,加快速度
        continue;
      }
      var response2 = await http.get(
        Uri.parse(
          "${Status.baseUrl}/getSubmitCountByUserIdAndHomeworkId?"
          "userId=${Status.user.id}&homeworkId=${homework.id}",
        ),
      );
      String bodyString2 = utf8.decode(response2.bodyBytes);
      int submitCount = int.parse(bodyString2);
      submitCountList.add(submitCount);
    }
    initSelectedList(false);
    isAllSelected = false;
    await initDataRowList();
    BotToast.closeAllLoading();
  }

  List<DataColumn> dataColumn() {
    return [
      DataColumn(
        label: Checkbox(
          value: isAllSelected,
          onChanged: (value) {
            allSelected(value ?? false);
          },
        ),
      ),
      const DataColumn(
        label: Text(
          "作业名称",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "开始时间",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "截止时间",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "提交次数", // "1/2"
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "操作", //查看作业、作业统计
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ];
  }

  initDataRowList() async {
    dataRowList.clear();
    for (int i = 0; i < homeworkList.length; i++) {
      Homework homework = homeworkList[i];
      DateTime createTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(homework.createTime),
      );
      DateTime deadline = DateTime.fromMillisecondsSinceEpoch(
        int.parse(homework.deadline),
      );
      DataRow row = DataRow(
        cells: [
          DataCell(
            Checkbox(
              value: isSelectedList[i],
              onChanged: (bool? value) {
                selected(value ?? false, i);
              },
            ),
          ),
          DataCell(
            Text(
              homework.homeworkName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Text(
              createTime.toString().substring(0, 19),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Text(
              deadline.toString().substring(0, 19),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Text(
              Status.user.type == 0
                  ? "${submitCountList[i]} / ${homework.count}"
                  : "${homework.count}",
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "查看作业",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                if (Status.user.type == 1)
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "作业统计",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                if (Status.user.type == 0)
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      "完成作业",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      );
      dataRowList.add(row);
    }
    setState(() {});
  }

  changeCountId(int? value) {
    countId = value ?? 1;
    currentPage = 1;
    initData();
  }

  prePage() {
    if (currentPage <= 1) {
      return;
    }
    currentPage--;
    initData();
  }

  nextPage() {
    if (currentPage >= totalPage) {
      return;
    }
    currentPage++;
    initData();
  }

  selected(bool value, int i) {
    isSelectedList[i] = value;
    if (value == false) {
      isAllSelected = false;
    }
    initDataRowList();
  }

  allSelected(bool value) {
    isAllSelected = value;
    initSelectedList(value);
    initDataRowList();
  }

  initSelectedList(bool value) {
    isSelectedList.clear();
    for (int i = 0; i < homeworkList.length; i++) {
      isSelectedList.add(value);
    }
  }
}
