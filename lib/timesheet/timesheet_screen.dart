import 'package:flutter/material.dart';
import 'package:optimanage/RD/rd_screen.dart';
import 'package:optimanage/timesheet/timesheet_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:ui';

import '../assignedtask/assignedtask_screen.dart';
import '../constant/common.dart';
import '../notaskassign/notaskassign_sceen.dart';
import '../selftask/selftask_provider.dart';
import '../selftask/selftask_screen.dart';
import '../utils/UtilityClass.dart';

class TimeSheetScreen extends StatefulWidget {
  final String? status;

  const TimeSheetScreen({Key? key, this.status}) : super(key: key);

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  var provider;

  // @override
  // void initState() {
  //   super.initState();
  //   provider = Provider.of<timesheet_provider>(context, listen: false);
  //   if (widget.status == "daily") {
  //     provider.showLeaveDetails = true;
  //     provider.showdailyDetails = false;
  //   } else {
  //     provider.showLeaveDetails = false;
  //     provider.showdailyDetails = true;
  //   }
  // }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider = Provider.of<timesheet_provider>(context, listen: false);

      final now = DateTime.now(); // 👈 Get current date
      provider.focusedDay = now;
      provider.selectedDay = now;

      provider.fetchTimesheetData(context, now.month, now.year);
      //provider.fetchTimesheetData(context);


      if (widget.status == "daily") {
        provider.showLeaveDetails = true;
        provider.showdailyDetails = false;
      } else {
        provider.showLeaveDetails = false;
        provider.showdailyDetails = true;
      }
    });
  }


  @override
  void dispose() {
    provider.showLeaveDetails = false;
    provider.showdailyDetails = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: ,
      appBar: common.Appbar(
        title: "Time Sheet",
        callback: () {
          Navigator.of(context).pop(false);
        },
        actions: [
          // LanguageToggleSwitch(),
          Image.asset(
            'assets/icons/notification.png',
            width: 24,
            height: 24,
          ),
          SizedBox(width: 10),
        ],
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 80),
          child: Consumer<timesheet_provider>(
            builder: (context, provider, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  focusedDay: provider.focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  calendarFormat: CalendarFormat.month,
                  onPageChanged: (focusedDay) {
                    provider.focusedDay = focusedDay;
                    provider.selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
                    provider.fetchTimesheetData(context, focusedDay.month, focusedDay.year);
                  },
                  selectedDayPredicate: (day) =>
                      isSameDay(provider.selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      provider.selectedDay = selectedDay;
                      provider.focusedDay = focusedDay;
                      final isWeekend =
                          selectedDay.weekday == DateTime.saturday ||
                              selectedDay.weekday == DateTime.sunday;

                    //  print("Selected date${selectedDay}");
                    //  print("Selected day${focusedDay}");
                    //  print("Selected date${widget.status}");
                      if (widget.status != "daily" && !isWeekend) {
                        provider.showSelectDateBottomSheet(
                            context, "Add Leave", provider.selectedDay!, 550);
                      } else if (widget.status != "daily" && isWeekend) {
                        // Optional: show toast/snackbar or do nothing
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Alert"),
                            backgroundColor: Colors.white,
                            content: const Text(
                                "It's a weekend, you can't apply leave."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else if (widget.status == "daily" && !isWeekend) {
                        UtilityClass.showProgressDialog(context, 'Please wait...');
                        provider.fetchTaskSummary(provider.selectedDay!, 55);
                        Navigator.pop(context); // close progress dialog

                        if (provider.taskSummaries.isNotEmpty) {
                          provider.showtaskSummaryBottomSheet(
                            context,
                            "Add Leave",
                            provider.selectedDay!,
                            0.75,
                            provider.taskSummaries,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No task summary available.")),
                          );
                        }
                      }

                    });
                  },
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    todayDecoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      shape: BoxShape.circle,
                      // borderRadius: BorderRadius.circular(10),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      shape: BoxShape.circle,
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: Color(0xFF25507C),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, _) {
                      final normalizedDay = DateTime(day.year, day.month, day.day);
                      final color = provider.statuses[normalizedDay];

                      final isWeekend = day.weekday == DateTime.saturday ||
                          day.weekday == DateTime.sunday;

                    //  final backgroundColor = color ?? (isWeekend ? provider.weekendColor : Colors.transparent);
                      final backgroundColor = color ?? (Colors.transparent);
                    //  print("Day: $normalizedDay | Color: ${provider.statuses[normalizedDay]}");

                      return Container(
                        width: 35,
                        height: 35,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${day.day}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      );
                    },
                  ),

                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLegend('Holiday', Colors.purple.shade100),
                          _buildLegend('No Entry', Colors.red.shade300),
                          _buildLegend('Not Engaged', Colors.grey.shade400),
                          _buildLegend('Leave', Colors.grey.shade600),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildLegend('Partial Leave', Colors.orange.shade300),
                          _buildLegend('Entry', Colors.green.shade300),
                          _buildLegend('Partial Entry', Colors.yellow.shade600),
                          _buildLegend('Weekend', Colors.blue.shade200),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                provider.showLeaveDetails ? _buildTaskOptions() : Container(),
                provider.showdailyDetails
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildLeaveSummaryBox(provider))
                    : Container(),
              ],
            ),
          ),
        ),
      ),

      // added button in footer
      bottomNavigationBar: Consumer<timesheet_provider>(
        builder: (context, provider, child) {
          return provider.showLeaveDetails
              ? Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelfTaskScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25507C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  '+ Add Self Task',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
              : const SizedBox.shrink(); // No button when showLeaveDetails is false
        },
      ),
      // added button in footer
    );
  }

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildLeaveSummaryBox(timesheet_provider provider) {
    return GestureDetector(
      onTap: () {
        // setState(() {
        //   provider.showLeaveDetails = true;
        // });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF25507C),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                children: [
                  Text("01",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Text("JAN",
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leave applied for: 8 Hr 0 Min",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25507C),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text("Reason: I was on full day leave",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 28,
              color: Color(0xFF69695D),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            common.formatDate(provider.selectedDay ?? DateTime.now()),
            // <-- Uses your date formatter
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFF25507C),
            ),
          ),

          const SizedBox(height: 10),
          _buildTaskOptionButton("No Task Assigned"),
          _buildTaskOptionButton("R&D"),
          // _buildTaskOptionButton("Add Leave"),
          _buildTaskOptionButton("Assigned Task"),

          // remove button from here
          // const SizedBox(height: 12),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       // Add Self Task logic here
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => SelfTaskScreen(),
          //           // Make sure this matches your import
          //         ),
          //       );
          //     },
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: const Color(0xFF25507C),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       padding: const EdgeInsets.symmetric(vertical: 14),
          //     ),
          //     child: const Text(
          //       '+ Add Self Task',
          //       style: TextStyle(
          //         fontSize: 16,
          //         color: Colors.white, // updated text color
          //       ),
          //     ),
          //   ),
          // ),
          // remove button from here
        ],
      ),
    );
  }

  Widget _buildTaskOptionButton(String label) {
    var provider = Provider.of<timesheet_provider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 42, // Reduced height
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        visualDensity: const VisualDensity(vertical: -4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        title: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF25507C),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF25507C),
        ),
        onTap: () {
          if (label == 'Add Leave') {
            // _showAddLeaveModal(
            //     context, DateTime(2025, 4, 30)); // or selectedDate
            provider.showNoTaskBottomSheet(
                context, "Add Leave", DateTime(2025, 4, 30), 550);
          } else if (label == 'No Task Assigned') {
            //showNoTaskDialog(context);
            provider.showNoTaskBottomSheet(
                context, "No Task Assigned", DateTime(2025, 4, 30), 280);
          } else if (label == 'R&D') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RdScreen(),
                // Make sure this matches your import
              ),
            );
          } else if (label == 'Assigned Task') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AssignedTaskScreen(),
                // Make sure this matches your import
              ),
            );
          }
          // or _selectedDay
        },
      ),
    );
  }

// void _showAddLeaveModal(BuildContext context, DateTime selectedDate) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (context) {
//       return _AddLeaveSheet(date: selectedDate);
//     },
//   );
// }
}

// class _AddLeaveSheet extends StatelessWidget {
//   final DateTime date;
//
//   const _AddLeaveSheet({super.key, required this.date});
//
//   @override
//   Widget build(BuildContext context) {
//     return BackdropFilter(
//       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
//       child: Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//         ),
//         padding: EdgeInsets.only(
//           left: 20,
//           right: 20,
//           top: 20,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     "Mark Leave (${date.toIso8601String().split('T').first})",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: Color(0xFF25507C),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.of(context).pop(),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             DropdownButtonFormField<String>(
//               decoration: const InputDecoration(
//                 labelText: "Leave Type",
//                 border: OutlineInputBorder(),
//               ),
//               items: ["Sick Leave", "Casual Leave", "Earned Leave"]
//                   .map((type) => DropdownMenuItem(
//                         value: type,
//                         child: Text(type),
//                       ))
//                   .toList(),
//               onChanged: (val) {},
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 _timeInfo("Start Time", "10:00 AM"),
//                 const SizedBox(width: 12),
//                 _timeInfo("End Time", "7:30 PM"),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Row(
//               children: [
//                 _timeInfo("Leave Hour", "4"),
//                 const SizedBox(width: 12),
//                 _timeInfo("Leave Minute", "50"),
//               ],
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               maxLines: 4,
//               decoration: InputDecoration(
//                 hintText: 'Description',
//                 filled: true,
//                 fillColor: const Color(0xFFF5F8FA),
//                 // Light fill background
//                 contentPadding: const EdgeInsets.all(10),
//                 enabledBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                       color: Colors.transparent), // No border when not focused
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(12),
//                   borderSide: BorderSide(
//                       color: Color(0xFF2196F3),
//                       width: 2), // Blue border on focus
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end, // Right align
//               children: [
//                 OutlinedButton(
//                   onPressed: () {
//                     // Close action
//                   },
//                   style: OutlinedButton.styleFrom(
//                     side: BorderSide(color: Color(0xFF25507C)),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//                   ),
//                   child: Text(
//                     'Close',
//                     style: TextStyle(
//                       color: Color(0xFF25507C),
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 12), // Space between buttons
//                 ElevatedButton(
//                   onPressed: () {
//
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Color(0xFF25507C), // Save button color
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
//                   ),
//                   child: Text(
//                     'Save',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _timeInfo(String label, String value) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//         decoration: BoxDecoration(
//           border: Border.all(color: Colors.grey.shade300),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               'assets/icons/clock.png',
//               width: 20,
//               height: 20,
//               //color: const Color(0xFF25507C),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label,
//                       style: const TextStyle(fontSize: 10, color: Colors.grey)),
//                   Text(
//                     value,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       color: Color(0xFF25507C),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
