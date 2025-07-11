import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimanage/timesheet/CalendraModel.dart';

import '../notaskassign/notaskassign_sceen.dart';
import '../utils/UtilityClass.dart';
import 'ApprovalModalPopup.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import 'package:dio/dio.dart';
import 'package:optimanage/timesheet/TaskSummaryModalPopup.dart';
import 'package:optimanage/timesheet/LeaveSummaryModalPopup.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'CalendraModel.dart';
import 'package:intl/intl.dart';
import '../utils/UtilityClass.dart';
import 'package:optimanage/constant/colors.dart';

class timesheet_provider extends ChangeNotifier {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool _showLeaveDetails = false;
  bool _showdailyDetails = false;
  BuildContext context;
  String leaveType = "Half Day";

  timesheet_provider(this.context) {}

  bool get showLeaveDetails => _showLeaveDetails;

  bool get showdailyDetails => _showdailyDetails;

  // String get leaveType => _leaveType;

  set showLeaveDetails(bool status) {
    _showLeaveDetails = status;
    notifyListeners();
  }

  set showdailyDetails(bool status) {
    _showdailyDetails = status;
    notifyListeners();
  }

  // set leaveType(String value) {
  //   _leaveType = value;
  //   notifyListeners();
  // }

  // final Map<DateTime, String> statuses = {
  //   DateTime.utc(2025, 6, 17): 'Holiday',
  //   DateTime.utc(2025, 6, 18): 'Entry',
  //   DateTime.utc(2025, 6, 19): 'No Entry',
  //   DateTime.utc(2025, 6, 20): 'Holiday',
  // };

  // final Map<String, Color> statusColorMap = {
  //   'Holiday': Color(0xFFE5C7F0),
  //   'Entry': Color(0xFFA0FFA1),
  //   'No Entry': Color(0xFFFFBABA),
  //   'weekendColor': Color(0xFFD3E8FF),
  //   // Add more as needed
  // };

  // Color status map per day
  Map<DateTime, String> _dayColorHexes = {}; // Raw hexes
  Map<DateTime, Color> statuses = {}; // Mapped colors

  // //final Color weekendColor = Color(0xFFD3E8FF); // Light blue for weekends
  final weekendColor = Colors.blue.shade200;

  // Helper to parse hex string to Color
  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");
    if (hex.length == 6) hex = "FF$hex";
    return Color(int.parse("0x$hex"));
  }

  // Simulate API response (replace with dynamic later)

  TimeOfDay? startTime = TimeOfDay(hour: 10, minute: 0);
  TimeOfDay? endTime = TimeOfDay(hour: 19, minute: 30);
  String leaveHour = "0";
  String leaveMinute = "0";

  // Add at the top of your provider class
  DateTime? leaveDate;
  int leaveHours = 0;
  int leaveMinutes = 0;
  String remarks = "";
  int userId = 55; // Set this based on logged-in user


  String formatDate(DateTime date) {
    return DateFormat('MM/dd/yyyy').format(date);
  }

  String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm').format(dt);
  }



  void loadDynamicColorsFromApi(List<String> dayColors) {
    _dayColorHexes.clear();
    statuses.clear();
    final RegExp dayKeyPattern = RegExp(r'^Day(\d+)$');
    print("APIDATA");
    print("Api response${dayColors}");




    // result?.forEach((key, value) {
    //   final match = dayKeyPattern.firstMatch(key);
    //
    //   if (match != null) {
    //     final dayNum = match.group(1); // e.g., "1"
    //     final dateKey = "Date$dayNum";
    //
    //     if (apiData.containsKey(dateKey)) {
    //       String rawDateStr = apiData[dateKey];
    //       // Clean up possible brackets and whitespaces
    //       String cleanedDate = rawDateStr.replaceAll(RegExp(r'[\[\]\s]'), '');
    //
    //       final parsedDate = DateTime.tryParse(cleanedDate);
    //       if (parsedDate != null) {
    //         final normalizedDate = DateTime(parsedDate.year, parsedDate.month, parsedDate.day);
    //         final hexColor = value.toString();
    //         _dayColorHexes[normalizedDate] = hexColor;
    //         statuses[normalizedDate] = hexToColor(hexColor); // ✅ normalize
    //       }
    //     }
    //   }
    // });

    notifyListeners();
  }

  void showSelectDateBottomSheet(
      BuildContext context, String status, DateTime focusedDay, double height) {
    print("showNoTaskBottomSheet3333");
    showNoTaskBottomSheet(context, status, focusedDay, height);
    notifyListeners();
  }

  // void showSelectDateBottomSheet(
  //     BuildContext context, String title, DateTime date, double height) {
  //   showLeaveDetails = true;
  //   notifyListeners();
  // }

  void showNoTaskBottomSheet(
      BuildContext context, String type, DateTime date, double getHeight) {
    print("showNoTaskBottomSheet5555");
    leaveType = "Half Day";
    final _formKey = GlobalKey<FormState>();
    final TextEditingController remarksController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(// You need this, notice the parameters below:
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              margin: EdgeInsets.only(top: 10),
              height: getHeight,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Visibility(
                    visible: type == "No Task Assigned" ? true : false,
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Header Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'optimanage.devitsandbox.com Says',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close, size: 20),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          /// Warning Message
                          const Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Warning: ',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      'Kindly please add task carefully. If you haven\'t mapped with a Module then contact your team lead for the same. Task added in {No Task} will not be considered for your performance evaluation.',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          /// Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            // Right align
                            children: [
                              // OutlinedButton(
                              //   onPressed: () {
                              //     Navigator.pop(context); // Close the modal
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //           const NoTaskAssignScreen()),
                              //     );
                              //   },
                              //   style: OutlinedButton.styleFrom(
                              //     side: BorderSide(color: Color(0xFF25507C)),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(12),
                              //     ),
                              //     padding: EdgeInsets.symmetric(
                              //         horizontal: 24, vertical: 10),
                              //   ),
                              //   child: Text(
                              //     'Close',
                              //     style: TextStyle(
                              //       color: Color(0xFF25507C),
                              //       fontWeight: FontWeight.w500,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(width: 12),
                              // Space between buttons
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context); // Close the modal
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const NoTaskAssignScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF25507C),
                                  // Save button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 10),
                                ),
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // visible: type == "Add Leave" ? true : false,
                  Visibility(
                      visible: type == "Add Leave" ? true : false,

                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height *
                                  0.85, // Adjust modal height
                            ),
                            child: IntrinsicHeight(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "Mark Leave (${date.toIso8601String().split('T').first})",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                    ],
                                  ),
                                  // ✅ Add horizontal line below title
                                  const Divider(
                                    color: Color(0xFFE6E6E6),
                                    thickness: 1,
                                    height: 1,
                                    indent: 0,
                                    // ✅ No left margin
                                    endIndent: 0, // ✅ No right margin
                                  ),

                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    value: leaveType,
                                    icon: const SizedBox.shrink(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: const Color(0xFFF5F9FE),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 30,
                                        color: Color(0xFF25507C),
                                      ),
                                    ),
                                    items: ["Half Day", "Full Day", "Early Going", "Late Coming"]
                                        .map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(type),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) {
                                        leaveType = val;
                                        notifyListeners();
                                        setState(() {});
                                      }
                                    },
                                    validator: (val) =>
                                    (val == null || val.isEmpty)
                                        ? 'Please select leave type'
                                        : null,
                                  ),

                                  const SizedBox(height: 16),
                                  if (leaveType == "Half Day" || leaveType == "Early Going" ||
                                      leaveType == "Late Coming") ...[
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => selectTime(context, true, setState),
                                            child: _timeInfo("Start Time", startTime!.format(context)),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => selectTime(context, false, setState),
                                            child: _timeInfo("End Time", endTime!.format(context)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _timeInfo("Leave Hour", leaveHour),
                                        const SizedBox(width: 12),
                                        _timeInfo("Leave Minute", leaveMinute),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                  ],

                                  TextFormField(
                                    controller: remarksController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: 'Description',
                                      filled: true,
                                      fillColor: Color(0xFFF5F9FE),
                                      // Light fill background
                                      contentPadding: const EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide:
                                            BorderSide.none, // No border
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xFF2196F3),
                                            width: 2), // Blue border on focus
                                      ),

                                    ),
              validator: (val) => (val == null || val.isEmpty)
              ? 'Please enter a description'
                  : null,

                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    // Right align
                                    children: [
                                      OutlinedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: Color(0xFF25507C)),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 10),
                                        ),
                                        child: Text(
                                          'Close',
                                          style: TextStyle(
                                            color: Color(0xFF25507C),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      // Space between buttons
                                      ElevatedButton(
                                        onPressed: () async {
                                          leaveDate = date;
                                          debugPrint("leaveType: $leaveType");
                                          debugPrint("leaveDate: $leaveDate");
                                          debugPrint("startTime: $startTime");
                                          debugPrint("endTime: $endTime");


                                          if (leaveType == null || leaveDate == null || startTime == null || endTime == null) {
                                            debugPrint("❌ Required fields missing");
                                            return;
                                          }

                                          try {
                                            final start = DateTime(leaveDate!.year, leaveDate!.month, leaveDate!.day, startTime!.hour, startTime!.minute);
                                            final end = DateTime(leaveDate!.year, leaveDate!.month, leaveDate!.day, endTime!.hour, endTime!.minute);

                                            final duration = end.difference(start);
                                            leaveHours = duration.inHours;
                                            leaveMinutes = duration.inMinutes % 60;
                                            final totalMinutes = duration.inMinutes;

                                            final formattedDate = formatDate(leaveDate!);
                                            final formattedStart = formatTimeOfDay(startTime!);
                                            final formattedEnd = formatTimeOfDay(endTime!);
                                            final remarks = remarksController.text.trim();

                                            await submitLeaveRequest(
                                              context: context,
                                              leaveType: leaveType,
                                              leaveDate: formattedDate,
                                              startTime: formattedStart,
                                              endTime: formattedEnd,
                                              leaveHours: leaveHours,
                                              leaveMinutes: leaveMinutes,
                                              leaveTimeInMinutes: totalMinutes,
                                              remarks: remarks,
                                              userId: 55,
                                            );

                                            // ✅ Refresh leave summary and timesheet
                                            await fetchLeaveSummary(focusedDay, userId);
                                            await fetchTimesheetData(context, focusedDay.month, focusedDay.year);

                                            Navigator.pop(context);
                                          } catch (e) {
                                            debugPrint("❌ Save button error: $e");
                                          }
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF25507C),
                                          // Save button color
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 10),
                                        ),
                                        child: Text(
                                          'Save',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      // )
                      // )
                      ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  Widget _timeInfo(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: Color(0xFFF5F9FE), // ✅ Match dropdown background
          borderRadius: BorderRadius.circular(12), // Rounded corners
          // Removed border
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/clock.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF25507C),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> selectTime(BuildContext context, bool isStart, StateSetter setState) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTime! : endTime!,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTime = picked;
        } else {
          endTime = picked;
        }

        final startMinutes = startTime!.hour * 60 + startTime!.minute;
        final endMinutes = endTime!.hour * 60 + endTime!.minute;

        if (endMinutes > startMinutes) {
          final diff = endMinutes - startMinutes;
          leaveHour = (diff ~/ 60).toString();
          leaveMinute = (diff % 60).toString();
        } else {
          leaveHour = "0";
          leaveMinute = "0";
        }
      });
    }
  }

  Future<void> fetchTimesheetData(BuildContext context,   int month, int year) async {
    try {
      UtilityClass.showProgressDialog(context, 'Please wait...');

      HttpService http = HttpService('https://optimanageapi.devitsandbox.com');

      Map<String, dynamic> inputText = {
        "MonthId": month,
        "YearId": year,
        "UserId": 44,
      //  "RoleId": 5,
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetTimesheetList",
        inputText,
      );

      UtilityClass.dismissProgressDialog();
      print("✅ calendar Response: ${response.data}");

      CalendraModel getresponse = CalendraModel.fromJson(response.data);

      _dayColorHexes.clear();
      statuses.clear();

      if (getresponse.result != null && getresponse.result!.isNotEmpty) {
        final List<dynamic> resultList = jsonDecode(getresponse.result!);
        final Map<String, dynamic> employeeData = resultList[0];

        for (int i = 1; i <= 31; i++) {
          String dayKey = 'Day$i';
          String dateKey = 'Date$i';

          if (employeeData.containsKey(dayKey) && employeeData.containsKey(dateKey)) {
            String colorHex = employeeData[dayKey].toString().replaceAll('#', '');
            String dateStr = employeeData[dateKey].toString().replaceAll('[', '').replaceAll(']', '').trim();

            try {
              final date = DateTime.parse(dateStr);
              final color = Color(int.parse('0xFF$colorHex'));
              _dayColorHexes[date] = colorHex;
              statuses[date] = color;
            } catch (e) {
              print("❌ Error parsing Day$i → $e");
            }
          }
        }

        notifyListeners();
      } else {
        print("❌ No data found in Result.");
      }




    } catch (e) {
      UtilityClass.dismissProgressDialog();
      print("❌ Exception while calling API: $e");

      UtilityClass.askForInput(
        'Error',
        'API call failed: $e',
        'OK',
        'Cancel',
        true,
      );
    }
  }

  List<TaskSummaryModalPopup> taskSummaries = [];

  Future<void> fetchTaskSummary(DateTime date, int userId) async
  {
    try {
      HttpService http = HttpService('https://optimanageapi.devitsandbox.com');

      final body = {
        "FromDate": "2025-06-18",
        "ToDate": "2025-06-18",
        "UserId": 55
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetHourSummaryList",
        body,
      );

      final resultString = response.data['Result'];

      if (resultString != null) {
        final List decodedList = jsonDecode(resultString);

        taskSummaries = decodedList
            .map((item) => TaskSummaryModalPopup.fromJson(item))
            .toList();
      } else {
        taskSummaries = [];
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching task summary: $e");
      taskSummaries = [];
      notifyListeners();
    }
  }

  List<LeaveSummaryModalPopup> leaveSummaries = [];

  Future<void> fetchLeaveSummary(DateTime date, int userId) async {
    try {
      HttpService http = HttpService('https://optimanageapi.devitsandbox.com');

      final body = {
        "LeaveMonth": date.month,
        "LeaveYear": date.year,
        "UserId": 55
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetLeaveSummaryList",
        body,
      );

      final resultString = response.data['Result'];

      if (resultString != null) {
        final List decodedList = jsonDecode(resultString);

        leaveSummaries = decodedList
            .map((item) => LeaveSummaryModalPopup.fromJson(item))
            .toList();
      } else {
        leaveSummaries = [];
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching leave summary: $e");
      leaveSummaries = [];
      notifyListeners();
    }
  }

  Future<void> submitLeaveRequest({
    required BuildContext context,
    required String leaveType,
    required String leaveDate,
    required String startTime,
    required String endTime,
    required int leaveHours,
    required int leaveMinutes,
    required int leaveTimeInMinutes,
    required String remarks,
    required int userId,
  }) async {
    try {
      final body = {
        "LeaveType": leaveType,
        "LeaveDate": leaveDate,
        "StartTime": startTime,
        "EndTime": endTime,
        "LeaveHours": leaveHours,
        "LeaveMinutes": leaveMinutes,
        "LeaveTimeInMinutes": leaveTimeInMinutes,
        "Remarks": remarks,
        "UserId": userId,
      };

      HttpService http = HttpService('https://optimanageapi.devitsandbox.com');
      final response = await http.postRequest("/api/Timesheet/AddLeave", body);

      final message = response.data['Message'] ?? "Leave added";
      final success = response.data['State'] == 1;

      if (success) {
        UtilityClass.showSnackBar(context, message, kPrimaryDark);

        // Refresh calendar + timesheet data
        await fetchLeaveSummary(focusedDay, userId);
        await fetchTimesheetData(context, focusedDay.month, focusedDay.year);

        Navigator.pop(context); // Close modal
      } else {
        UtilityClass.showSnackBar(context, "Failed to add leave", Colors.red);
      }
    } catch (e) {
      debugPrint("❌ Submit leave error: $e");
      UtilityClass.showSnackBar(context, "Error occurred", Colors.red);
    }
  }


  void showtaskSummaryBottomSheet(
      BuildContext context,
      String type,
      DateTime date,
      double getHeight,
      List<TaskSummaryModalPopup> summaries) {

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: screenHeight * 0.5, // ✅ Half screen height
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "View Hour Summary",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Date: ${DateFormat("dd/MM/yyyy").format(date)} and Resource: undefined",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 10),

                // ✅ Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: summaries.map((task) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F9FE),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              task.ProjectName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                _buildRow("Timesheet Date", task.EntryDate),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFFE2E2E2),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                _buildRow("Start Time", task.StartTime),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFFE2E2E2),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                _buildRow("End Time", task.EndTime),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFFE2E2E2),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                _buildRow("Task Time", task.TaskTime),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFFE2E2E2),
                                ),
                              ],
                            ),


                            Column(
                              children: [
                                _buildRow(
                                  "Status",
                                  task.strTaskStauts,
                                  valueColor: task.strTaskStauts.toLowerCase() == "completed"
                                      ? Colors.green
                                      : Colors.black,
                                ),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFFE2E2E2),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                _buildRow("Entry Date/Time", "${task.CreatedDate}, ${task.CreatedTime}"),
                                const Divider(
                                  thickness: 1,
                                  height: 1,
                                  color: Color(0xFFE2E2E2),
                                ),
                              ],
                            ),


                            const SizedBox(height: 8),
                            const Text(
                              "Task Description",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              task.TaskShortDescription,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




  Map<String, Color> get statusColorMap => {};

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black,
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }







}
