import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/page/completionDetail.dart';
import 'package:auto_test_front/status.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Container(
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
            TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return onDetailPressed(itemBank);
                    },
                  ),
                );
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
    if (itemBank.type == 2) {
      return CompletionDetail(
        itemBank: itemBank,
      );
    }
  }
}
