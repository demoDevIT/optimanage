import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constant/common.dart';
import 'package:optimanage/RD/rd_provider.dart';

class RdScreen extends StatefulWidget {
  final DateTime selectedDate;
  final int userId;

  const RdScreen({
    super.key,
    required this.selectedDate,
    required this.userId,
  });

  @override
  State<RdScreen> createState() => _RdScreenState();
}

class _RdScreenState extends State<RdScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedProject;
  String? selectedModule;
  String? selectedSubModule;

  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final taskDetailsController = TextEditingController();
  final taskHourController = TextEditingController();
  final taskMinuteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<RdProvider>(context, listen: false).fetchProjectList(context));
  }

  Future<void> _selectTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
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
    if (duration.isNegative) duration += const Duration(days: 1);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    taskHourController.text = hours.toString();
    taskMinuteController.text = minutes.toString();
  }

  Widget _timePickerField({
    required String label,
    required TimeOfDay? time,
    required void Function(TimeOfDay) onTimePicked,
  }) {
    return Expanded(
      child: FormField<TimeOfDay>(
        validator: (value) {
          if (time == null) {
            return 'Select $label';
          }
          return null;
        },
        builder: (state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    onTimePicked(picked);
                    state.didChange(picked);
                  }
                },
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
                        time != null ? time.format(context) : 'Select $label',
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
    );
  }


  Widget _textInput({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = true,
    bool readOnly = false
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator: isRequired
            ? (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
          return null;
        }
            : null,
        decoration: InputDecoration(
          hintText: hint,
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
      ),
    );
  }


  Widget _dropdownInput({
    required String hint,
    required List<String> items,
    String? selected,
    required void Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selected,
        onChanged: onChanged,
        validator: (value) => value == null ? 'Please select $hint' : null,
        icon: const Icon(Icons.arrow_drop_down, size: 30, color: Colors.black87),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Color(0xFF6E6A7C)),
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
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }


  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || _startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all required fields including time')),
      );
      return;
    }

    final rdProvider = Provider.of<RdProvider>(context, listen: false);

    final project = rdProvider.projects.firstWhere((p) => p.fieldName == selectedProject);
    final module = rdProvider.modules.firstWhere((m) => m.text == selectedModule);

    final now = DateTime.now();
    final dateStr = DateFormat('yyyy-MM-dd').format(now);
    // final startStr = _startTime!.format(context);
    // final endStr = _endTime!.format(context);

    final String startStr = _startTime != null
        ? _startTime!.hour.toString().padLeft(2, '0') + ':' + _startTime!.minute.toString().padLeft(2, '0')
        : '';

    final String endStr = _endTime != null
        ? _endTime!.hour.toString().padLeft(2, '0') + ':' + _endTime!.minute.toString().padLeft(2, '0')
        : '';

    final duration = int.parse(taskHourController.text) * 60 + int.parse(taskMinuteController.text);

    final String formattedEntryDate = DateFormat('MM/dd/yyyy').format(widget.selectedDate);

    final body = {
      "TaskType": 4,
      "TaskId": 0,
      "TaskDescription": taskDetailsController.text.trim(),
      "TaskStatus": 0,
      "EntryDate": formattedEntryDate, //dateStr,
      "TaskHour": int.parse(taskHourController.text),
      "TaskMinutes": int.parse(taskMinuteController.text),
      "TaskDuration": duration,
      "StartTime": startStr,
      "EndTime": endStr,
      "ProjectId": project.fieldId,
      "TaskTypeId": 0,
      "ModuleId": module.value,
      "UserId": 0, // Replace with actual logged-in user ID
    };

    print('📤 Sending data to API: $body');

    // TODO: Call API here using http or dio package
    // final response = await http.post(Uri.parse('your_api_url'), body: jsonEncode(body));
    // ✅ Submit using provider
    await rdProvider.submitRdTask(
      context: context,
      description: taskDetailsController.text.trim(),
      startTime: startStr,
      endTime: endStr,
      taskHour: int.parse(taskHourController.text),
      taskMinutes: int.parse(taskMinuteController.text),
      taskDuration: duration,
      entryDate: formattedEntryDate,
      projectId: project.fieldId,
      moduleId: module.value,
      userId: widget.userId, // Replace with actual user ID
    );

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Form submitted (mock)!')),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final rdProvider = Provider.of<RdProvider>(context);
    final formattedDate = DateFormat('dd-MM-yyyy').format(widget.selectedDate);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: common.Appbar(
          title: "R&D Tasks",
          callback: () => Navigator.of(context).pop(false),
          actions: [
            Image.asset('assets/icons/notification.png', width: 24, height: 24),
            SizedBox(width: 10),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  'Daily Task Details ($formattedDate)', // 🔁 match noTaskAssign page
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 16),
                  _dropdownInput(
                    hint: 'Project Name',
                    items: rdProvider.projects.map((p) => p.fieldName).toList(),
                    selected: selectedProject,
                    onChanged: (val) {
                      setState(() => selectedProject = val);
                      final project = rdProvider.projects.firstWhere((p) => p.fieldName == val);
                      rdProvider.fetchModuleList(context, project.fieldId);
                      selectedModule = null;
                    },
                  ),
                  _dropdownInput(
                    hint: 'Module',
                    items: rdProvider.modules.map((m) => m.text).toList(),
                    selected: selectedModule,
                    onChanged: (val) async {
                      setState(() => selectedModule = val);
                      final module = rdProvider.modules.firstWhere((m) => m.text == val);
                      selectedSubModule = null;
                      await rdProvider.fetchSubModuleList(context, module.value);
                    },
                  ),
                  if (rdProvider.subModules.isNotEmpty)
                    _dropdownInput(
                      hint: 'Submodule',
                      items: rdProvider.subModules.map((s) => s.text).toList(),
                      selected: selectedSubModule,
                      onChanged: (val) => setState(() => selectedSubModule = val),
                    ),
                  _textInput(
                    hint: 'Daily Task Details',
                    controller: taskDetailsController,
                    maxLines: 3,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      _timePickerField(
                        label: "Start Time",
                        time: _startTime,
                        onTimePicked: (picked) {
                          setState(() {
                            _startTime = picked;
                            _calculateDuration(); // ✅ calculate after selecting
                          });
                        },
                      ),

                      SizedBox(width: 10),
                      _timePickerField(
                        label: "End Time",
                        time: _endTime,
                        onTimePicked: (picked) {
                          setState(() {
                            _endTime = picked;
                            _calculateDuration(); // ✅ calculate after selecting
                          });
                        },
                      ),

                    ],
                  ),

                  _textInput(
                    hint: 'Task Hour',
                    controller: taskHourController,
                    keyboardType: TextInputType.number,
                    readOnly: true, // ✅ disabled input
                  ),
                  _textInput(
                    hint: 'Task Minute',
                    controller: taskMinuteController,
                    keyboardType: TextInputType.number,
                    readOnly: true, // ✅ disabled input
                  ),

                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25507C),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        'Submit',
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
          ),
        ),
      ),
    );
  }
}

