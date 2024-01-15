import 'dart:convert';
import 'dart:io';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/page/completionDetail.dart';
import 'package:auto_test_front/status.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart' as excel_lib;

class ProblemSetPage extends StatefulWidget {
  const ProblemSetPage({super.key});

  @override
  State<ProblemSetPage> createState() => _ProblemSetPageState();
}

class _ProblemSetPageState extends State<ProblemSetPage> {
  List<ItemBank> itemBankList = [];
  List<DataRow> dataRowList = [];

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
                    "导入选择题",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
                child: Text(""),
              ),
              ElevatedButton(
                onPressed: () {
                  importCompletionPressed();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                    "导入填空题",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
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
                  child: const Text(
                    "导入简答题",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
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
                  child: const Text(
                    "导入编程题",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
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
                  child: const Text(
                    "删除所选",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
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
                  child: const Text(
                    "全部导出",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  List<DataColumn> dataColumn() {
    return [
      // DataColumn(
      //   label: Checkbox(
      //     value: isAllSelected,
      //     onChanged: (value) {
      //       allSelected(value ?? false);
      //     },
      //   ),
      // ),
      const DataColumn(
        label: Text(
          "类型",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "题目描述",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "创建时间",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const DataColumn(
        label: Text(
          "分值",
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
      Uri.parse("${Status.baseUrl}/getAllItemBank"),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    var bodyObj = jsonDecode(bodyString);
    itemBankList.clear();
    for (Map<String, dynamic> map in bodyObj) {
      itemBankList.add(ItemBank.objToItemBank(map));
    }
    await initDataRowList();
    BotToast.closeAllLoading();
  }

  initDataRowList() async {
    dataRowList.clear();
    for (int i = 0; i < itemBankList.length; i++) {
      ItemBank itemBank = itemBankList[i];
      DateTime dateTime =
          DateTime.fromMillisecondsSinceEpoch(int.parse(itemBank.createTime));
      String type = "";
      if (itemBank.type == 1) {
        type = "选择题";
      } else if (itemBank.type == 2) {
        type = "填空题";
      } else if (itemBank.type == 3) {
        type = "简答题";
      } else if (itemBank.type == 4) {
        type = "编程题";
      }
      DataRow row = DataRow(
        cells: [
          DataCell(
            Text(
              type,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Text(
              itemBank.description,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Text(
              dateTime.toString().substring(0, 19),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Text(
              itemBank.score.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    onDeletePressed(itemBank);
                  },
                  child: const Text(
                    "删除",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    onDetailPressed(itemBank);
                  },
                  child: const Text(
                    "查看",
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

  onDetailPressed(ItemBank itemBank) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          if (itemBank.type == 2) {
            return CompletionDetail(
              itemBank: itemBank,
            );
          }
          return Container();
        },
      ),
    );
  }

  onDeletePressed(ItemBank itemBank) async {
    BotToast.showLoading();
    await http.post(
      Uri.parse("${Status.baseUrl}/deleteItemBank"),
      body: {"id": itemBank.id.toString()},
    );
    initData();
    BotToast.showText(text: "删除题目成功");
  }

  importPressed() {}

  delPressed() {}

  importCompletionPressed() async {
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
      int scoreColumn = -1;
      int descriptionColumn = -1;
      int contentColumn = -1;
      int answerColumn = -1;
      int analysisColumn = -1;
      for (var row in excel[table].rows) {
        if (rowCount == 1) {
          for (int i = 0; i < row.length; i++) {
            var cell = row[i];
            if (cell == null) {
              continue;
            } else if (cell.value.toString() == "分值") {
              scoreColumn = i;
            } else if (cell.value.toString() == "题目描述") {
              descriptionColumn = i;
            } else if (cell.value.toString() == "题目内容") {
              contentColumn = i;
            } else if (cell.value.toString() == "答案") {
              answerColumn = i;
            } else if (cell.value.toString() == "解析") {
              analysisColumn = i;
            }
          }
          rowCount++;
          continue;
        }
        var scoreCell = row[scoreColumn];
        var descriptionCell = row[descriptionColumn];
        var contentCell = row[contentColumn];
        var answerCell = row[answerColumn];
        var analysisCell = row[analysisColumn];
        if (scoreCell == null ||
            descriptionCell == null ||
            contentCell == null ||
            answerCell == null ||
            analysisCell == null) {
          continue;
        }
        String score = scoreCell.value.toString();
        String description = descriptionCell.value.toString();
        String content = contentCell.value.toString();
        String answer = answerCell.value.toString();
        String analysis = analysisCell.value.toString();
        if (score == "null" ||
            description == "null" ||
            content == "null" ||
            answer == "null" ||
            analysis == "null") {
          continue;
        }
        await http.post(
          Uri.parse("${Status.baseUrl}/addCompletion"),
          body: {
            "score": score,
            "description": description,
            "content": content,
            "answer": answer,
            "analysis": analysis,
          },
        );
      }
    }
    await initData();
    BotToast.showText(text: "导入填空题成功");
  }
}
