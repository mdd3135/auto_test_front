import 'dart:convert';

import 'package:auto_test_front/entity/itemBank.dart';
import 'package:auto_test_front/entity/result.dart';
import 'package:auto_test_front/page/favoriteDetailPage.dart';
import 'package:auto_test_front/status.dart';
import 'package:auto_test_front/widget/myTextStyle.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
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
          top: 20,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: height - 160,
              minHeight: height - 160,
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
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
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
                "共$itemBankCount条记录",
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
      Uri.parse(
        "${Status.baseUrl}/getCollectCount?userId=${Status.user.id}",
      ),
    );
    itemBankCount = int.parse(utf8.decode(response.bodyBytes));
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
        "${Status.baseUrl}/getCollectItemByUserId?"
        "userId=${Status.user.id}&count=$count&page=$currentPage",
      ),
    );
    var bodyObj = jsonDecode(utf8.decode(response.bodyBytes));
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
      DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
        int.parse(itemBank.createTime),
      );
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
              style: MyTextStyle.textStyle,
            ),
          ),
          DataCell(
            Text(
              itemBank.description,
              style: MyTextStyle.textStyle,
            ),
          ),
          DataCell(
            Text(
              dateTime.toString().substring(0, 16),
              style: MyTextStyle.textStyle,
            ),
          ),
          DataCell(
            Text(
              itemBank.score.toString(),
              style: MyTextStyle.textStyle,
            ),
          ),
          DataCell(
            TextButton(
              onPressed: () {
                onDetailPressed(itemBank);
              },
              child: Text(
                "查看",
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

  onDetailPressed(ItemBank itemBank) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) {
        return FavoriteDetailPage(
          itemBank: itemBank,
          isSubmited: 0,
          result: Result(0, 0, 0, 0, ""),
        );
      }),
    ).then((value) {
      initData();
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
