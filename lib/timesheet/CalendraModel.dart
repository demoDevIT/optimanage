class CalendraModel {
  int? state;
  bool? status;
  String? message;
  String? result;

  CalendraModel(
      {this.state,
        this.status,
        this.message,
        this.result});

  CalendraModel.fromJson(Map<String, dynamic> json) {
    state = json['State'];
    status = json['Status'];
    message = json['Message'];
    result = json['Result'];
  }

}