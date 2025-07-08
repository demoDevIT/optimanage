class TaskSummaryModalPopup {
  final String strTaskStauts;
  final String TaskName;
  final int TimeSheetID;
  final String SubTaskDescription;
  final String SubTaskShortDescription;
  final String TaskDescription;
  final String TaskShortDescription;
  final String TaskTime;
  final String EntryDate;
  final String EntryDate_DDMMYYYY;
  final int TaskTimeInMinut;
  final String ProjectName;
  final int TaskType;
  final String strTaskType;
  final String strTotalTime1;
  final int TaskStatus;
  final String StartTime;
  final String EndTime;
  final String TobeRemoveStatus;
  final String CreatedDate;
  final String CreatedTime;
  final int EmployeeId;
  final String strTotalTime;

  TaskSummaryModalPopup({
    required this.strTaskStauts,
    required this.TaskName,
    required this.TimeSheetID,
    required this.SubTaskDescription,
    required this.SubTaskShortDescription,
    required this.TaskDescription,
    required this.TaskShortDescription,
    required this.TaskTime,
    required this.EntryDate,
    required this.EntryDate_DDMMYYYY,
    required this.TaskTimeInMinut,
    required this.ProjectName,
    required this.TaskType,
    required this.strTaskType,
    required this.strTotalTime1,
    required this.TaskStatus,
    required this.StartTime,
    required this.EndTime,
    required this.TobeRemoveStatus,
    required this.CreatedDate,
    required this.CreatedTime,
    required this.EmployeeId,
    required this.strTotalTime,
  });

  factory TaskSummaryModalPopup.fromJson(Map<String, dynamic> json) {
    return TaskSummaryModalPopup(
      strTaskStauts: json["strTaskStauts"],
      TaskName: json["TaskName"],
      TimeSheetID: json["TimeSheetID"],
      SubTaskDescription: json["SubTaskDescription"],
      SubTaskShortDescription: json["SubTaskShortDescription"],
      TaskDescription: json["TaskDescription"],
      TaskShortDescription: json["TaskShortDescription"],
      TaskTime: json["TaskTime"],
      EntryDate: json["EntryDate"],
      EntryDate_DDMMYYYY: json["EntryDate_DDMMYYYY"],
      TaskTimeInMinut: json["TaskTimeInMinut"],
      ProjectName: json["ProjectName"],
      TaskType: json["TaskType"],
      strTaskType: json["strTaskType"],
      strTotalTime1: json["strTotalTime1"],
      TaskStatus: json["TaskStatus"],
      StartTime: json["StartTime"],
      EndTime: json["EndTime"],
      TobeRemoveStatus: json["TobeRemoveStatus"],
      CreatedDate: json["CreatedDate"],
      CreatedTime: json["CreatedTime"],
      EmployeeId: json["EmployeeId"],
      strTotalTime: json["strTotalTime"],
    );
  }
}
