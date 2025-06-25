import 'package:flutter/material.dart';

import '../constant/common.dart';
import '../tasksummary/tasksummary_screen.dart';

class AssignedTaskScreen extends StatefulWidget {
  const AssignedTaskScreen({super.key});

  @override
  State<AssignedTaskScreen> createState() => _AssignedTaskScreenState();
}

class _AssignedTaskScreenState extends State<AssignedTaskScreen> {
  String? selectedTask;
  int? expandedIndex;
  String? selectedTaskKey;

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: common.Appbar(
        title: "Assigned Task",
        callback: () {
          Navigator.of(context).pop(false);
        },
        actions: [
          Image.asset(
            'assets/icons/notification.png',
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: projectData.length,
                itemBuilder: (context, index) {
                  final project = projectData[index]; // ✅ Define project here

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
                          expandedIndex = expanded ? index : null; // Accordion behavior
                        });
                      },
                      tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                      childrenPadding: EdgeInsets.zero,
                      shape: const RoundedRectangleBorder(), // You can keep this if needed
                      title: Text(
                        project['title'],
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
                          indent: 0,
                          endIndent: 0,
                        ),
                        ...List.generate(project['tasks'].length, (taskIndex) {
                          // final task = project['tasks'][taskIndex];
                          final taskKey = '$index-$taskIndex';
                          final task = project['tasks'][taskIndex];

                          return RadioListTile<String>(
                            value: taskKey,
                            groupValue: selectedTaskKey,
                            onChanged: (value) {
                              setState(() {
                                selectedTaskKey = value;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TaskSummaryScreen(taskTitle: task),
                                ),
                              );
                            },
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            title: Text(
                              task,
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
                onPressed: () {
                  // Handle submit
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25507C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add Daily Task Details',
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

