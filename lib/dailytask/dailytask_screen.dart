import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../assignedtask/AssignedTaskModel.dart';
import 'dailytask_provider.dart';
import '../utils/UtilityClass.dart';

class DailyTaskScreen extends StatefulWidget {
  final AssignedTaskModel task;

  const DailyTaskScreen({super.key, required this.task});

  @override
  State<DailyTaskScreen> createState() => _DailyTaskScreenState();
}

class _DailyTaskScreenState extends State<DailyTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField("PROJECT NAME", value: widget.task.projectName),
              const SizedBox(height: 12),

              // 🔻 Task Description Field
              _textInput(
                hint: 'Daily Task Details',
                controller: taskDetailsController,
                maxLines: 3,
              ),

              const SizedBox(height: 12),

              // 🔻 Dropdown Field
              _dropdownInput(),

              const SizedBox(height: 12),

              // 🔻 Start & End Time
              Row(
                children: [
                  _timePickerField(
                    label: "Start Time",
                    time: _startTime,
                    onTimePicked: (picked) {
                      setState(() {
                        _startTime = picked;
                        _calculateDuration();
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _timePickerField(
                    label: "End Time",
                    time: _endTime,
                    onTimePicked: (picked) {
                      setState(() {
                        _endTime = picked;
                        _calculateDuration();
                      });
                    },
                  ),
                ],
              ),

              _textInput(
                hint: 'Task Hour',
                controller: taskHourController,
                keyboardType: TextInputType.number,
                readOnly: true,
              ),
              _textInput(
                hint: 'Task Minute',
                controller: taskMinuteController,
                keyboardType: TextInputType.number,
                readOnly: true,
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submitForm,
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
              ),
            ],
          ),
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

  Widget _textInput({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool isRequired = true,
    bool readOnly = false,
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
          errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 13),
        ),
      ),
    );
  }

  Widget _dropdownInput() {
    final provider = Provider.of<DailyTaskProvider>(context);

    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      validator: (value) => value == null ? 'Please select Daily Task Status' : null,
      onChanged: (val) => setState(() => _selectedStatus = val),
      items: provider.statusList,
      decoration: InputDecoration(
        hintText: "Daily Task Status",
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
    );
  }

  Widget _timePickerField({
    required String label,
    required TimeOfDay? time,
    required void Function(TimeOfDay) onTimePicked,
  }) {
    return Expanded(
      child: FormField<TimeOfDay>(
        validator: (value) => time == null ? 'Select $label' : null,
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
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = Provider.of<DailyTaskProvider>(context, listen: false);

    final description = taskDetailsController.text.trim();
    final taskHour = int.tryParse(taskHourController.text.trim()) ?? 0;
    final taskMinute = int.tryParse(taskMinuteController.text.trim()) ?? 0;
    final taskStatus = int.tryParse(_selectedStatus ?? '0') ?? 0;

    final now = DateTime.now();
    final entryDate = "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}";
    final duration = (taskHour * 60) + taskMinute;

    final String startStr = _startTime != null
        ? _startTime!.hour.toString().padLeft(2, '0') + ':' + _startTime!.minute.toString().padLeft(2, '0')
        : '';

    final String endStr = _endTime != null
        ? _endTime!.hour.toString().padLeft(2, '0') + ':' + _endTime!.minute.toString().padLeft(2, '0')
        : '';

    await provider.submitDailyTask(
      context: context,
      description: description,
      startTime: startStr,
      endTime: endStr,
      taskHour: taskHour,
      taskMinutes: taskMinute,
      taskStatus: taskStatus,
      projectId: projectId,
      moduleId: 0,     // Replace with actual moduleId if needed
      userId: 55,       // Replace with actual userId
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
