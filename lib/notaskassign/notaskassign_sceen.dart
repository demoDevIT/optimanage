import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../constant/common.dart';
import 'package:optimanage/notaskassign/notaskassign_provider.dart';
import 'package:optimanage/constant/colors.dart';


class NoTaskAssignScreen extends StatefulWidget {
  final DateTime selectedDate;
  final int userId;

  const NoTaskAssignScreen({
    super.key,
    required this.selectedDate,
    required this.userId,
  });

  @override
  State<NoTaskAssignScreen> createState() => _NoTaskAssignScreenState();
}

class _NoTaskAssignScreenState extends State<NoTaskAssignScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _taskHourController = TextEditingController();
  final TextEditingController _taskMinuteController = TextEditingController();

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void dispose() {
    _descriptionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _taskHourController.dispose();
    _taskMinuteController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      final formattedTime = picked.format(context);
      setState(() {
        if (isStart) {
          _startTime = picked;
          _startTimeController.text = formattedTime;
        } else {
          _endTime = picked;
          _endTimeController.text = formattedTime;
        }

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
    if (duration.isNegative) {
      duration += const Duration(days: 1); // handle overnight entries
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    _taskHourController.text = hours.toString();
    _taskMinuteController.text = minutes.toString();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F9FF),
      appBar: common.Appbar(
        title: "No Task Assigned",
        callback: () => Navigator.of(context).pop(false),
        actions: [
          Image.asset('assets/icons/notification.png', width: 24, height: 24),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daily Task Details ($formattedDate)',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              const Text('(No Task Assigned)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // Description
              _buildTextFormField(controller: _descriptionController, hintText: 'Daily Task Details', maxLines: 4),
              const SizedBox(height: 16),

              // Start/End Time Pickers
              GestureDetector(
                onTap: () => _selectTime(context, true),
                child: AbsorbPointer(
                  child: _buildTextFormField(controller: _startTimeController, hintText: 'Start Time'),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => _selectTime(context, false),
                child: AbsorbPointer(
                  child: _buildTextFormField(controller: _endTimeController, hintText: 'End Time'),
                ),
              ),
              const SizedBox(height: 12),

              // Auto-calculated Hours/Minutes
              _buildTextFormField(controller: _taskHourController, hintText: 'Task Hour', readOnly: true),
              const SizedBox(height: 12),
              _buildTextFormField(controller: _taskMinuteController, hintText: 'Task Minute', readOnly: true),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF25507C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: const Color(0xFFF3F7FE),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() != true) return;

    // Check if both times are selected
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both start and end time')),
      );
      return;
    }

    // Validate: End time must be after start time
    final now = DateTime.now();
    final startDateTime = DateTime(now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    final endDateTime = DateTime(now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    if (endDateTime.isBefore(startDateTime) || endDateTime.isAtSameMomentAs(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final provider = Provider.of<NoTaskAssignProvider>(context, listen: false);

    final int taskHour = int.tryParse(_taskHourController.text) ?? 0;
    final int taskMinute = int.tryParse(_taskMinuteController.text) ?? 0;
    final int taskDuration = (taskHour * 60) + taskMinute;

    final String formattedStartTime =
        _startTime!.hour.toString().padLeft(2, '0') + ':' + _startTime!.minute.toString().padLeft(2, '0');

    final String formattedEndTime =
        _endTime!.hour.toString().padLeft(2, '0') + ':' + _endTime!.minute.toString().padLeft(2, '0');

    final String formattedEntryDate = DateFormat('MM/dd/yyyy').format(widget.selectedDate);

    await provider.submitNoTask(
      context: context,
      description: _descriptionController.text.trim(),
      entryDate: formattedEntryDate,
      startTime: formattedStartTime,
      endTime: formattedEndTime,
      taskHour: taskHour,
      taskMinutes: taskMinute,
      taskDuration: taskDuration,
      userId: widget.userId,
    );
  }


}
