import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../assignedtask/AssignedTaskModel.dart';
import 'dailytask_provider.dart';

class DailyTaskScreen extends StatefulWidget {
  final AssignedTaskModel task;

  const DailyTaskScreen({super.key, required this.task});

  @override
  State<DailyTaskScreen> createState() => _DailyTaskScreenState();
}

class _DailyTaskScreenState extends State<DailyTaskScreen> {
  late int projectId;

  final taskDetailsController = TextEditingController();
  final taskHourController = TextEditingController();
  final taskMinuteController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();

    projectId = widget.task.projectId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyTaskProvider>(context, listen: false).fetchTaskStatusList(context);
    });
  }

  // TimeOfDay? _startTime = const TimeOfDay(hour: 10, minute: 0);
  // TimeOfDay? _endTime = const TimeOfDay(hour: 19, minute: 30);
  String? _selectedStatus;

  final List<String> taskStatusOptions = [
    'Completed',
    'In Progress',
    'Blocked',
  ];

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        isStart ? _startTime = picked : _endTime = picked;
        _calculateDuration();
      });
    }
  }

  void _calculateDuration() {
    if (_startTime == null || _endTime == null) return;

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    final end = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    Duration duration = end.difference(start);
    if (duration.isNegative) duration += Duration(days: 1);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    taskHourController.text = hours.toString();
    taskMinuteController.text = minutes.toString();
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? "AM" : "PM";
    return "${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daily Task Details',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("PROJECT NAME", value: widget.task.projectName),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextFormField(
                controller: taskDetailsController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Daily Task Details',
                  hintStyle: TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Color(0xFFF5F8FF),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red.shade700,
                    fontSize: 13,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter task details';
                  }
                  return null;
                },
              ),
            ),


            const SizedBox(height: 12),
            _buildDropdown(),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: FormField<TimeOfDay>(
                    validator: (value) {
                      if (_startTime == null) return 'Select Start Time';
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(true),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xFFF5F8FF),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    _startTime != null ? _startTime!.format(context) : 'Select Start Time',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FormField<TimeOfDay>(
                    validator: (value) {
                      if (_endTime == null) return 'Select End Time';
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () => _selectTime(false),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0xFFF5F8FF),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    _endTime != null ? _endTime!.format(context) : 'Select End Time',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 4),
                              child: Text(
                                state.errorText!,
                                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                              ),
                            )
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextFormField(
                controller: taskHourController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Task Hour',
                  hintStyle: TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Color(0xFFF5F8FF),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 13),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: TextFormField(
                controller: taskMinuteController,
                keyboardType: TextInputType.number,
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Task Minute',
                  hintStyle: TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
                  filled: true,
                  fillColor: Color(0xFFF5F8FF),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 13),
                ),
              ),
            ),


            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                  onPressed: () async {
                    // final provider = Provider.of<DailyTaskProvider>(context, listen: false);
                    //
                    // final description = taskDetailsController.text.trim();
                    // final taskStatus = int.tryParse(_selectedStatus ?? '0') ?? 0;
                    // final taskHour = int.tryParse(taskHourController.text.trim()) ?? 0;
                    // final taskMinute = int.tryParse(taskMinuteController.text.trim()) ?? 0;
                    //
                    // if (description.isEmpty || _startTime == null || _endTime == null || taskStatus == 0) {
                    //   UtilityClass.showSnackBar(context, "Please fill all required fields", Colors.red);
                    //   return;
                    // }
                    //
                    // final startTimeFormatted = _startTime!.format(context);
                    // final endTimeFormatted = _endTime!.format(context);
                    //
                    // await provider.submitRdTask(
                    //   context: context,
                    //   description: description,
                    //   startTime: startTimeFormatted,
                    //   endTime: endTimeFormatted,
                    //   taskHour: taskHour,
                    //   taskMinutes: taskMinute,
                    //   taskStatus: taskStatus,
                    //   projectId: projectId,
                    //   userId: 1,      // Replace with actual user ID (e.g., from shared prefs)
                    //   moduleId: 0,    // Replace with actual module ID if available
                    // );
                  },
                  // print("Project ID: $projectId");
                  // print("Project Name: ${widget.task.projectName}");
                  // Navigator.pop(context); // back to task summary
                  // Navigator.pop(context); // back to assigned task
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25507C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {String? value}) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF6E6A7C)),
        filled: true,
        fillColor: const Color(0xFFF5F9FE),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }



  Widget _buildDropdown() {
    final provider = Provider.of<DailyTaskProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedStatus,
          hint: const Text(
            "Daily Task Status",
            style: TextStyle(
              color: Color(0xFF6E6A7C),
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            size: 30,
            color: Colors.black,
          ),
          onChanged: (String? newValue) {
            setState(() {
              _selectedStatus = newValue;
            });
          },
          items: provider.statusList,
        ),
      ),
    );
  }




  Widget _buildTimePicker({required String label, required TimeOfDay time, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F9FE),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/calendar.png',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(time),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
