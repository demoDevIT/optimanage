import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../selftask/selftask_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/PrefUtil.dart';

class SelfTaskScreen extends StatefulWidget {
  const SelfTaskScreen({Key? key}) : super(key: key);

  @override
  State<SelfTaskScreen> createState() => _SelfTaskScreenState();
}

class _SelfTaskScreenState extends State<SelfTaskScreen> {
  int userId = 0;

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
      final provider = Provider.of<SelfTaskProvider>(context, listen: false);

      // 🔄 Clear all dropdowns and files
      provider.clearSelections();

      // 🧹 Clear all text fields
      taskNameController.clear();
      descriptionController.clear();
      estimatedTimeController.clear();
      notesController.clear();
      documentController.clear();

      // 📆 Reset dates
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      // 🔄 Re-fetch fresh project list
      provider.fetchProjectList(context);
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
        isExpanded: true,
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
                child:
                    // Image.asset(
                    //   'assets/icons/calendar.png',
                    //   width: 20,
                    // ),
                    SvgPicture.asset(
                  'assets/icons/calendar.svg',
                  width: 20,
                  height: 20,
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
    return Stack(children: [
      Scaffold(
        backgroundColor: const Color(0xFFFDFDFD),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(color: Colors.black),
          title: const Text('Self Task Details',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: SvgPicture.asset(
                'assets/icons/notification.svg',
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(8),
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
                    child: DropdownSearch<String>(
                      selectedItem: provider.selectedProjectId == null
                          ? null
                          : provider.projects
                              .firstWhere(
                                  (p) => p.id == provider.selectedProjectId)
                              .name,
                      items: (filter, infiniteScrollProps) =>
                          provider.projects.map((e) => e.name).toList(),
                      popupProps: PopupProps.bottomSheet(
                        showSearchBox: false,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 250),
                      ),
                      dropdownBuilder: (context, selectedItem) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedItem ?? 'Project Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: selectedItem == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          final selected = provider.projects
                              .firstWhere((e) => e.name == val);
                          provider.setSelectedProject(selected.id);

                          provider.setSelectedModule(null);
                          provider.setSelectedSubModule(null);
                          provider.setSelectedTaskType(null);

                          provider.fetchModuleList(context, selected.id);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(8),
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
                    child: DropdownSearch<String>(
                      selectedItem: provider.selectedModuleId == null
                          ? null
                          : provider.modules
                              .firstWhere(
                                  (m) => m.id == provider.selectedModuleId)
                              .name,
                      items: (filter, infiniteScrollProps) =>
                          provider.modules.map((e) => e.name).toList(),
                      popupProps: PopupProps.bottomSheet(
                        showSearchBox: false,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 250),
                      ),
                      dropdownBuilder: (context, selectedItem) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedItem ?? 'Module Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: selectedItem == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          final selected =
                              provider.modules.firstWhere((e) => e.name == val);
                          provider.setSelectedModule(selected.id);

                          // 🟢 Reset submodule and task type when module changes
                          provider.setSelectedSubModule(null);
                          provider.setSelectedTaskType(null);

                          provider.fetchTaskTypeList(context,
                              provider.selectedProjectId!, selected.id);
                          provider.fetchSubModuleList(context, selected.id);
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                if (provider.subModules.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F8FF),
                      borderRadius: BorderRadius.circular(8),
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
                      child: DropdownSearch<String>(
                        selectedItem: provider.selectedSubModuleId == null
                            ? null
                            : provider.subModules
                            .firstWhere((s) => s.id == provider.selectedSubModuleId)
                            .name,
                        items: (filter, infiniteScrollProps) =>
                            provider.subModules.map((e) => e.name).toList(),
                        popupProps: PopupProps.bottomSheet(
                          showSearchBox: false,
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(maxHeight: 250),
                        ),
                        dropdownBuilder: (context, selectedItem) => Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            selectedItem ?? 'Submodule Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: selectedItem == null ? Colors.grey : Colors.black,
                            ),
                          ),
                        ),
                        onChanged: (val) {
                          if (val != null) {
                            final selected =
                            provider.subModules.firstWhere((e) => e.name == val);
                            provider.setSelectedSubModule(selected.id);
                          }
                        },
                      ),
                    ),
                  ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8FF),
                    borderRadius: BorderRadius.circular(8),
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
                    child: DropdownSearch<String>(
                      selectedItem: provider.selectedTaskTypeId == null
                          ? null
                          : provider.taskTypes
                          .firstWhere((t) => t.id == provider.selectedTaskTypeId)
                          .name,
                      items: (filter, infiniteScrollProps) =>
                          provider.taskTypes.map((e) => e.name).toList(),
                      popupProps: PopupProps.bottomSheet(
                        showSearchBox: false,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 250),
                      ),
                      dropdownBuilder: (context, selectedItem) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          selectedItem ?? 'Task Type',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: selectedItem == null ? Colors.grey : Colors.black,
                          ),
                        ),
                      ),
                      onChanged: (val) {
                        if (val != null) {
                          final selected =
                          provider.taskTypes.firstWhere((e) => e.name == val);
                          provider.setSelectedTaskType(selected.id);
                        }
                      },
                    ),
                  ),
                ),


                // _buildValidatedDropdown(
                //   hint: 'Project Name',
                //   items: provider.projects.map((e) => e.name).toList(),
                //   selectedValue: provider.selectedProjectId == null
                //       ? null
                //       : provider.projects
                //           .firstWhere((p) => p.id == provider.selectedProjectId)
                //           .name,
                //   onChanged: (val) {
                //     final selected =
                //         provider.projects.firstWhere((e) => e.name == val);
                //     provider.setSelectedProject(selected.id);
                //
                //     // 🟢 Reset dependent fields
                //     provider.setSelectedModule(null);
                //     provider.setSelectedSubModule(null);
                //     provider.setSelectedTaskType(null);
                //
                //     provider.fetchModuleList(context, selected.id);
                //   },
                // ),

                // _buildValidatedDropdown(
                //   hint: 'Module Name',
                //   items: provider.modules.map((e) => e.name).toList(),
                //   selectedValue: provider.selectedModuleId == null
                //       ? null
                //       : provider.modules
                //           .firstWhere((m) => m.id == provider.selectedModuleId)
                //           .name,
                //   onChanged: (val) {
                //     final selected =
                //         provider.modules.firstWhere((e) => e.name == val);
                //     provider.setSelectedModule(selected.id);
                //
                //     // 🟢 Reset submodule and task type when module changes
                //     provider.setSelectedSubModule(null);
                //     provider.setSelectedTaskType(null);
                //
                //     provider.fetchTaskTypeList(
                //         context, provider.selectedProjectId!, selected.id);
                //     provider.fetchSubModuleList(context, selected.id);
                //   },
                // ),

                // if (provider.subModules.isNotEmpty)
                //   _buildValidatedDropdown(
                //     hint: 'Submodule Name',
                //     items: provider.subModules.map((e) => e.name).toList(),
                //     selectedValue: provider.selectedSubModuleId == null
                //         ? null
                //         : provider.subModules
                //             .firstWhere(
                //                 (s) => s.id == provider.selectedSubModuleId)
                //             .name,
                //     onChanged: (val) {
                //       final selected =
                //           provider.subModules.firstWhere((e) => e.name == val);
                //       provider.setSelectedSubModule(selected.id);
                //     },
                //   ),

                // _buildValidatedDropdown(
                //   hint: 'Task Type',
                //   items: provider.taskTypes.map((e) => e.name).toList(),
                //   selectedValue: provider.selectedTaskTypeId == null
                //       ? null
                //       : provider.taskTypes
                //           .firstWhere(
                //               (t) => t.id == provider.selectedTaskTypeId)
                //           .name,
                //   onChanged: (val) {
                //     final selected =
                //         provider.taskTypes.firstWhere((e) => e.name == val);
                //     provider.setSelectedTaskType(selected.id);
                //   },
                // ),
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
                // Stack(
                //   children: [
                //     Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         ElevatedButton.icon(
                //           onPressed: () {
                //             Provider.of<SelfTaskProvider>(context,
                //                     listen: false)
                //                 .pickDocuments(context);
                //           },
                //           icon: const Icon(
                //             Icons.upload_file,
                //             size: 20,
                //             color: Colors.white, // ✅ white icon
                //           ),
                //           label: const Padding(
                //             padding: EdgeInsets.only(left: 4.0),
                //             // slight padding for spacing
                //             child: Text(
                //               "Upload Documents",
                //               style: TextStyle(color: Colors.white),
                //             ),
                //           ),
                //           style: ElevatedButton.styleFrom(
                //             backgroundColor: const Color(0xFF25507C),
                //             padding: const EdgeInsets.symmetric(
                //                 horizontal: 16, vertical: 12),
                //             // control button size
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(
                //                   30), // rounded pill shape
                //             ),
                //             elevation: 3,
                //           ),
                //         ),
                //         const SizedBox(height: 8),
                //         ...provider.selectedFiles.map((file) => ListTile(
                //               dense: true,
                //               leading: const Icon(Icons.insert_drive_file),
                //               title: Text(file.name),
                //               trailing: IconButton(
                //                 icon: const Icon(Icons.clear, size: 20),
                //                 onPressed: () {
                //                   setState(() {
                //                     provider.selectedFiles.remove(file);
                //                   });
                //                 },
                //               ),
                //             )),
                //       ],
                //     ),
                //
                //     // const Positioned(
                //     //   right: 16,
                //     //   top: 20,
                //     //   child: Icon(Icons.upload_rounded, size: 20),
                //     // )
                //   ],
                // ),

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
                    onPressed: provider.isLoading ? null : _submitSelfTaskForm,
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
      ),
    ]);
  }

  Future<void> _submitSelfTaskForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final provider = Provider.of<SelfTaskProvider>(context, listen: false);
    final int userId = await PrefUtil.getPrefUserId() ?? 0;

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

    bool success = await provider.submitSelfTask(
      context: context,
      projectId: provider.selectedProjectId!,
      moduleId: provider.selectedModuleId!,
      taskTypeId: provider.selectedTaskTypeId!,
      taskName: taskNameController.text.trim(),
      taskDescription: descriptionController.text.trim(),
      userId: userId,
      startDate: formattedStartDate,
      endDate: formattedEndDate,
      taskDuration: taskDuration,
      notes: notesController.text.trim(),
      remarks: documentController.text.trim(),
      isHigherPriority: isPriority ? 1 : 0,
    );

    if (success) {
      provider.isLoading = false;
      provider.notifyListeners();
      _formKey.currentState?.reset();

      taskNameController.clear();
      descriptionController.clear();
      estimatedTimeController.clear();
      notesController.clear();
      documentController.clear();

      setState(() {
        selectedProject = null;
        selectedSubModule = null;
        selectedTaskType = null;
        isPriority = false;
        startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
        endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
      });

      provider.clearSelections();

      print("📦 Form submitted successfully! Navigating back...");

      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    // Clear all controllers
    taskNameController.dispose();
    descriptionController.dispose();
    estimatedTimeController.dispose();
    notesController.dispose();
    documentController.dispose();

    // Clear provider state
    Provider.of<SelfTaskProvider>(context, listen: false).clearSelections();

    super.dispose();
  }
}
