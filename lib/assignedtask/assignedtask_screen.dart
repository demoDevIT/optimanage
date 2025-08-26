import 'package:flutter/material.dart';

import '../constant/common.dart';
import '../tasksummary/tasksummary_screen.dart';
import 'package:provider/provider.dart';
import 'package:optimanage/assignedtask/assignedtask_provider.dart';

import 'AssignedTaskModel.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AssignedTaskScreen extends StatefulWidget {
  final DateTime selectedDate;
  final int userId;

  const AssignedTaskScreen({
    super.key,
    required this.selectedDate,
    required this.userId,
  });


  @override
  State<AssignedTaskScreen> createState() => _AssignedTaskScreenState();
}

class _AssignedTaskScreenState extends State<AssignedTaskScreen> {
  AssignedTaskModel? selectedTask;
  int? expandedIndex;
  String? selectedTaskKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AssignedTaskProvider>(context, listen: false);
      provider.fetchAssignedTasks(
        context: context,
        fromDate: _formatDate(widget.selectedDate),
        toDate: _formatDate(widget.selectedDate),
        userId: widget.userId,
      );
    });
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  final List<Map<String, dynamic>> projectData = [
    {
      'title': 'Project Name (12)',
      'tasks': [
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
      ],
    },
    {
      'title': 'Project Name 2 (5)',
      'tasks': [
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
      ],
    },
    {
      'title': 'Project Name 3 (2)',
      'tasks': [
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
      ],
    },
    {
      'title': 'Project Name 2 (5)',
      'tasks': [
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
      ],
    },
    {
      'title': 'Project Name 3 (2)',
      'tasks': [
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
        'EEMS-2 Layout creation as discussed',
        'Lorem Ipsum is simply dummy text of the printing',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final assignedProjects = Provider.of<AssignedTaskProvider>(context).assignedProjects;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: common.Appbar(
        title: "Assigned Task",
        callback: () {
          Navigator.of(context).pop(false);
        },
         actions: [
        //   SvgPicture.asset(
        //     'assets/icons/notification.svg',
        //     width: 24,
        //     height: 24,
        //   ),
        SizedBox(width: 50),
         ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: assignedProjects.isEmpty
                  ? const Center(
                child: Text(
                  'No record',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: assignedProjects.length,
                itemBuilder: (context, index) {
                  final project = assignedProjects[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                      color: Colors.white,
                    ),
                    child: ExpansionTile(
                      key: ValueKey('${index}_${expandedIndex == index}'),
                      initiallyExpanded: expandedIndex == index,
                      onExpansionChanged: (expanded) {
                        setState(() {
                          expandedIndex = expanded ? index : null;
                        });
                      },
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      childrenPadding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(),
                      title: Text(
                        "${project.projectName} (${project.taskData.length})",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xFF25507C),
                        ),
                      ),
                      trailing: Icon(
                        expandedIndex == index
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 28,
                        color: Color(0xFF25507C),
                      ),
                      children: [
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: Color(0xFFE5E5E5),
                        ),
                        ...List.generate(project.taskData.length, (taskIndex) {
                          final taskKey = '$index-$taskIndex';
                          final task = project.taskData[taskIndex];

                          return RadioListTile<String>(
                            value: taskKey,
                            groupValue: selectedTaskKey,
                            onChanged: (value) {
                              setState(() {
                                selectedTaskKey = value;
                                selectedTask = task;
                              });
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(
                              task.taskName,
                              style: const TextStyle(fontSize: 13.5, height: 1.3),
                            ),
                            activeColor: const Color(0xFF25507C),
                            visualDensity: VisualDensity.compact,
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),


            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedTask == null ? null : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TaskSummaryScreen(
                        task: selectedTask!,
                        selectedDate: widget.selectedDate,
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25507C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'View Task Summary',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}

