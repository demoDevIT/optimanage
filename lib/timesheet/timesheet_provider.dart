import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:optimanage/timesheet/CalendraModel.dart';
import 'package:optimanage/timesheet/drop_down_screen.dart';

import '../main.dart';
import '../notaskassign/notaskassign_provider.dart';
import '../notaskassign/notaskassign_sceen.dart';
import '../utils/PrefUtil.dart';
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
import 'package:flutter_svg/flutter_svg.dart';

class timesheet_provider extends ChangeNotifier {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay;
  bool _showLeaveDetails = false;
  bool _showdailyDetails = false;
  BuildContext context;
  String leaveType = "Half Day";
  List<TaskSummaryModalPopup> taskSummaries = [];
  bool _isSnackBarVisible = false;
  List<LeaveSummaryModalPopup> leaveSummaries = [];

  timesheet_provider(this.context) {}

  bool get showLeaveDetails => _showLeaveDetails;

  bool get showdailyDetails => _showdailyDetails;

  Map<String, Color> get statusColorMap => {};

  // String get leaveType => _leaveType;

  final List<String> leaveTypes = [
    "Half Day",
    "Full Day",
    "Early Going",
    "Late Coming",
  ];
  bool status = false;
  String query = "";
  String? selectedLeave;

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

  //int userId = 55; // Set this based on logged-in user

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

  // void showSelectDateBottomSheet(
  //     BuildContext context, String title, DateTime date, double height) {
  //   showLeaveDetails = true;
  //   notifyListeners();
  // }

  Future<void> showSelectDateBottomSheethjgh(
    BuildContext context, {
    required String status,
    required DateTime focusedDay,
    double topMargin = 50,
  }) async {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return  Container(
    //       margin: EdgeInsets.only(top: 50),
    //       child: DropDownScreen(
    //         type: status,
    //         date: focusedDay,
    //       ),
    //     ); // call the custom dialog
    //
    //   },
    //
    // );

    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // remove default rounded background
      builder: (context) => FractionallySizedBox(
        heightFactor: topMargin, // 60% of screen height
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: DropDownScreen(
            type: status,
            date: focusedDay,
          ),
        ),
      ),
    );

    if (result != null) {
      notifyListeners();
    }
  }

  void showSelectDateBottomSheet(
      BuildContext context, String type, DateTime date, double getHeight) {
    print("11Selected Date: $type");
    print("showNoTaskBottomSheet5555");
    resetLeaveForm();
    leaveType = "Half Day";
    status = false;
    final _formKey = GlobalKey<FormState>();
    final TextEditingController remarksController = TextEditingController();
    // final parentContext = context;
    String? timeError;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        String? leaveTypeError;
        return SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: StatefulBuilder(// You need this, notice the parameters below:
              builder: (BuildContext context, StateSetter setState) {
            getHeight = (type == 'No Task Assigned')
                ? 0.3
                : leaveType == 'Full Day'
                    ? 0.45
                    : 0.60; // tweak
            //String? timeError;
            //  return DraggableScrollableSheet(
            //       expand: false,
            //       initialChildSize: getHeight ,//0.3, // 60% of screen height
            //       minChildSize:getHeight,
            //       maxChildSize: 0.95,
            //  builder: (context, scrollController){
            return Wrap(
              runSpacing: 7,
              children: [
                Column(
                  children: [
                    Visibility(
                      visible: type == "No Task Assigned",
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, left: 10, right: 10),
                        // tighter padding
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Expanded(
                                  child: Text(
                                    'optimanage.devitsandbox.com Says',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, size: 20),
                                  padding: EdgeInsets.zero,
                                  // Remove icon padding
                                  constraints: BoxConstraints(),
                                  // Shrink tap area
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),

                            const SizedBox(height: 5),
                            // Smaller spacing

                            // Warning Message
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
                                        'Kindly please add task carefully. If you haven\'t mapped with a Module then contact your team lead for the same. Task added in No Task will not be considered for your performance evaluation.',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 6),

                            // OK Button aligned right
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  Navigator.pop(context);
                                  int userId =
                                      await PrefUtil.getPrefUserId() ?? 0;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ChangeNotifierProvider(
                                        create: (_) => NoTaskAssignProvider(),
                                        child: NoTaskAssignScreen(
                                          selectedDate: DateTime.now(),
                                          userId: userId,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF25507C),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 8),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  minimumSize: Size(
                                      0, 0), // Important: Shrink button height
                                ),
                                child: const Text(
                                  'OK',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // visible: type == "Add Leave" ? true : false,
                    Visibility(
                        visible: type == "Add Leave" ? true : false,
                        child: Form(
                            key: _formKey,
                            //  child: SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                        "Mark Leave (${date.toIso8601String().split('T').first})",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF000000),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: IconButton(
                                        icon: const Icon(Icons.close),
                                        onPressed: () {
                                          resetLeaveForm(); // 🧹 optional second cleanup
                                          Navigator.pop(context);
                                        },
                                      ),
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
                                InkWell(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    status = !status;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F8FF),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFDDDDDD),
                                          width: 2),
                                    ),
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        inputDecorationTheme:
                                            const InputDecorationTheme(
                                          border: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          focusedBorder: InputBorder.none,
                                          errorBorder: InputBorder.none,
                                          disabledBorder: InputBorder.none,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                      child: DropdownButtonFormField<String>(
                                        value: leaveType,
                                        items: leaveTypes.map((type) {
                                          return DropdownMenuItem(
                                            value: type,
                                            child: Text(
                                              type,
                                              style: const TextStyle(
                                                  color: Colors
                                                      .grey), // optional: grey text
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: null,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          // labelText: "Leave Type",// removes border
                                          enabledBorder: InputBorder.none,
                                          // removes underline when not focused
                                          focusedBorder: InputBorder.none,
                                          // removes underline when focused
                                          errorBorder: InputBorder.none,
                                          // removes underline when error
                                          disabledBorder: InputBorder.none,
                                          // removes underline when disabled
                                          contentPadding: EdgeInsets
                                              .zero, // optional: remove extra padding
                                        ),
                                        //dropdownColor: const Color(0xFFF5F8FF), // same bg as your field
                                        elevation: 0,
                                        icon: const Icon(
                                          Icons.arrow_drop_down,
                                          color: Colors
                                              .grey, // optional: grey icon
                                        ),
                                        disabledHint: Text(
                                          leaveType ?? "Leave Type",
                                          style: const TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF444444),
                                          ), // hint when disabled
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (status) // only show when opened
                                  Transform.translate(
                                    offset: const Offset(0, -8),
                                    // 👈 shifts the whole list up by 8 pixels
                                    child: Container(
                                      //color: const Color(0xFFF5F8FF),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5F8FF),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8),
                                        ),
                                        border: Border(
                                          left: BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 2),
                                          right: BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 2),
                                          bottom: BorderSide(
                                              color: Color(0xFFDDDDDD),
                                              width: 2),
                                        ),
                                      ),

                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: leaveTypes.length,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            title: Text(leaveTypes[index]),
                                            onTap: () {
                                              leaveType = leaveTypes[index];
                                              status = false;
                                              query = "";
                                              setState(() {});
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 16),

                                if (leaveType == "Half Day" ||
                                    leaveType == "Early Going" ||
                                    leaveType == "Late Coming") ...[
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: GestureDetector(
                                          onTap: () => selectTime(
                                              context, true, setState),
                                          child: _timeInfo("Start Time",
                                              startTime!.format(context)),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        flex: 5,
                                        child: GestureDetector(
                                          onTap: () => selectTime(
                                              context, false, setState),
                                          child: _timeInfo("End Time",
                                              endTime!.format(context)),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (timeError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, left: 4),
                                      child: Text(
                                        timeError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 5,
                                          child: _timeInfo(
                                              "Leave Hour", leaveHour)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                          flex: 5,
                                          child: _timeInfo(
                                              "Leave Minute", leaveMinute)),
                                    ],
                                  ),
                                  if (leaveTypeError != null)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 6, left: 4),
                                      child: Text(
                                        leaveTypeError!,
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                ],

                                TextFormField(
                                  controller: remarksController,
                                  maxLines: 4,
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    //hintText: 'Description',
                                    labelText: 'Description',
                                    // 👈 Label name at top-left inside border
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    labelStyle: const TextStyle(
                                      color: Color(0xFF6E6A7C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                    ),
                                    filled: true,

                                    fillColor: Color(0xFFF5F9FE),
                                    // Light fill background
                                    contentPadding: const EdgeInsets.all(10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFDDDDDD),
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFDDDDDD), // keep same color to avoid blue underline
                                        width: 2,
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFDDDDDD), // 👈 override red with grey
                                        width: 2,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFDDDDDD), // 👈 keep same grey even on focus
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  validator: (val) =>
                                      (val == null || val.isEmpty)
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
                                        resetLeaveForm(); // 🧹 optional second cleanup
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
                                        final startMinutes =
                                            startTime!.hour * 60 +
                                                startTime!.minute;
                                        final endMinutes = endTime!.hour * 60 +
                                            endTime!.minute;
                                        if (startMinutes >= endMinutes) {
                                          setState(() {
                                            timeError =
                                                'Start time must be before end time';
                                          });
                                          return;
                                        } else {
                                          setState(() {
                                            timeError = null;
                                          });
                                        }
                                        if (leaveType == "Half Day" &&
                                            !(leaveHours == 4 &&
                                                leaveMinutes == 0)) {
                                          print("LH1-$leaveHours");
                                          print("LM1-$leaveMinutes");
                                          setState(() {
                                            leaveTypeError =
                                                'Half Day leave should be exactly 4 hours';
                                          });
                                          return;
                                        } else {
                                          print("LH2-$leaveHours");
                                          print("LM2-$leaveMinutes");
                                          setState(() {
                                            leaveTypeError = null;
                                          });
                                        }

                                        if (_formKey.currentState!.validate()) {
                                          debugPrint(
                                              "❌ Form validation failed");

                                          Navigator.pop(navigatorKey
                                              .currentState!.context);
                                          leaveDate = date;
                                          try {
                                            final start = DateTime(
                                                leaveDate!.year,
                                                leaveDate!.month,
                                                leaveDate!.day,
                                                startTime!.hour,
                                                startTime!.minute);
                                            final end = DateTime(
                                                leaveDate!.year,
                                                leaveDate!.month,
                                                leaveDate!.day,
                                                endTime!.hour,
                                                endTime!.minute);

                                            final duration =
                                                end.difference(start);
                                            leaveHours = duration.inHours;
                                            leaveMinutes =
                                                duration.inMinutes % 60;
                                            final totalMinutes =
                                                duration.inMinutes;

                                            final formattedDate =
                                                formatDate(leaveDate!);
                                            final formattedStart =
                                                formatTimeOfDay(startTime!);
                                            final formattedEnd =
                                                formatTimeOfDay(endTime!);
                                            final remarks =
                                                remarksController.text.trim();

                                            final userId = await PrefUtil
                                                    .getPrefUserId() ??
                                                0;

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
                                              userId: userId,
                                            );
                                            setState(() {});
                                            // await fetchLeaveSummary(
                                            //     focusedDay, userId);
                                            // await fetchTimesheetData(
                                            //     context,
                                            //     focusedDay.month,
                                            //     focusedDay.year,
                                            //     userId);

                                            // Navigator.pop(navigatorKey.currentState!.context);

                                            resetLeaveForm();
                                            //Navigator.pop(navigatorKey.currentState!.context);
                                          } catch (e) {
                                            debugPrint(
                                                "❌ Save button error: $e");
                                          }
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
                            )
                            // ),

                            )
                        // )
                        // )
                        ),
                  ],
                )
              ],
            );

            //  }
            // );
          }),
        ));
      },
    );
  }

  void updateLeaveDuration(StateSetter setState) {
    if (startTime != null && endTime != null && leaveDate != null) {
      final start = DateTime(
        leaveDate!.year,
        leaveDate!.month,
        leaveDate!.day,
        startTime!.hour,
        startTime!.minute,
      );
      final end = DateTime(
        leaveDate!.year,
        leaveDate!.month,
        leaveDate!.day,
        endTime!.hour,
        endTime!.minute,
      );

      final duration = end.difference(start);
      setState(() {
        leaveHours = duration.inHours;
        leaveMinutes = duration.inMinutes % 60;
      });
    }
  }

  void showtaskSummaryBottomSheet(BuildContext context, String type,
      DateTime date, double getHeight, List<TaskSummaryModalPopup> summaries) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;

        return Container(
          height: 500,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Wrap(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "View Hour Summary",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date: ${DateFormat("dd/MM/yyyy").format(date)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...summaries
                        .map((task) => Container(
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
                                  // _buildRow("Task", task.TaskName),
                                  // const SizedBox(height: 10),

                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRow("Timesheet Date", task.EntryDate),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRow("Start Time", task.StartTime),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRow("End Time", task.EndTime),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildRow("Task Time", task.TaskTime),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  _buildRow(
                                    "Status",
                                    task.strTaskStauts,
                                    valueColor:
                                        task.strTaskStauts.toLowerCase() ==
                                                "completed"
                                            ? Colors.green
                                            : Colors.black,
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 8),
                                  _buildRow("Entry Date/Time",
                                      "${task.CreatedDate}, ${task.CreatedTime}"),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Task Name",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    task.TaskName,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "Task Description",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    task.TaskDescription,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const Divider(
                                    thickness: 1,
                                    height: 1,
                                    color: Color(0xFFE2E2E2),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Subtask Description",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    task.SubTaskDescription,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList()
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.normal,
              color: Colors.black87,
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

  void resetLeaveForm() {
    leaveType = "Half Day";
    startTime = TimeOfDay(hour: 10, minute: 0);
    endTime = TimeOfDay(hour: 19, minute: 30);
    leaveHour = "0";
    leaveMinute = "0";
    remarks = "";
    notifyListeners();
  }

  void showCancelLeaveBottomSheet(BuildContext context, String type, leaveID,
      DateTime date, double getHeight) {
    resetLeaveForm();
    final _formKey = GlobalKey<FormState>();
    final TextEditingController remarksController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Header with title + close ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$type (${DateFormat('yyyy-MM-dd').format(date)})",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // --- Description field ---
                      TextFormField(
                        controller: remarksController,
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please add description";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Description",
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // --- Action Buttons ---
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: Color(0xFF25507C),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF25507C),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState?.validate() ?? false) {
                                final userId =
                                    await PrefUtil.getPrefUserId() ?? 0;
                                Navigator.pop(context);
                                await cancelLeaveRequest(
                                  context: context,
                                  leaveId: leaveID,
                                  userId: userId,
                                  // 👈 pass from your leave list
                                  cancelReason: remarksController.text.trim(),
                                );
                              } // hide keyboard
                              // final isValid = _formKey.currentState?.validate() ?? false;
                              // if (!isValid) return;            // ❌ show error under field and stop
                              //
                              // // ✅ proceed only when valid
                              // print("Cancelled leave on ${date.toIso8601String()} "
                              //     "with reason: ${remarksController.text}");
                              // Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel Leave',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> cancelLeaveRequest({
    required BuildContext context,
    required int leaveId,
    required int userId,
    required String cancelReason,
  }) async {
    try {
      final body = {
        "LeaveID": leaveId,
        "CancelReason": cancelReason,
      };

      print("📤 Cancel Leave Request body: $body");

      HttpService http = HttpService(Constants.baseurl, context);
      final response =
          await http.postRequest("/api/Timesheet/AddLeaveCancellation", body);

      print("✅ Cancel Leave Response: ${response.data}");

      if (response.data['State'].toString() == "1" &&
          response.data['Status'].toString() == "true") {
        UtilityClass.showSnackBar(
          navigatorKey.currentState!.context,
          response.data['Message'] ?? "Leave cancelled successfully",
          kPrimaryDark,
        );

        // 🔄 Refresh timesheet data after cancel
        await fetchTimesheetData(
          navigatorKey.currentState!.context,
          focusedDay.month,
          focusedDay.year,
          userId,
        );

        notifyListeners(); // ✅ Close bottomsheet after success
      } else {
        UtilityClass.showSnackBar(
          navigatorKey.currentState!.context,
          response.data['ErrorMessage'] ?? "Failed to cancel leave",
          Colors.red,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Cancel leave error: $e");
      UtilityClass.showSnackBar(context, "Error occurred", Colors.red);
    }
  }

  Future<void> fetchTimesheetData(
      BuildContext context, int month, int year, int userId) async {
    try {
      HttpService http = HttpService(Constants.baseurl, context);

      Map<String, dynamic> inputText = {
        "MonthId": month,
        "YearId": year,
        "UserId": userId,
        //  "RoleId": 5,
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetTimesheetList",
        inputText,
      );

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

          if (employeeData.containsKey(dayKey) &&
              employeeData.containsKey(dateKey)) {
            String colorHex =
                employeeData[dayKey].toString().replaceAll('#', '');
            String dateStr = employeeData[dateKey]
                .toString()
                .replaceAll('[', '')
                .replaceAll(']', '')
                .trim();

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
        await fetchLeaveSummary(focusedDay, userId);

        notifyListeners();
      } else {
        print("❌ No data found in Result.");
      }
    } catch (e) {
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

  void _showSnackBarOnce(String message) {
    if (!_isSnackBarVisible) {
      _isSnackBarVisible = true;
      ScaffoldMessenger.of(navigatorKey.currentState!.context)
          .showSnackBar(SnackBar(content: Text(message)))
          .closed
          .then((_) => _isSnackBarVisible = false); // reset after it disappears
    }
  }

  Future<void> fetchLeaveSummary(DateTime date, int userId) async {
    leaveSummaries = [];
    try {
      HttpService http = HttpService(
        Constants.baseurl,
        navigatorKey.currentState!.context,
      );

      final body = {
        "LeaveMonth": date.month,
        "LeaveYear": date.year,
        "UserId": userId
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetLeaveSummaryList",
        body,
      );
      if (response.data['State'].toString() == "1" &&
          response.data['Status'].toString() == "true") {
        final resultString = response.data['Result'];

        if (resultString != null) {
          final List decodedList = jsonDecode(resultString);

          leaveSummaries = decodedList
              .map((item) => LeaveSummaryModalPopup.fromJson(item))
              .toList();
        } else {
          leaveSummaries = [];
        }
      } else {}
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
      // // ✅ Parse StartTime & EndTime into DateTime
      // final start = DateTime.parse("$startTime");
      // final end = DateTime.parse("$endTime");
      // final difference = end.difference(start).inMinutes;

      // ✅ Check condition for Half Day leave
      // if (leaveType == "Half Day" && leaveHours != 4 && leaveMinutes != 0) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Alert"),
      //       content: Text("Half Day leave should be 4 hours."),
      //       actions: [
      //         TextButton(
      //           onPressed: () => Navigator.pop(context),
      //           child: Text("OK"),
      //         ),
      //       ],
      //     ),
      //   );
      //   return;
      // }

      final body = {
        "LeaveID": 0,
        "LeaveType": leaveType,
        "LeaveDate": leaveDate,
        "StartTime": startTime,
        "EndTime": endTime,
        "LeaveHours": leaveHours,
        "LeaveMinutes": leaveMinutes,
        "LeaveTimeInMinutes": leaveTimeInMinutes,
        "Remarks": remarks,
        "IsApproved": 0,
        "UserId": userId,
      };

      print("📤 Request body: $body");

      HttpService http = HttpService(Constants.baseurl, context);
      final response =
          await http.postRequest("/api/Timesheet/AddResourceLeave", body);
      print("✅ Response: ${response.data}");

      //final success = response.data['State'];
      // final errorMessage =response.data['ErrorMessage'] ?? "Failed to add leave";

      if (response.data['State'].toString() == "1" &&
          response.data['Status'].toString() == "true") {
        UtilityClass.showSnackBar(navigatorKey.currentState!.context,
            response.data['Message'] ?? "Leave added", kPrimaryDark);
        print("1111111111111");

        // Refresh calendar + timesheet data
        await fetchTimesheetData(navigatorKey.currentState!.context,
            focusedDay.month, focusedDay.year, userId);
        // Close modal
      } else {
        print("2222222222222");
        UtilityClass.showSnackBar(navigatorKey.currentState!.context,
            response.data['ErrorMessage'].toString(), Colors.red);
        // await fetchLeaveSummary(focusedDay, userId);
        // await fetchTimesheetData(
        //     context, focusedDay.month, focusedDay.year, userId);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Submit leave error: $e");
      UtilityClass.showSnackBar(context, "Error occurred", Colors.red);
    }
  }

  Future<void> fetchTaskSummary(
      DateTime date, int userId, BuildContext context) async {
    taskSummaries.clear();
    try {
      HttpService http = HttpService(Constants.baseurl, context);

      print("✅ GetHourSummaryList request date: ${date}");

      final formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final body = {
        "FromDate": formattedDate, //"2025-06-18",
        "ToDate": formattedDate, //"2025-06-18",
        "UserId": userId // 55
      };

      final response = await http.postRequest(
        "/api/Timesheet/GetHourSummaryList",
        body,
      );

      if (response.data['State'].toString() == "1" &&
          response.data['Status'].toString() == "true") {
        final resultString = response.data['Result'];

        final List decodedList = jsonDecode(resultString);

        taskSummaries = decodedList
            .map((item) => TaskSummaryModalPopup.fromJson(item))
            .toList();

        if (taskSummaries.isNotEmpty) {
          showtaskSummaryBottomSheet(
            context,
            "Add Leave",
            selectedDay!,
            0.75,
            taskSummaries,
          );
        } else {
          _showSnackBarOnce("No task summary available.");
          // ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
          //   SnackBar(content: Text("No task summary available.")),
          // );
        }
      } else {
        _showSnackBarOnce("No task summary available.");
        // ScaffoldMessenger.of(navigatorKey.currentState!.context).showSnackBar(
        //   SnackBar(content: Text("No task summary available.")),
        // );
        taskSummaries = [];
      }

      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching task summary: $e");
      taskSummaries = [];
      notifyListeners();
    }
  }

  Future<void> selectTime(
      BuildContext context, bool isStart, StateSetter setState) async {
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

          // ✅ update both string and int values
          leaveHours = diff ~/ 60;
          leaveMinutes = diff % 60;

          leaveHour = leaveHours.toString();
          leaveMinute = leaveMinutes.toString();
        } else {
          leaveHours = 0;
          leaveMinutes = 0;
          leaveHour = "0";
          leaveMinute = "0";
        }
      });
    }
  }

  Widget _timeInfo(String label, String value) {
    return Wrap(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: Color(0xFFF5F9FE), // ✅ Match dropdown background
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFDDDDDD), // ✅ Same grey border
              width: 2,
            ),
            // Rounded corners
            // Removed border
          ),
          child: Row(
            children: [
              // Image.asset(
              //   'assets/icons/clockOLD.png',
              //   width: 20,
              //   height: 20,
              // ),
              SvgPicture.asset(
                'assets/icons/clock.svg',
                width: 20,
                height: 20,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                  const SizedBox(width: 20),
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
            ],
          ),
        )
      ],
    );
  }
}
