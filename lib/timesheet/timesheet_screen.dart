import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optimanage/Home/home_screen.dart';
import 'package:optimanage/RD/rd_screen.dart';
import 'package:optimanage/timesheet/timesheet_provider.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:ui';

import '../assignedtask/assignedtask_provider.dart';
import '../assignedtask/assignedtask_screen.dart';
import '../constant/common.dart';
import '../notaskassign/notaskassign_sceen.dart';
import '../selftask/selftask_provider.dart';
import '../selftask/selftask_screen.dart';
import '../utils/PrefUtil.dart';
import '../utils/UtilityClass.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TimeSheetScreen extends StatefulWidget {
  final String? status;
  final String? screenStatus;

  const TimeSheetScreen({Key? key, this.status, this.screenStatus})
      : super(key: key);

  @override
  State<TimeSheetScreen> createState() => _TimeSheetScreenState();
}

class _TimeSheetScreenState extends State<TimeSheetScreen> {
  var provider;
  int userId = 0; // default fallback

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider = Provider.of<timesheet_provider>(context, listen: false);

      final now = DateTime.now(); // 👈 Get current date

      userId = await PrefUtil.getPrefUserId() ?? 0;

      provider.focusedDay = now;
      provider.selectedDay = now;

      provider.fetchTimesheetData(context, now.month, now.year, userId);
      //provider.fetchTimesheetData(context);
      provider.fetchLeaveSummary(now, userId);

      if (widget.status == "daily") {
        provider.showLeaveDetails = true;
        provider.showdailyDetails = false;
        print("1111111111");
      } else {
        provider.showLeaveDetails = false;
        provider.showdailyDetails = true;
        print("222222222222");
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.showLeaveDetails = false;
      provider.showdailyDetails = false;
    });
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
          if (widget.screenStatus == "1") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          } else {
            Navigator.of(context).pop(false);
          }
        },
         actions: [
        //   // LanguageToggleSwitch(),
        //   SvgPicture.asset(
        //     'assets/icons/notification.svg',
        //     width: 24,
        //     height: 24,
        //   ),
           SizedBox(width: 50),
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
                    // provider.selectedDay = DateTime(focusedDay.year, focusedDay.month, 1);
                    provider.fetchTimesheetData(
                        context, focusedDay.month, focusedDay.year, userId);
                    provider.fetchLeaveSummary(focusedDay, userId);
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

                      // Normalize the date to check provider.statuses
                      final normalizedDay = DateTime(
                          selectedDay.year, selectedDay.month, selectedDay.day);
                      final dayColor = provider.statuses[normalizedDay];

                      if (widget.status != "daily" && !isWeekend) {
                        // print("showNoTaskBottomSheet4444");
                        // provider.showSelectDateBottomSheet(
                        //     context, "Add Leave", provider.selectedDay!, 0.6);
                        if (dayColor != null &&
                            dayColor.value.toRadixString(16).toUpperCase().contains("C39BD3")) {
                          // Show alert if holiday
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Alert"),
                              backgroundColor: Colors.white,
                              content: const Text("You can't apply leave on holiday."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("OK"),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Otherwise show bottom sheet
                          print("showNoTaskBottomSheet4444");
                          provider.showSelectDateBottomSheet(
                              context,  "Add Leave", provider.selectedDay!, 0.6);
                        }

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
                        provider.fetchTaskSummary(
                            provider.selectedDay!, userId, context);
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
                      final normalizedDay =
                          DateTime(day.year, day.month, day.day);
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
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => SelfTaskScreen(),
                        //   ),
                        // );

                        DateTime today = DateTime.now();
                        DateTime selectedDate = provider.selectedDay!;
                        DateTime normalizedToday =
                        DateTime(today.year, today.month, today.day);
                        DateTime normalizedSelected =
                        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

                        bool isFutureDate = normalizedSelected.isAfter(normalizedToday);

                        if (isFutureDate) {
                          // alert for future date
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Alert"),
                              content: Text("You can't fill timesheet for future dates."),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                          return; // block navigation
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SelfTaskScreen(
                              selectedDate: provider.selectedDay!,
                              // or any selected date
                              userId: userId, // pass actual user ID here
                            ),
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
              : const SizedBox
                  .shrink(); // No button when showLeaveDetails is false
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
    if (provider.leaveSummaries.isEmpty) return Container();

    return Column(
      children: provider.leaveSummaries.map((leave) {
        final date = DateFormat("dd-MM-yyyy").parse(leave.LeaveDate);
        final formattedDay = DateFormat("dd").format(date);
        final formattedMonth = DateFormat("MMM").format(date).toUpperCase();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
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
                child: Column(
                  children: [
                    Text(formattedDay,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text(formattedMonth,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 10)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Expanded(
              // child:
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Leave applied for: ${leave.LeaveTimeInMinutes}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF25507C),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text("Reason: ${leave.Remarks}",
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
              ),
             // ),
              const SizedBox(width: 50),
              // Padding(
              //   padding: const EdgeInsets.only(top: 12),
              //   child:

              // Delete icon aligned a little lower
              Padding(
                padding: const EdgeInsets.only(top: 12), // adjust this value (8 → 12 → 16) as needed
                child: GestureDetector(
                  onTap: () {
                    provider.showCancelLeaveBottomSheet(
                      context,
                      "Cancellation Leave",
                      leave.LeaveId,
                      date,
                      0.55,
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/icons/delete.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),

              // ),

            ],
          ),
        );
      }).toList(),
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
          DateTime today = DateTime.now();
          DateTime selectedDate =
              provider.selectedDay!; // assuming this is never null
          DateTime normalizedToday =
              DateTime(today.year, today.month, today.day);
          DateTime normalizedSelected =
              DateTime(selectedDate.year, selectedDate.month, selectedDate.day);

          bool isFutureDate = normalizedSelected.isAfter(normalizedToday);

          if (label == 'Add Leave') {
            // _showAddLeaveModal(
            //     context, DateTime(2025, 4, 30)); // or selectedDate
            print("showNoTaskBottomSheet1111");

            provider.showSelectDateBottomSheet(context,  "Add Leave", DateTime(2025, 4, 30),550);
          } else if (label == 'No Task Assigned' ||
              label == 'R&D' ||
              label == 'Assigned Task') {
            if (isFutureDate) {
              // show alert if date is in the future
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Alert"),
                  content: Text("You can't fill timesheet for future dates."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              return; // stop further execution
            }

            if (label == 'No Task Assigned') {
              //showNoTaskDialog(context);
              print("showNoTaskBottomSheet2222");
              provider.showSelectDateBottomSheet(
                  context,  "No Task Assigned", provider.selectedDay!, 0.3);
            } else if (label == 'R&D') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RdScreen(
                    selectedDate: provider.selectedDay!,
                    // or any selected date
                    userId: userId, // pass actual user ID here
                  ),
                ),
              );
            } else if (label == 'Assigned Task') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => AssignedTaskProvider(),
                    child: AssignedTaskScreen(
                      selectedDate: provider.selectedDay!,
                      userId: userId,
                    ),
                  ),
                ),
              );
            }
          }
          // or _selectedDay
        },
      ),
    );
  }
}
