import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../notaskassign/notaskassign_sceen.dart';
import '../utils/UtilityClass.dart';
import 'ApprovalModalPopup.dart';
import 'package:optimanage/services/HttpService.dart';
import 'package:optimanage/constant/Constants.dart';
import 'package:dio/dio.dart';
import 'package:optimanage/timesheet/TaskSummaryModalPopup.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class timesheet_provider extends ChangeNotifier {
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
  void loadHardcodedColorsForJuly2025() {
    final Map<String, String> apiData = {
      "Day1": "#AED6F1",
      "Day2": "#90EE90",
      "Day3": "#90EE90",
      "Day4": "#90EE90",
      "Day5": "#90EE90",
      "Day6": "#90EE90",
      "Day7": "#AED6F1",
      "Day8": "#AED6F1",
      "Day9": "#90EE90",
      "Day10": "#90EE90",
      "Day11": "#90EE90",
      "Day12": "#90EE90",
      "Day13": "#AED6F1",
      "Day14": "#AED6F1",
      "Day15": "#90EE90",
      "Day16": "#90EE90",
      "Day17": "#AED6F1",
      "Day18": "#90EE90",
      "Day19": "#90EE90",
      "Day20": "#AED6F1",
      "Day21": "#AED6F1",
      "Day22": "#90EE90",
      "Day23": "#90EE90",
      "Day24": "#90EE90",
      "Day25": "#AED6F1",
      "Day26": "#90EE90",
      "Day27": "#90EE90",
      "Day28": "#AED6F1",
      "Day29": "#AED6F1",
      "Day30": "#90EE90",
      "Day31": "#90EE90",
    };

    final now = DateTime.now();
    final year = 2025;
    final month = 7;

    _dayColorHexes.clear();
    statuses.clear();

    apiData.forEach((key, hex) {
      final dayNum = int.tryParse(key.replaceAll("Day", ""));
      if (dayNum != null) {
        final date = DateTime(year, month, dayNum);
        _dayColorHexes[date] = hex;
        statuses[date] = hexToColor(hex);
      }
    });

    notifyListeners();
  }

  void showSelectDateBottomSheet(
      BuildContext context, String status, DateTime focusedDay, double height) {
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
    leaveType = "Half Day";
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
                  Visibility(
                      visible: type == "Add Leave" ? true : false,
                      // child: SingleChildScrollView(
                      // child: Padding(
                      //     padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 0,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                        ),
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
                                    indent: 0, // ✅ No left margin
                                    endIndent: 0, // ✅ No right margin
                                  ),

                                  const SizedBox(height: 12),
                                  DropdownButtonFormField<String>(
                                    value: leaveType,
                                    icon: const SizedBox.shrink(),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Color(0xFFF5F9FE),
                                     // labelText: "Leave Type",
                                      labelStyle: TextStyle(color: Color(0xFF25507C)),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none, // No border
                                      ),
                                      suffixIcon: Icon(
                                        Icons.arrow_drop_down,
                                        size: 30, // ✅ Increase arrow size
                                        color: Color(0xFF25507C),
                                      ),
                                    ),
                                    items: ["Half Day", "Full Day"]
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
                                  ),

                                  const SizedBox(height: 16),
                                  if (leaveType == "Half Day") ...[
                                    Row(
                                      children: [
                                        _timeInfo("Start Time", "10:00 AM"),
                                        const SizedBox(width: 12),
                                        _timeInfo("End Time", "7:30 PM"),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        _timeInfo("Leave Hour", "4"),
                                        const SizedBox(width: 12),
                                        _timeInfo("Leave Minute", "50"),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                  TextFormField(
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      hintText: 'Description',
                                      filled: true,
                                      fillColor: Color(0xFFF5F9FE),
                                      // Light fill background
                                      contentPadding: const EdgeInsets.all(10),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none, // No border
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide(
                                            color: Color(0xFF2196F3),
                                            width: 2), // Blue border on focus
                                      ),
                                    ),
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
                                          padding: EdgeInsets.symmetric(
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
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigator.pop(context);
                                          // showModalBottomSheet(
                                          //   context: context,
                                          //   isScrollControlled: true,
                                          //   backgroundColor: Colors.transparent,
                                          //   builder: (_) =>
                                          //   const ApprovalModalPopup(),
                                          // );
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

  Future<void> fetchTimesheetData(BuildContext context) async {
    try {
      UtilityClass.showProgressDialog(context, 'Please wait...');

      HttpService http = HttpService('https://optimanageapi.devitsandbox.com');

      Map<String, dynamic> inputText = {
        "MonthId": 6,
        "YearId": 2025,
        "UserId": 44,
        "RoleId": 5,
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetTimesheetList",
        inputText,
      );

      UtilityClass.dismissProgressDialog();
      print("✅ calendar Response: ${response.data}");

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

  Future<void> fetchTaskSummary(DateTime date, int userId) async {
    HttpService http = HttpService('https://optimanageapi.devitsandbox.com');

    final body = {
      "ProjectId": 0,
      "FromDate": date.toIso8601String().split('T')[0],
      "ToDate": date.toIso8601String().split('T')[0],
      "UserId": userId,
      "SearchText": ""
    };

    try {
      final response = await http.postRequest(
        "/api/Timesheet/GetTaskSummaryList",
        body,
      );

      UtilityClass.dismissProgressDialog();
      print("✅ task summary Response: ${response.data}");

      final resultString = response.data['Result'];

      if (resultString != null) {
        final List decodedList = jsonDecode(resultString);

        taskSummaries = decodedList
            .map((item) => TaskSummaryModalPopup.fromJson(item))
            .toList();

        notifyListeners();
      } else {
        print("⚠️ Empty result from API");
        taskSummaries = []; // Reset
        notifyListeners();
      }
    } catch (e) {
      print("❌ Error fetching task summary: $e");
    }
  }



  // void showtaskSummaryBottomSheet(
  //     BuildContext context, String type, DateTime date, double getHeight) {
  //   leaveType = "Half Day";
  //
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return FractionallySizedBox(
  //         heightFactor: getHeight, // Adjust as needed
  //         child: Container(
  //           decoration: const BoxDecoration(
  //             color: Colors.white, // Set background to white
  //             borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //           ),
  //           padding: const EdgeInsets.all(16),
  //           child: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Center(
  //                   child: Text(
  //                     "View Hour Summary",
  //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
  //                   ),
  //                 ),
  //                 const SizedBox(height: 10),
  //                 const Text(
  //                   "Date: 01/04/2025 and Resource: undefined",
  //                   style: TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 12),
  //                 Container(
  //                   width: double.infinity,
  //                   padding: const EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     color: Color(0xFFF5F9FE),
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       const Text(
  //                         "RajKisan_2024_25",
  //                         style: TextStyle(
  //                           fontWeight: FontWeight.w600,
  //                           fontSize: 16,
  //                           height: 1.6,
  //                         ),
  //                       ),
  //                       const SizedBox(height: 10),
  //
  //                       _buildRow("Timesheet Date", "01-04-2025"),
  //                       const Divider(
  //                         color: Color(0xFFE2E2E2), // light grey line
  //                         thickness: 1,
  //                         height: 20,
  //                       ),
  //
  //                       _buildRow("Start Time", "10:00 AM"),
  //                       const Divider(
  //                         color: Color(0xFFE2E2E2), // light grey line
  //                         thickness: 1,
  //                         height: 20,
  //                       ),
  //
  //                       _buildRow("End Time", "07:00 PM"),
  //                       const Divider(
  //                         color: Color(0xFFE2E2E2), // light grey line
  //                         thickness: 1,
  //                         height: 20,
  //                       ),
  //
  //                       _buildRow("Task Time", "9 Hr 0 Min"),
  //                       const Divider(
  //                         color: Color(0xFFE2E2E2), // light grey line
  //                         thickness: 1,
  //                         height: 20,
  //                       ),
  //
  //                       _buildRow("Status", "Completed", valueColor: Colors.green),
  //                       const Divider(
  //                         color: Color(0xFFE2E2E2), // light grey line
  //                         thickness: 1,
  //                         height: 20,
  //                       ),
  //
  //                       _buildRow("Entry Date/Time", "04-04-2025, 11:02 AM"),
  //
  //                       const SizedBox(height: 12),
  //                       const Text(
  //                         "Task Description",
  //                         style: TextStyle(fontWeight: FontWeight.w600),
  //                       ),
  //                       const SizedBox(height: 4),
  //                       const Text(
  //                         "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s....",
  //                         style: TextStyle(color: Colors.black54),
  //                       ),
  //                     ],
  //                   ),
  //
  //                 ),
  //
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showtaskSummaryBottomSheet(
      BuildContext context, String type, DateTime date, double getHeight, List<TaskSummaryModalPopup> summaries) {
    leaveType = "Half Day";
    //final provider = Provider.of<timesheet_provider>(context, listen: false);

    fetchTaskSummary(date, 55).then((_) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: getHeight,
            child: Consumer<timesheet_provider>(
              builder: (context, provider, _) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
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
                          "Date: ${DateFormat("dd-MM-yyyy").format(date)}",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        ...provider.taskSummaries.map((task) => Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F9FE),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.projectName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _buildRow("Employee", task.employeeName),
                              _buildRow("Total Tasks", task.totalTasks.toString()),
                              _buildRow("Completed", task.completedTasks.toString()),
                              _buildRow("Pending", task.pendingTasks.toString()),
                              _buildRow("Estimated", task.estimateTaskDuration),
                              _buildRow("Utilized", task.utilizedDuration),
                              _buildRow("Completion Rate", "${task.completionRate}%"),
                              _buildRow(
                                "Quality",
                                task.taskQuality,
                                //valueColor: HexColor(task.taskQualityColor),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      );
    });
  }

  Map<String, Color> get statusColorMap => {};

  Widget _buildRow(String label, String value, {Color valueColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 14,
                color: valueColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
