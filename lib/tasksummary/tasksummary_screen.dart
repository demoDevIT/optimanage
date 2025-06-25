import 'package:flutter/material.dart';

import '../constant/common.dart';
import '../dailytask/dailytask_screen.dart';

class TaskSummaryScreen extends StatelessWidget {
  final String taskTitle;

  const TaskSummaryScreen({super.key, required this.taskTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // page background
      appBar: common.Appbar(
        title: "View task summary",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // ✅ 1. Date and Resource line (outside colored box)
              const Text(
                'Date: 01/04/2025 and Resource: undefined',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 14),

              // ✅ 2. Colored Box starts here
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
                    // ✅ 3. Task Title inside colored box
                    Text(
                      //taskTitle,
                      "RajKisan_2024_25",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildInfoRow("Assign On", "01-04-2025"),
                    _buildDivider(),

                    _buildInfoRow("Estimated Duration", "28-04-05 to 28-04-25"),
                    _buildDivider(),

                    _buildInfoRow("Last Action Date", "29-04-25"),
                    _buildDivider(),

                    _buildInfoRow("Module", "Design Level Common Module"),
                    _buildDivider(),

                    const SizedBox(height: 10),

                    const Text(
                      "Task Description",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),

                    const Text(
                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s....",
                      style: TextStyle(
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
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                title: const Text(
                                  'Optimanage Says',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                content: const Text(
                                  'Please clear our previous/pending daily timesheet entries till to last 10 days.',
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
                                        Navigator.pop(context); // Close the dialog
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (_) => const DailyTaskScreen()),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF25507C),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'Ok',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },

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
