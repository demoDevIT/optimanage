import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../selftask/selftask_provider.dart';
import 'package:file_picker/file_picker.dart';

class SelfTaskScreen extends StatefulWidget {
  const SelfTaskScreen({Key? key}) : super(key: key);

  @override
  State<SelfTaskScreen> createState() => _SelfTaskScreenState();
}

class _SelfTaskScreenState extends State<SelfTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedProject;
  String? selectedSubModule;
  String? selectedTaskType;
  String? selectedAssignee;
  bool isPriority = false;

  //XFile? selectedFile;

  final TextEditingController taskNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController estimatedTimeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController documentController = TextEditingController();

  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SelfTaskProvider>(context, listen: false)
          .fetchProjectList(context);
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

  Widget _buildValidatedDropdown({
    required String hint,
    required List<String> items,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        validator: (value) => value == null ? 'Please select $hint' : null,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF5F8FF),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          errorStyle: TextStyle(color: Colors.red.shade700, fontSize: 13),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    TextEditingController controller, {
    bool isRequired = false,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        maxLines: maxLines,
        keyboardType: keyboardType,
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
          hintStyle:
              TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildValidatedDropdown(
                hint: 'Project Name',
                items: provider.projects.map((e) => e.name).toList(),
                selectedValue: provider.selectedProjectId == null
                    ? null
                    : provider.projects
                        .firstWhere((p) => p.id == provider.selectedProjectId)
                        .name,
                onChanged: (val) {
                  final selected =
                      provider.projects.firstWhere((e) => e.name == val);
                  provider.setSelectedProject(selected.id);
                  provider.fetchModuleList(context, selected.id);
                },
              ),
              _buildValidatedDropdown(
                hint: 'Module Name',
                items: provider.modules.map((e) => e.name).toList(),
                selectedValue: provider.selectedModuleId == null
                    ? null
                    : provider.modules
                        .firstWhere((m) => m.id == provider.selectedModuleId)
                        .name,
                onChanged: (val) {
                  final selected =
                      provider.modules.firstWhere((e) => e.name == val);
                  provider.setSelectedModule(selected.id);
                  provider.fetchTaskTypeList(
                      context, provider.selectedProjectId!, selected.id);
                  provider.fetchSubModuleList(context, selected.id);
                },
              ),
              if (provider.subModules.isNotEmpty)
                _buildValidatedDropdown(
                  hint: 'Submodule Name',
                  items: provider.subModules.map((e) => e.name).toList(),
                  selectedValue: provider.selectedSubModuleId == null
                      ? null
                      : provider.subModules
                          .firstWhere(
                              (s) => s.id == provider.selectedSubModuleId)
                          .name,
                  onChanged: (val) {
                    final selected =
                        provider.subModules.firstWhere((e) => e.name == val);
                    provider.setSelectedSubModule(selected.id);
                  },
                ),

              _buildValidatedDropdown(
                hint: 'Task Type',
                items: provider.taskTypes.map((e) => e.name).toList(),
                selectedValue: provider.selectedTaskTypeId == null
                    ? null
                    : provider.taskTypes
                        .firstWhere((t) => t.id == provider.selectedTaskTypeId)
                        .name,
                onChanged: (val) {
                  final selected =
                      provider.taskTypes.firstWhere((e) => e.name == val);
                  provider.setSelectedTaskType(selected.id);
                },
              ),
              _buildTextField('Task Name', taskNameController,
                  isRequired: true),
              _buildTextField('Description', descriptionController,
                  maxLines: 3, isRequired: true),
              Row(
                children: [
                  _buildDateField('Start Date', startDate,
                      () => _selectDate(context, true)),
                  _buildDateField(
                      'End Date', endDate, () => _selectDate(context, false)),
                ],
              ),

              _buildTextField(
                  'Estimated Time (In Hours)', estimatedTimeController,
                  isRequired: true, keyboardType: TextInputType.number),
              _buildTextField('Notes', notesController),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () =>
                        Provider.of<SelfTaskProvider>(context, listen: false)
                            .pickDocument(context),
                    child: AbsorbPointer(
                      child: _buildTextField(
                        provider.selectedFile?.name ?? 'Upload Document',
                        documentController,
                        readOnly: true,
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 16,
                    top: 20,
                    child: Icon(Icons.upload_rounded, size: 20),
                  )
                ],
              ),

              // _buildValidatedDropdown(
              //   hint: 'Assign To',
              //   items: ['Member A', 'Member B'],
              //   selectedValue: selectedAssignee,
              //   onChanged: (val) => setState(() => selectedAssignee = val),
              // ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text('Higher Priority',
                    style: TextStyle(fontSize: 14)),
                value: isPriority,
                onChanged: (val) => setState(() => isPriority = val ?? false),
                activeColor: const Color(0xFF25507C),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitSelfTaskForm,
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
      ),
    );
  }

  Future<void> _submitSelfTaskForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final provider = Provider.of<SelfTaskProvider>(context, listen: false);

    if (provider.selectedProjectId == null ||
        provider.selectedModuleId == null ||
        provider.selectedTaskTypeId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select all dropdowns')),
      );
      return;
    }

    final String formattedStartDate =
        "${startDate.month}/${startDate.day}/${startDate.year}";
    final String formattedEndDate =
        "${endDate.month}/${endDate.day}/${endDate.year}";

    final int taskDuration =
        int.tryParse(estimatedTimeController.text.trim()) ?? 0;

    await provider.submitSelfTask(
      context: context,
      projectId: provider.selectedProjectId!,
      moduleId: provider.selectedModuleId!,
      taskTypeId: provider.selectedTaskTypeId!,
      taskName: taskNameController.text.trim(),
      taskDescription: descriptionController.text.trim(),
      userId: 55,
      // 🔁 Replace with actual user ID
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      taskDuration: taskDuration,
      notes: notesController.text.trim(),
      document: provider.selectedFile?.name ?? 'https://example.com/demo.pdf',
      // or some placeholder if required
      remarks: documentController.text.trim(),
      isHigherPriority: isPriority ? 1 : 0,
    );
  }
}
