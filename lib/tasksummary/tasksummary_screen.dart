import 'package:flutter/material.dart';
import 'package:optimanage/tasksummary/tasksummary_provider.dart';
import '../assignedtask/AssignedTaskModel.dart';
import '../constant/common.dart';
import '../dailytask/dailytask_screen.dart';
import 'package:provider/provider.dart';

class TaskSummaryScreen extends StatefulWidget {
  final AssignedTaskModel task;
  final DateTime selectedDate;
  final int userId;
  const TaskSummaryScreen({
    super.key,
    required this.task,
    required this.selectedDate,
    required this.userId,
  });

  @override
  State<TaskSummaryScreen> createState() => _TaskSummaryScreenState();
}

class _TaskSummaryScreenState extends State<TaskSummaryScreen> {
  @override
  void initState() {
    super.initState();

    // Call API on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TaskSummaryProvider>(context, listen: false);
      provider.fetchTaskSummary(1098); // new param
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskSummaryProvider>(context);
    final task = provider.taskSummary;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: common.Appbar(
        title: "View task summary",
        callback: () {
          Navigator.of(context).pop(false);
        },
        actions: [
          Image.asset('assets/icons/notification.png', width: 24, height: 24),
          SizedBox(width: 10),
        ],
      ),
      body: task == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              Text(
                'Date: ${task.createdDate}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 14),

              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F9FE),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.projectName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow("Assign On", task.createdDate),
                    _buildDivider(),
                    _buildInfoRow("Estimated Duration", task.estimateTime),
                    _buildDivider(),
                    _buildInfoRow("Last Action Date", task.actionDate),
                    _buildDivider(),
                    _buildInfoRow("Module", task.moduleName),
                    _buildDivider(),

                    const SizedBox(height: 10),
                    const Text(
                      "Task Description",
                      style: TextStyle(fontSize: 13, color: Colors.black),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      task.description,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () async {
                          final provider = Provider.of<TaskSummaryProvider>(context, listen: false);
                          final notEntryCount = await provider.validateTimesheetEntry(widget.selectedDate, widget.userId);

                          if (notEntryCount == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Something went wrong.')),
                            );
                            return;
                          }

                          if (notEntryCount < 6) {
                            // Show the popup
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: const Text('Optimanage Says', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  content: const Text(
                                    'Please clear our previous/pending daily timesheet entries till to last 6 days.',
                                    style: TextStyle(fontSize: 14, height: 1.5),
                                  ),
                                  actionsPadding: const EdgeInsets.only(bottom: 16),
                                  actionsAlignment: MainAxisAlignment.center,
                                  actions: [
                                    SizedBox(
                                      width: 120,
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(builder: (_) => const DailyTaskScreen()),
                                          // );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF25507C),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: const Text('Ok', style: TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            // Navigate directly
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DailyTaskScreen()),
                            );
                          }
                        },

                        // onPressed: () {
                        //   showDialog(
                        //     context: context,
                        //     barrierDismissible: false,
                        //     builder: (BuildContext context) {
                        //       return AlertDialog(
                        //         backgroundColor: Colors.white,
                        //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        //         title: const Text('Optimanage Says', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                        //         content: const Text(
                        //           'Please clear our previous/pending daily timesheet entries till to last 10 days.',
                        //           style: TextStyle(fontSize: 14, height: 1.5),
                        //         ),
                        //         actionsPadding: const EdgeInsets.only(bottom: 16),
                        //         actionsAlignment: MainAxisAlignment.center,
                        //         actions: [
                        //           SizedBox(
                        //             width: 120,
                        //             height: 40,
                        //             child: ElevatedButton(
                        //               onPressed: () {
                        //                 Navigator.pop(context);
                        //                 Navigator.push(context, MaterialPageRoute(builder: (_) => const DailyTaskScreen()));
                        //               },
                        //               style: ElevatedButton.styleFrom(
                        //                 backgroundColor: const Color(0xFF25507C),
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius: BorderRadius.circular(10),
                        //                 ),
                        //               ),
                        //               child: const Text('Ok', style: TextStyle(color: Colors.white)),
                        //             ),
                        //           ),
                        //         ],
                        //       );
                        //     },
                        //   );
                        // },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25507C),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Add timesheets',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      thickness: 1,
      height: 10,
      color: Color(0xFFE0E0E0),
    );
  }
}
