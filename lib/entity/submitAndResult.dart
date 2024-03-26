import 'package:auto_test_front/entity/result.dart';
import 'package:auto_test_front/entity/submit.dart';

class SubmitAndResult {
  Submit submit;
  List<Result> resultList;

  SubmitAndResult(
    this.submit,
    this.resultList,
  );

  static SubmitAndResult objToSubmit(Map<String, dynamic> map) {
    Map<String, dynamic> submitMap = map["submit"];
    List<dynamic> resultMapList = map["resultList"];
    Submit submit = Submit.objToSubmit(submitMap);
    List<Result> resultList = [];
    for (Map<String, dynamic> resultMap in resultMapList) {
      resultList.add(Result.objToResult(resultMap));
    }
    return SubmitAndResult(submit, resultList);
  }
}
