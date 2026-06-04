class ResultData {
  dynamic data;
  bool isSuccess;
  int code;
  String message;


  ResultData(this.isSuccess, this.code, this.message, {this.data});
}
