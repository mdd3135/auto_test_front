import 'dart:convert';
import 'dart:io';

import 'package:auto_test_front/entity/scoreAnalysis.dart';
import 'package:auto_test_front/entity/user.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/classroomModDialog.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:auto_test_front/widget/numberModDialog.dart';
import 'package:auto_test_front/widget/resetPwdDialog.dart';
import 'package:auto_test_front/widget/scoreAnalysisDialog.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:excel/excel.dart' as excel_lib;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StuManPage extends StatefulWidget {
  const StuManPage({super.key});

  @override
  State<StuManPage> createState() => _StuManPageState();
}

class _StuManPageState extends State<StuManPage> {
  List<User> stuList = [];
  List<DataRow> dataRowList = [];
  List<bool> isSelectedList = [];
  int stuCount = 0;
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
                onPressed: () {
                  importPressed();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "批量导入",
                    style: MyTextStyle.textStyle,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
                child: Text(""),
              ),
              ElevatedButton(
                onPressed: () {
                  delPressed();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "删除所选",
                    style: MyTextStyle.textStyle,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
                child: Text(""),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "全部导出",
                    style: MyTextStyle.textStyle,
                  ),
                ),
              )
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
                items: [
                  DropdownMenuItem(
                    value: 0,
                    child: Text(
                      "10条",
                      style: MyTextStyle.textStyle,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text(
                      "20条",
                      style: MyTextStyle.textStyle,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text(
                      "50条",
                      style: MyTextStyle.textStyle,
                    ),
                  ),
                  DropdownMenuItem(
                    value: 3,
                    child: Text(
                      "100条",
                      style: MyTextStyle.textStyle,
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
                style: MyTextStyle.textStyle,
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
                "共$stuCount条记录",
                style: MyTextStyle.textStyle,
              )
            ],
          ),
        )
      ],
    );
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
          "姓名",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "学号",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "班级",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "成绩分析",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "操作",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ];
  }

  initData() async {
    BotToast.showLoading();
    var response = await http.get(
      Uri.parse("${Status.baseUrl}/getStuCount"),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    stuCount = int.parse(bodyString);
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
    totalPage = (stuCount / count).ceil();
    response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/findAllStu?count=$count&page=$currentPage",
      ),
    );
    bodyString = utf8.decode(response.bodyBytes);
    var bodyObj = jsonDecode(bodyString);
    stuList.clear();
    for (Map<String, dynamic> map in bodyObj) {
      stuList.add(User.objToUser(map));
    }
    initSelectedList(false);
    isAllSelected = false;
    await initDataRowList();
    BotToast.closeAllLoading();
  }

  initSelectedList(bool value) {
    isSelectedList.clear();
    for (int i = 0; i < stuList.length; i++) {
      isSelectedList.add(value);
    }
  }

  initDataRowList() async {
    dataRowList.clear();
    for (int i = 0; i < stuList.length; i++) {
      User user = stuList[i];
      DataRow row = DataRow(
        selected: isSelectedList[i],
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
              user.name,
              style: MyTextStyle.textStyle,
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                onNumberPressed(stuList[i]);
              },
              child: Text(
                user.number,
                style: MyTextStyle.textStyle,
              ),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                onClassroomPressed(stuList[i]);
              },
              child: Text(
                user.classroom,
                style: MyTextStyle.textStyle,
              ),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                onAnalysisPressed(user);
              },
              child: Text(
                "查看",
                style: MyTextStyle.textStyle,
              ),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                resetPwdPressed(user.name);
              },
              child: Text(
                "重置密码",
                style: MyTextStyle.textStyle,
              ),
            ),
          ),
        ],
      );
      dataRowList.add(row);
    }
    setState(() {});
  }

  importPressed() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xlsx"],
    );
    if (result == null) {
      BotToast.showText(text: "未选择文件");
      return;
    }
    BotToast.showLoading();
    String path = result.files.first.path!;
    var bytes = File(path).readAsBytesSync();
    var excel = excel_lib.Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      int rowCount = 1;
      int nameColumn = -1;
      int classroomColumn = -1;
      int numberColumn = -1;
      for (var row in excel[table].rows) {
        if (rowCount == 1) {
          for (int i = 0; i < row.length; i++) {
            var cell = row[i];
            if (cell == null) {
              continue;
            } else if (cell.value.toString() == "姓名") {
              nameColumn = i;
            } else if (cell.value.toString() == "班级") {
              classroomColumn = i;
            } else if (cell.value.toString() == "学号") {
              numberColumn = i;
            }
          }
        } else {
          var nameCell = row[nameColumn];
          var classroomCell = row[classroomColumn];
          var numberCell = row[numberColumn];
          if (nameCell == null) {
            continue;
          }
          if (classroomCell == null) {
            continue;
          }
          if (numberCell == null) {
            continue;
          }
          String name = nameCell.value.toString();
          String classroom = classroomCell.value.toString();
          String number = numberCell.value.toString();
          if (name == "null" || classroom == "null" || number == "null") {
            continue;
          }
          await http.post(
            Uri.parse("${Status.baseUrl}/addStu"),
            body: {
              "name": name,
              "classroom": classroom,
              "number": number,
            },
          );
        }
        rowCount++;
      }
    }
    await initData();
    BotToast.showText(text: "导入成功");
  }

  void delPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "警告",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "该操作不可恢复！是否要删除所选学生？",
            style: MyTextStyle.textStyle,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "取消",
                style: MyTextStyle.textStyle,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "确定",
                style: MyTextStyle.textStyle,
              ),
            )
          ],
        );
      },
    ).then((value) async {
      if (value == null || value == false) {
        return;
      }
      BotToast.showLoading();
      await delConfirm();
      currentPage = 1;
      await initData();
      BotToast.showText(text: "删除所选学生成功");
    });
  }

  delConfirm() async {
    for (int i = 0; i < isSelectedList.length; i++) {
      if (isSelectedList[i]) {
        String name = stuList[i].name;
        await http.post(
          Uri.parse("${Status.baseUrl}/delUser"),
          body: {"name": name},
        );
      }
    }
  }

  allSelected(bool value) {
    isAllSelected = value;
    initSelectedList(value);
    initDataRowList();
  }

  selected(bool value, int i) {
    isSelectedList[i] = value;
    if (value == false) {
      isAllSelected = false;
    }
    initDataRowList();
  }

  resetPwdPressed(String name) {
    showDialog(
      context: context,
      builder: (context) {
        return const ResetPwdDialog();
      },
    ).then((value) async {
      if (value == null || value == false) {
        return;
      }
      BotToast.showLoading();
      await http.post(
        Uri.parse("${Status.baseUrl}/resetPwd"),
        body: {"name": name},
      );
      BotToast.closeAllLoading();
      BotToast.showText(text: "重置密码成功");
    });
  }

  changeCountId(int? value) {
    countId = value ?? 1;
    currentPage = 1;
    initData();
  }

  prePage() {
    if (currentPage <= 1) {
      BotToast.showText(text: "已经是第一页了");
      return;
    }
    currentPage--;
    initData();
  }

  nextPage() {
    if (currentPage >= totalPage) {
      BotToast.showText(text: "已经是最后一页了");
      return;
    }
    currentPage++;
    initData();
  }

  onNumberPressed(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return NumberModDialog(number: user.number);
      },
    ).then((value) async {
      if (value != null && value["isModify"]) {
        BotToast.showLoading();
        await modifyNumber(user.name, value["number"]);
        initData();
        BotToast.showText(text: "修改学号成功");
      }
    });
  }

  modifyNumber(String name, String number) async {
    await http.post(
      Uri.parse("${Status.baseUrl}/modNumber"),
      body: {"name": name, "number": number},
    );
  }

  onClassroomPressed(User user) {
    showDialog(
      context: context,
      builder: (context) {
        return ClassroomModDialog(classroom: user.classroom);
      },
    ).then((value) async {
      if (value != null && value["isModify"]) {
        BotToast.showLoading();
        await modifyClassroom(user.name, value["classroom"]);
        initData();
        BotToast.showText(text: "修改班级成功");
      }
    });
  }

  modifyClassroom(String name, String classroom) async {
    await http.post(
      Uri.parse("${Status.baseUrl}/modClassroom"),
      body: {"name": name, "classroom": classroom},
    );
  }

  onAnalysisPressed(User user) async {
    BotToast.showLoading();
    var response =
        await http.get(Uri.parse("${Status.baseUrl}/getScoreAnalysis?"
            "userId=${user.id}"));
    List<dynamic> bodyObj = jsonDecode(utf8.decode(response.bodyBytes));
    List<ScoreAnalysis> scoreAnalysisList = [];
    for (int i = 0; i < bodyObj.length; i++) {
      ScoreAnalysis scoreAnalysis =
          ScoreAnalysis.objToScoreAnalysis(bodyObj[i]);
      scoreAnalysisList.add(scoreAnalysis);
    }
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) {
        return ScoreAnalysisDialog(
          scoreAnalysisList: scoreAnalysisList,
          userName: user.name,
        );
      },
    );
    BotToast.closeAllLoading();
  }
}
