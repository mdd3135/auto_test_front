import 'dart:convert';
import 'dart:io';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/page/choiceDetail.dart';
import 'package:auto_test_front/page/completionDetail.dart';
import 'package:auto_test_front/page/shortAnswerPage.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/modDescriptionDialog.dart';
import 'package:auto_test_front/widget/modifyScoreDialog.dart';
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
  List<bool> isSelectedList = [];
  bool isAllSelected = false;
  int itemBankCount = 0;
  int currentPage = 1;
  int totalPage = 1;
  int countId = 1;

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
                  importChoicePressed();
                },
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
                  deletePressed();
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
                "共$itemBankCount条记录",
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
      Uri.parse("${Status.baseUrl}/getItemBankCount"),
    );
    String bodyString = utf8.decode(response.bodyBytes);
    itemBankCount = int.parse(bodyString);
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
    totalPage = (itemBankCount / count).ceil();
    response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getAllItemBank?count=$count&page=$currentPage",
      ),
    );
    bodyString = utf8.decode(response.bodyBytes);
    var bodyObj = jsonDecode(bodyString);
    itemBankList.clear();
    for (Map<String, dynamic> map in bodyObj) {
      itemBankList.add(ItemBank.objToItemBank(map));
    }
    initSelectedList(false);
    isAllSelected = false;
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
              type,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                onDescriptionPressed(itemBank);
              },
              child: Text(
                itemBank.description,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
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
            TextButton(
              onPressed: () {
                onModifyScorePressed(itemBank);
              },
              child: Text(
                itemBank.score.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          DataCell(
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
          if (itemBank.type == 1) {
            return ChoiceDetail(
              itemBank: itemBank,
            );
          } else if (itemBank.type == 2) {
            return CompletionDetail(
              itemBank: itemBank,
            );
          } else if (itemBank.type == 3) {
            return ShortAnswerPage(
              itemBank: itemBank,
            );
          }
          return Container();
        },
      ),
    );
  }

  deleteConfirm() async {
    for (int i = 0; i < isSelectedList.length; i++) {
      if (isSelectedList[i]) {
        String id = itemBankList[i].id.toString();
        await http.post(
          Uri.parse("${Status.baseUrl}/deleteItemBank"),
          body: {"id": id},
        );
      }
    }
  }

  deletePressed() {
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
          content: const Text(
            "该操作不可恢复！是否要删除所选题目？",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(
                "取消",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text(
                "确定",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
            )
          ],
        );
      },
    ).then((value) async {
      if (value == false) {
        return;
      }
      BotToast.showLoading();
      await deleteConfirm();
      currentPage = 1;
      await initData();
      BotToast.showText(text: "删除所选题目成功");
    });
  }

  onDescriptionPressed(ItemBank itemBank) {
    showDialog(
      context: context,
      builder: (context) {
        return ModDescriptionDialog(
          description: itemBank.description,
        );
      },
    ).then((value) {
      if (value != null && value["isModify"] == true) {
        BotToast.showLoading();
        itemBank.description = value["description"];
        modifyDescriptionAndScore(itemBank);
      }
    });
  }

  modifyDescriptionAndScore(ItemBank itemBank) async {
    var response = await http.post(
      Uri.parse("${Status.baseUrl}/modItemBankById"),
      body: {
        "id": itemBank.id.toString(),
        "score": itemBank.score.toString(),
        "description": itemBank.description,
      },
    );
    String bodyString = utf8.decode(response.bodyBytes);
    if (bodyString == "") {
      BotToast.showText(text: "修改题目描述失败");
    } else {
      BotToast.showText(text: "修改题目描述成功");
      initData();
    }
  }

  onModifyScorePressed(ItemBank itemBank) {
    showDialog(
      context: context,
      builder: (context) {
        return ModifyScoreDialog(score: itemBank.score);
      },
    ).then((value) {
      if (value != null && value["isModify"] == true) {
        BotToast.showLoading();
        itemBank.score = value["score"];
        modifyDescriptionAndScore(itemBank);
      }
    });
  }

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

  importChoicePressed() async {
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
      int optionsColumn = -1;
      int answerColumn = -1;
      int analysisColumn = -1;
      int isMultipleColumn = -1;
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
            } else if (cell.value.toString() == "可选项") {
              optionsColumn = i;
            } else if (cell.value.toString() == "答案") {
              answerColumn = i;
            } else if (cell.value.toString() == "解析") {
              analysisColumn = i;
            } else if (cell.value.toString() == "是否多选") {
              isMultipleColumn = i;
            }
          }
          rowCount++;
          continue;
        }
        var scoreCell = row[scoreColumn];
        var descriptionCell = row[descriptionColumn];
        var contentCell = row[contentColumn];
        var optionsCell = row[optionsColumn];
        var answerCell = row[answerColumn];
        var analysisCell = row[analysisColumn];
        var isMultipleCell = row[isMultipleColumn];
        if (scoreCell == null ||
            descriptionCell == null ||
            contentCell == null ||
            optionsCell == null ||
            answerCell == null ||
            analysisCell == null ||
            isMultipleCell == null) {
          continue;
        }
        String score = scoreCell.value.toString();
        String description = descriptionCell.value.toString();
        String content = contentCell.value.toString();
        String options = optionsCell.value.toString();
        String answer = answerCell.value.toString();
        String analysis = analysisCell.value.toString();
        String isMultiple = isMultipleCell.value.toString();
        if (score == "null" ||
            description == "null" ||
            content == "null" ||
            options == "null" ||
            answer == "null" ||
            analysis == "null" ||
            isMultiple == "null") {
          continue;
        }
        await http.post(
          Uri.parse("${Status.baseUrl}/addChoice"),
          body: {
            "score": score,
            "description": description,
            "content": content,
            "options": options,
            "answer": answer,
            "analysis": analysis,
            "isMultiple": isMultiple,
          },
        );
      }
    }
    await initData();
    BotToast.showText(text: "导入选择题成功");
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

  initSelectedList(bool value) {
    isSelectedList.clear();
    for (int i = 0; i < itemBankList.length; i++) {
      isSelectedList.add(value);
    }
  }

  allSelected(bool value) {
    isAllSelected = value;
    initSelectedList(value);
    initDataRowList();
  }
}
