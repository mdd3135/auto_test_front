import 'dart:convert';

import 'package:auto_test_front/entity/submit.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  List<Submit> submitList = [];
  List<DataRow> dataRowList = [];
  List<bool> isSelectedList = [];
  int submitCount = 0;
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
          top: 20,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: height - 180,
              minHeight: height - 180,
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
                "共$submitCount条记录",
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
          "提交时间",
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
      Uri.parse(
        "${Status.baseUrl}/getSubmitCountByUserId?userId=${Status.user.id}",
      ),
    );
    submitCount = int.parse(utf8.decode(response.bodyBytes));
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
    totalPage = (submitCount / count).ceil();
    response = await http.get(
      Uri.parse(
        "${Status.baseUrl}/getSubmitByUserId?"
        "count=$count&page=$currentPage&userId=${Status.user.id}",
      ),
    );
    var bodyObj = jsonDecode(utf8.decode(response.bodyBytes));
    submitList.clear();
    for (Map<String, dynamic> map in bodyObj) {
      submitList.add(Submit.objToSubmit(map));
    }
    initSelectedList(false);
    isAllSelected = false;
    await initDataRowList();
    BotToast.closeAllLoading();
  }

  initSelectedList(bool value) {
    isSelectedList.clear();
    for (int i = 0; i < submitList.length; i++) {
      isSelectedList.add(value);
    }
  }

  initDataRowList() async {
    dataRowList.clear();
    for (int i = 0; i < submitList.length; i++) {
      Submit submit = submitList[i];
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(submit.createTime),
      );
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
              dateTime.toString().substring(0, 16),
              style: MyTextStyle.textStyle,
            ),
          ),
        ],
      );
      dataRowList.add(row);
    }
    setState(() {});
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
}
