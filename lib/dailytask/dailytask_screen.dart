import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:optimanage/dailytask/TaskStatusModel.dart';
import 'package:provider/provider.dart';
import '../assignedtask/AssignedTaskModel.dart';
import 'dailytask_provider.dart';
import '../utils/UtilityClass.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DailyTaskScreen extends StatefulWidget {
  final AssignedTaskModel task;
  final int userId;
  final DateTime selectedDate;

  const DailyTaskScreen({
    super.key,
    required this.task,
    required this.userId, // 🔹 Add this line
    required this.selectedDate,
  });

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
    print("📄 initState -> TaskIssueID: ${widget.task.taskIssueID}");
    projectId = widget.task.projectId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DailyTaskProvider>(context, listen: false)
          .fetchTaskStatusList(context);
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
    final start = DateTime(
        now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    final end = DateTime(
        now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

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
    // print("📄 DailyTaskScreen -> TaskIssueID: ${task.taskIssueID}");
    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Important for keyboard push
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'Daily Task Details',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(right: 16),
        //     child: SvgPicture.asset(
        //       'assets/icons/notification.svg',
        //       width: 24,
        //       height: 24,
        //     ),
        //   )
        // ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField("Project Name", value: widget.task.projectName),
                const SizedBox(height: 12),
                _textInput(
                  hint: 'Daily Task Details',
                  controller: taskDetailsController,
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                _dropdownInput(),
                const SizedBox(height: 18),
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
                const SizedBox(height: 12),
                _textInput(
                  hint: 'Task Hour',
                  controller: taskHourController,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                const SizedBox(height: 8),
                _textInput(
                  hint: 'Task Minute',
                  controller: taskMinuteController,
                  keyboardType: TextInputType.number,
                  readOnly: true,
                ),
                const SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildTextField(String hint, {String? value}) {
    return TextField(
      readOnly: true,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: hint,
        // 👈 Label name at top-left inside border
        labelStyle: const TextStyle(
          color: Color(0xFF6E6A7C),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        // hintText: hint,
        // hintStyle: const TextStyle(color: Color(0xFF6E6A7C)),
        filled: true,
        fillColor: const Color(0xFFF5F9FE),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFDDDDDD),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFDDDDDD), // keep same color to avoid blue underline
            width: 2,
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // Widget _buildDropdown() {
  //   final provider = Provider.of<DailyTaskProvider>(context);
  //
  //   return Container(
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFF5F9FE),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<String>(
  //         isExpanded: true,
  //         value: _selectedStatus,
  //         hint: const Text(
  //           "Daily Task Status",
  //           style: TextStyle(
  //             color: Color(0xFF6E6A7C),
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //         icon: const Icon(
  //           Icons.arrow_drop_down,
  //           size: 30,
  //           color: Colors.black,
  //         ),
  //         onChanged: (String? newValue) {
  //           setState(() {
  //             _selectedStatus = newValue;
  //           });
  //         },
  //         items: provider.statusList,
  //       ),
  //     ),
  //   );
  // }

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
          labelText: hint,
          // 👈 Label name at top-left inside border
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Color(0xFF6E6A7C),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          // hintText: hint,
          // hintStyle: TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
          filled: true,
          fillColor: Color(0xFFF5F8FF),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD),
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD), // keep same color to avoid blue underline
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD), // 👈 override red with grey
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD), // 👈 keep same grey even on focus
              width: 2,
            ),
          ),
          errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 13),
        ),
      ),
    );
  }

  Widget _dropdownInput() {
    final provider = Provider.of<DailyTaskProvider>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FF),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFDDDDDD), width: 2),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          inputDecorationTheme: const InputDecorationTheme(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        child: DropdownSearch<TaskStatusModel>(
          selectedItem: provider.statusList.firstWhere(
                (e) => e.id.toString() == _selectedStatus,
            orElse: () => provider.statusList.isNotEmpty
                ? provider.statusList.first
                : TaskStatusModel(id: 0, text: ""),
          ),
          compareFn: (a, b) => a.id == b.id,
          items: (filter, _) => provider.statusList,
          popupProps: PopupProps.menu(
            showSearchBox: true,
            fit: FlexFit.loose,
            constraints: const BoxConstraints(maxHeight: 250),
            menuProps: const MenuProps(
              margin: EdgeInsets.symmetric(horizontal: -14, vertical: -4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              backgroundColor: Color(0xFFF5F8FF),
              elevation: 0,
            ),
            searchFieldProps: TextFieldProps(
              style: const TextStyle(
                color: Color(0xFF555555),
                fontWeight: FontWeight.w500,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
              decoration: const InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF555555),
                ),
                isDense: true,
                suffixIcon: Icon(Icons.search, size: 20),
                suffixIconConstraints:
                    BoxConstraints(minWidth: 40, minHeight: 24),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1.2),
                ),
              ),
            ),
            listViewProps: const ListViewProps(padding: EdgeInsets.zero),
            itemBuilder:
                (context, TaskStatusModel item, isSelected, isFocused) {
              final index = provider.statusList.indexOf(item);
              return Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item.text,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: isSelected
                              ? Colors.blue
                              : const Color(0xFF444444),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (index != provider.statusList.length - 1)
                    const Divider(
                      height: 1,
                      thickness: 0.8,
                      color: Color(0xFFEEEEEE),
                    ),
                ],
              );
            },
            //onDismissed: () => setState(() => _isProjectPopupOpen = false),
            containerBuilder: (ctx, popupWidget) {
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   if (!_isProjectPopupOpen) {
              //     setState(() => _isProjectPopupOpen = true);
              //   }
              // });
              return Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                    border: const Border(
                      left: BorderSide(color: Color(0xFFDDDDDD), width: 2),
                      right: BorderSide(color: Color(0xFFDDDDDD), width: 2),
                      bottom: BorderSide(color: Color(0xFFDDDDDD), width: 2),
                      top: BorderSide.none, // 👈 no top border
                    ),
                    //border: Border.all(color: const Color(0xFFDDDDDD), width: 2), // 👈 same border
                    // borderTop: BorderSide.none, // 👈 avoid double border with top box
                  ),
                  child: popupWidget,
                ),
              );
            },
          ),
          dropdownBuilder: (context, TaskStatusModel? selectedItem) {
            return Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F8FF),
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.only(left: 0, top: 4, bottom: 14, right: 12),
              child: Text(
                selectedItem?.text ?? "Daily Task Status",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      selectedItem == null ? Color(0xFF6E6A7C) : Colors.black,
                ),
              ),
            );
          },
          onChanged: (TaskStatusModel? status) {
            if (status != null) {
              setState(() =>
                  _selectedStatus = status.id.toString()); // ✅ store Value
            }
          },
          validator: (value) =>
              value == null ? 'Please select Daily Task Status' : null,
        ),
      ),
    );
  }

  // Widget _dropdownInput1() {
  //   final provider = Provider.of<DailyTaskProvider>(context);
  //
  //   return DropdownButtonFormField<String>(
  //     value: _selectedStatus,
  //     validator: (value) => value == null ? 'Please select Daily Task Status' : null,
  //     onChanged: (val) => setState(() => _selectedStatus = val),
  //     items: provider.statusList,
  //     decoration: InputDecoration(
  //       hintText: "Daily Task Status",
  //       hintStyle: TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
  //       filled: true,
  //       fillColor: Color(0xFFF5F8FF),
  //       contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //       border: OutlineInputBorder(
  //         borderRadius: BorderRadius.circular(12),
  //         borderSide: BorderSide.none,
  //       ),
  //       errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 13),
  //     ),
  //   );
  // }

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
                // child: Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(12),
                //     color: Color(0xFFF5F8FF),
                //   ),
                //   child: Row(
                //     children: [
                //       Icon(Icons.access_time, size: 20),
                //       SizedBox(width: 8),
                //       Text(
                //         time != null ? time.format(context) : 'Select $label',
                //         style: TextStyle(fontSize: 14),
                //       ),
                //     ],
                //   ),
                // ),

                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: label,
                    // 👈 label now sits on border
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    labelStyle: const TextStyle(
                      color: Color(0xFF6E6A7C),
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F8FF),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD), // keep same color to avoid blue underline
                        width: 2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD), // 👈 override red with grey
                        width: 2,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFFDDDDDD), // 👈 keep same grey even on focus
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        time != null ? time.format(context) : 'Select $label',
                        style: const TextStyle(fontSize: 14),
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
    print("original date -> ${widget.selectedDate}");
    print("formatted date -> ${DateFormat('yyyy-MM-dd').format(widget.selectedDate)}");
    if (!_formKey.currentState!.validate() ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all required fields including time')),
      );
      return;
    }

    final now = DateTime.now();
    final startDateTime = DateTime(
        now.year, now.month, now.day, _startTime!.hour, _startTime!.minute);
    final endDateTime = DateTime(
        now.year, now.month, now.day, _endTime!.hour, _endTime!.minute);

    // 🔐 Same validation as R&D screen
    if (endDateTime.isBefore(startDateTime) ||
        endDateTime.isAtSameMomentAs(startDateTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return;
    }

    final provider = Provider.of<DailyTaskProvider>(context, listen: false);

    final description = taskDetailsController.text.trim();
    final taskHour = int.tryParse(taskHourController.text.trim()) ?? 0;
    final taskMinute = int.tryParse(taskMinuteController.text.trim()) ?? 0;
    final taskStatus = int.tryParse(_selectedStatus ?? '0') ?? 0;

    final entryDate =
        "${now.month.toString().padLeft(2, '0')}/${now.day.toString().padLeft(2, '0')}/${now.year}";
    final duration = (taskHour * 60) + taskMinute;

    final String startStr = _startTime!.hour.toString().padLeft(2, '0') +
        ':' +
        _startTime!.minute.toString().padLeft(2, '0');
    final String endStr = _endTime!.hour.toString().padLeft(2, '0') +
        ':' +
        _endTime!.minute.toString().padLeft(2, '0');

    final formattedDate = DateFormat('yyyy-MM-dd').format(widget.selectedDate);
    print("🟢 Selected Status before submit: $_selectedStatus");

    await provider.submitDailyTask(
        context: context,
        taskId: widget.task.taskIssueID ?? 0,
        description: description,
        startTime: startStr,
        endTime: endStr,
        taskHour: taskHour,
        taskMinutes: taskMinute,
        taskStatus: taskStatus,
        projectId: projectId,
        moduleId: 0,
        // Replace with actual moduleId if needed
        userId: widget.userId,
      //  actualDate: widget.selectedDate,
        // Replace with actual userId
        selectedDate: formattedDate);
  }

  Widget _buildTimePicker(
      {required String label,
      required TimeOfDay time,
      required VoidCallback onTap}) {
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
            // Image.asset(
            //   'assets/icons/calendar.png',
            //   width: 20,
            //   height: 20,
            // ),
            SvgPicture.asset(
              'assets/icons/calendar.svg',
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
