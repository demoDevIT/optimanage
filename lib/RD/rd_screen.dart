import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant/common.dart';

class RdScreen extends StatefulWidget {
  @override
  State<RdScreen> createState() => _RdScreenState();
}

class _RdScreenState extends State<RdScreen> {
  String? selectedProject;
  String? selectedModule;
  DateTime startDate = DateTime(2025, 4, 1);
  DateTime endDate = DateTime(2025, 4, 1);

  final taskDetailsController = TextEditingController();
  final taskHourController = TextEditingController();
  final taskMinuteController = TextEditingController();

  List<String> projects = ['Project A', 'Project B'];
  List<String> modules = ['Module X', 'Module Y'];

  Future<void> _selectDate(bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          startDate = picked;
        } else {
          endDate = picked;
        }
      });
    }
  }

  Widget _calendarDatePicker(String label, DateTime date, bool isStart) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectDate(isStart),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFFF5F8FF),
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/icons/calendar.png',
                width: 20,
                height: 20,
              ),
              SizedBox(width: 8),
              Text(
                DateFormat('dd MMMM, yyyy').format(date),
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textInput(
      {required String hint,
      TextEditingController? controller,
      int maxLines = 1,
      TextInputType? keyboardType}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF5F8FF),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:
              TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _dropdownInput(
      {required String hint,
      required List<String> items,
      String? selected,
      required void Function(String?) onChanged}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color(0xFFF5F8FF),
      ),
      child: DropdownButtonFormField<String>(
        value: selected,
        onChanged: onChanged,
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 30,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        hint: Text(hint, style: TextStyle(color: Color(0xFF6E6A7C))),
        items: items.map((value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: common.Appbar(
        title: "R&D Tasks",
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Daily Task Details (29-04-2025) (R&D)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            _dropdownInput(
              hint: 'Project Name',
              items: projects,
              selected: selectedProject,
              onChanged: (val) => setState(() => selectedProject = val),
            ),
            _dropdownInput(
              hint: 'Module',
              items: modules,
              selected: selectedModule,
              onChanged: (val) => setState(() => selectedModule = val),
            ),
            _textInput(
                hint: 'Daily Task Details',
                controller: taskDetailsController,
                maxLines: 3),
            SizedBox(height: 6),
            Row(
              children: [
                _calendarDatePicker("Start Date", startDate, true),
                SizedBox(width: 10),
                _calendarDatePicker("End Date", endDate, false),
              ],
            ),
            _textInput(
                hint: 'Task Hour',
                controller: taskHourController,
                keyboardType: TextInputType.number),
            _textInput(
                hint: 'Task Minute',
                controller: taskMinuteController,
                keyboardType: TextInputType.number),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle form submission
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF25507C),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Submit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18, // 👈 Increase this for larger text
                      fontWeight:
                          FontWeight.w600, // Optional: make it semi-bold
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
