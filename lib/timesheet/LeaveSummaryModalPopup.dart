class LeaveSummaryModalPopup {
  final String LeaveTimeInMinutes;
  final String Remarks;
  final String LeaveDate;

  LeaveSummaryModalPopup({
    required this.LeaveTimeInMinutes,
    required this.Remarks,
    required this.LeaveDate,
  });

  factory LeaveSummaryModalPopup.fromJson(Map<String, dynamic> json) {
    return LeaveSummaryModalPopup(
      LeaveTimeInMinutes: json['LeaveTimeInMinutes'] ?? '',
      Remarks: json['Remarks'] ?? '',
      LeaveDate: json['LeaveDate'] ?? '',
    );
  }
}
