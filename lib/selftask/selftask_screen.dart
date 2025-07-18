import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../selftask/selftask_provider.dart';

class SelfTaskScreen extends StatefulWidget {
  const SelfTaskScreen({Key? key}) : super(key: key);

  @override
  State<SelfTaskScreen> createState() => _SelfTaskScreenState();
}

class _SelfTaskScreenState extends State<SelfTaskScreen> {
  String? selectedProject;
  String? selectedTaskType;
  String? selectedAssignee;
  bool isPriority = false;

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController estimatedTimeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  DateTime startDate = DateTime(2025, 4, 1);
  DateTime endDate = DateTime(2025, 4, 1);

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SelfTaskProvider>(context, listen: false).fetchProjectList(context);
    });
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
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

  Widget _buildDropdown(String hint, List<String> items, String? value,
      void Function(String?) onChanged) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF5F8FF),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: const InputDecoration(border: InputBorder.none),
        hint: Text(hint, style: const TextStyle(color: Color(0xFF6E6A7C))),
        icon: const Icon(
          Icons.arrow_drop_down,
          size: 30,
          color: Colors.black87,
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller,
      {int maxLines = 1}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFFF5F8FF),
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
              color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date, VoidCallback onTap) {
    return Flexible(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FE),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Image.asset(
                  'assets/icons/calendar.png',
                  width: 20,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF5E5E5E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)}, ${date.year}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



  String _monthName(int month) {
    const List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelfTaskProvider>(context);
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: const Text('Self Task Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Image.asset('assets/icons/notification.png', width: 24),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDropdown(
              'Project Name',
              provider.projects.map((e) => e.name).toList(),
              provider.selectedProjectId == null
                  ? null
                  : provider.projects.firstWhere((p) => p.id == provider.selectedProjectId).name,
                  (val) {
                final selected = provider.projects.firstWhere((e) => e.name == val);
                provider.setSelectedProject(selected.id);
                provider.fetchModuleList(context, selected.id);
              },
            ),
            _buildDropdown(
              'Module Name',
              provider.modules.map((e) => e.name).toList(),
              provider.selectedModuleId == null
                  ? null
                  : provider.modules.firstWhere((m) => m.id == provider.selectedModuleId).name,
                  (val) {
                final selected = provider.modules.firstWhere((e) => e.name == val);
                provider.setSelectedModule(selected.id);
                provider.fetchTaskTypeList(context, provider.selectedProjectId!, selected.id);
              },
            ),
            _buildDropdown(
              'Task Type',
              provider.taskTypes.map((e) => e.name).toList(),
              provider.selectedTaskTypeId == null
                  ? null
                  : provider.taskTypes.firstWhere((t) => t.id == provider.selectedTaskTypeId).name,
                  (val) {
                final selected = provider.taskTypes.firstWhere((e) => e.name == val);
                provider.setSelectedTaskType(selected.id);
              },
            ),
            _buildTextField('Task Name', taskNameController),
            _buildTextField('Description', descriptionController, maxLines: 3),
            Row(
              children: [
                _buildDateField('Start Date', startDate, () => _selectDate(context, true)),
                _buildDateField('End Date', endDate, () => _selectDate(context, false)),
              ],
            ),

            _buildTextField(
                'Estimated Time (In Hours)', estimatedTimeController),
            _buildTextField('Notes', notesController),
            Stack(
              children: [
                _buildTextField('Upload Document', documentController),
                const Positioned(
                  right: 16,
                  top: 20,
                  child: Icon(Icons.upload_rounded, size: 20),
                )
              ],
            ),
            _buildDropdown(
                'Assign To', ['Member A', 'Member B'], selectedAssignee, (val) {
              setState(() => selectedAssignee = val);
            }),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title:
                  const Text('Higher Priority', style: TextStyle(fontSize: 14)),
              value: isPriority,
              onChanged: (val) => setState(() => isPriority = val ?? false),
              activeColor: const Color(0xFF25507C),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle submit logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25507C),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
