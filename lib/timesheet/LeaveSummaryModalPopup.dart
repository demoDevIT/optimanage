class LeaveSummaryModalPopup {
  final int LeaveId;
  final String LeaveTimeInMinutes;
  final String Remarks;
  final String LeaveDate;

  LeaveSummaryModalPopup({
    required this.LeaveId,
    required this.LeaveTimeInMinutes,
    required this.Remarks,
    required this.LeaveDate,
  });

  factory LeaveSummaryModalPopup.fromJson(Map<String, dynamic> json) {
    return LeaveSummaryModalPopup(
      LeaveId: json['LeaveId'] ?? '',
      LeaveTimeInMinutes: json['LeaveTimeInMinutes'] ?? '',
      Remarks: json['Remarks'] ?? '',
      LeaveDate: json['LeaveDate'] ?? '',
    );
  }
}
