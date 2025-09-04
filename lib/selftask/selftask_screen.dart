import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../assignedtask/assignedtask_screen.dart';
import '../selftask/selftask_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../assignedtask/assignedtask_provider.dart';
import '../utils/PrefUtil.dart';

class SelfTaskScreen extends StatefulWidget {
  final DateTime selectedDate;
  final int userId;

//  const SelfTaskScreen({Key? key}) : super(key: key);
  const SelfTaskScreen({
    super.key,
    required this.selectedDate,
    required this.userId,
  });

  @override
  State<SelfTaskScreen> createState() => _SelfTaskScreenState();
}

class _SelfTaskScreenState extends State<SelfTaskScreen> {
  int userId = 0;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? selectedProject;
  String? selectedModule;
  String? selectedSubModule;
  String? selectedTaskType;
  String? selectedAssignee;
  bool isPriority = false;

  //XFile? selectedFile;

  String? projectError;
  String? moduleError;

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
      // startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      // endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);

      startDate = widget.selectedDate;
      endDate = widget.selectedDate;

      // 🔄 Re-fetch fresh project list
      provider.fetchProjectList(context);
      provider.setSelectedProject(null);

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
          // hintText: hint,
          // hintStyle:
          //     TextStyle(color: Color(0xFF6E6A7C), fontWeight: FontWeight.w500),
          labelText: hint, // 👈 Label name at top-left inside border
          floatingLabelBehavior: FloatingLabelBehavior.always,
          labelStyle: const TextStyle(
            color: Color(0xFF6E6A7C),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
          filled: true,
          fillColor: Color(0xFFF5F8FF),
          contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFFDDDDDD),
              width: 2,
            ),
          ),

          // 👇 Border when focused (same as enabledBorder)
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
       // onTap: onTap,
        onTap: null,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F9FE),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color(0xFFDDDDDD), // 👈 same grey border
              width: 2,
            ),
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
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "June",
      "July",
      "Aug",
      "Sept",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SelfTaskProvider>(context);
    bool _isProjectPopupOpen = false;
    bool _isModulePopupOpen = false;
    bool _isSubModulePopupOpen = false;
    bool _isTaskTypePopupOpen = false;
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
                    child: DropdownSearch<String>(
                      selectedItem: provider.selectedProjectId == null
                          ? null
                          : provider.projects
                              .firstWhere(
                                  (p) => p.id == provider.selectedProjectId)
                              .name,
                      items: (filter, infiniteScrollProps) =>
                          provider.projects.map((e) => e.name).toList(),
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 250),
                        menuProps: MenuProps(
                          // this makes the opened list 2 px inset on left and right
                          margin: const EdgeInsets.symmetric(horizontal: -14, vertical: -4),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          backgroundColor: const Color(0xFFF5F8FF), // same bg as your field
                          elevation: 0,
                        ),
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontWeight: FontWeight.w500,// 👈 search text in grey
                            fontSize: 14,
                              fontFamily: 'Inter'
                          ),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500, // 👈 make hint (Search) also boldish
                              color: Color(0xFF555555),
                            ),
                            isDense: true,
                            suffixIcon: const Icon(Icons.search, size: 20),
                            suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.zero,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.zero,
                            ),

                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1.2), // 👈 same as enabled, no highlight
                              borderRadius: BorderRadius.zero,
                            ),

                          ),
                        ),
                        listViewProps: const ListViewProps(
                          padding: EdgeInsets.zero, // 👈 remove gap above list
                        ),
                        itemBuilder: (context, item, isSelected, isFocused) {

                         // final items = ["Item 1", "Item 2", "Item 3"]; // your actual list
                          final isLast = item.indexOf(item.toString()) == item.length - 1;
                          final items = provider.projects.map((e) => e.name).toList(); // your list
                          final index = items.indexOf(item); // current item index

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
                                child: Align(
                                  alignment: Alignment.centerLeft, // force left align
                                  child: Text(
                                    item.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: isSelected ? Colors.blue : const Color(0xFF444444),
                                      //fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              if (index != items.length - 1)
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Color(0xFFEEEEEE),
                                 // indent: 12,
                                 // endIndent: 12,
                                ),
                            ],
                          );
                        },

                        onDismissed: () => setState(() => _isProjectPopupOpen = false),
                        containerBuilder: (ctx, popupWidget) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!_isProjectPopupOpen) {
                              setState(() => _isProjectPopupOpen = true);
                            }
                          });
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
                      dropdownBuilder: (context, selectedItem) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8FF),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(8),
                              topRight: const Radius.circular(8),
                              bottomLeft: Radius.circular(_isProjectPopupOpen ? 0 : 8), // flatten bottom when open
                              bottomRight: Radius.circular(_isProjectPopupOpen ? 0 : 8),
                            ),

                          ),
                          padding: const EdgeInsets.only(left: 0, top: 4, bottom: 14, right: 12),
                          child: Text(
                            selectedItem ?? "Project Name",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedItem == null ? Color(0xFF6E6A7C) : Colors.black,
                            ),
                          ),
                        );
                      },

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
                // if (projectError != null)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 4, top: 4),
                //     child: Text(
                //       projectError!,
                //       style: const TextStyle(
                //         fontSize: 12,
                //         color: Colors.red,
                //         fontWeight: FontWeight.w500,
                //       ),
                //     ),
                //   ),
                const SizedBox(height: 12),

                Container(
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
                    child: DropdownSearch<String>(
                      selectedItem: provider.selectedModuleId == null
                          ? null
                          : provider.modules
                              .firstWhere(
                                  (m) => m.id == provider.selectedModuleId)
                              .name,
                      items: (filter, infiniteScrollProps) =>
                          provider.modules.map((e) => e.name).toList(),
                      enabled: provider.selectedProjectId != null,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 250),
                        menuProps: MenuProps(
                          // this makes the opened list 2 px inset on left and right
                          margin: const EdgeInsets.symmetric(horizontal: -14, vertical: -4),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          backgroundColor: const Color(0xFFF5F8FF), // same bg as your field
                          elevation: 0,
                        ),
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,// 👈 search text in grey
                              fontSize: 14,
                              fontFamily: 'Inter'
                          ),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500, // 👈 make hint (Search) also boldish
                              color: Color(0xFF555555),
                            ),
                            isDense: true,
                            suffixIcon: const Icon(Icons.search, size: 20),
                            suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.zero,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.zero,
                            ),

                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1.2), // 👈 same as enabled, no highlight
                              borderRadius: BorderRadius.zero,
                            ),

                          ),
                        ),
                        listViewProps: const ListViewProps(
                          padding: EdgeInsets.zero, // 👈 remove gap above list
                        ),
                        itemBuilder: (context, item, isSelected, isFocused) {

                          // final items = ["Item 1", "Item 2", "Item 3"]; // your actual list
                          final isLast = item.indexOf(item.toString()) == item.length - 1;
                          final items = provider.projects.map((e) => e.name).toList(); // your list
                          final index = items.indexOf(item); // current item index

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
                                child: Align(
                                  alignment: Alignment.centerLeft, // force left align
                                  child: Text(
                                    item.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: isSelected ? Colors.blue : const Color(0xFF444444),
                                      //fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              if (index != items.length - 1)
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Color(0xFFEEEEEE),
                                  // indent: 12,
                                  // endIndent: 12,
                                ),
                            ],
                          );
                        },
                        onDismissed: () => setState(() => _isModulePopupOpen = false),
                        containerBuilder: (ctx, popupWidget) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!_isModulePopupOpen) {
                              setState(() => _isModulePopupOpen = true);
                            }
                          });
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
                      dropdownBuilder: (context, selectedItem) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8FF),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(_isModulePopupOpen ? 0 : 8), // flatten bottom when open
                              bottomRight: Radius.circular(_isModulePopupOpen ? 0 : 8),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 0, top: 4, bottom: 14, right: 12),
                          child: Text(
                            selectedItem ?? "Module Name",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedItem == null ? Color(0xFF6E6A7C) : Colors.black,
                            ),
                          ),
                        );
                      },

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
                      child: DropdownSearch<String>(
                        selectedItem: provider.selectedSubModuleId == null
                            ? null
                            : provider.subModules
                                .firstWhere(
                                    (s) => s.id == provider.selectedSubModuleId)
                                .name,
                        items: (filter, infiniteScrollProps) =>
                            provider.subModules.map((e) => e.name).toList(),
                        enabled: provider.selectedModuleId != null,
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          fit: FlexFit.loose,
                          constraints: BoxConstraints(maxHeight: 250),
                          menuProps: MenuProps(
                            // this makes the opened list 2 px inset on left and right
                            margin: const EdgeInsets.symmetric(horizontal: -14, vertical: -4),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
                            ),
                            backgroundColor: const Color(0xFFF5F8FF), // same bg as your field
                            elevation: 0,
                          ),
                          searchFieldProps: TextFieldProps(
                            style: const TextStyle(
                                color: Color(0xFF555555),
                                fontWeight: FontWeight.w500,// 👈 search text in grey
                                fontSize: 14,
                                fontFamily: 'Inter'
                            ),
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w500, // 👈 make hint (Search) also boldish
                                color: Color(0xFF555555),
                              ),
                              isDense: true,
                              suffixIcon: const Icon(Icons.search, size: 20),
                              suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                              border: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                                borderRadius: BorderRadius.zero,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                                borderRadius: BorderRadius.zero,
                              ),

                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1.2), // 👈 same as enabled, no highlight
                                borderRadius: BorderRadius.zero,
                              ),

                            ),
                          ),
                          listViewProps: const ListViewProps(
                            padding: EdgeInsets.zero, // 👈 remove gap above list
                          ),
                          itemBuilder: (context, item, isSelected, isFocused) {

                            // final items = ["Item 1", "Item 2", "Item 3"]; // your actual list
                            final isLast = item.indexOf(item.toString()) == item.length - 1;
                            final items = provider.projects.map((e) => e.name).toList(); // your list
                            final index = items.indexOf(item); // current item index

                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
                                  child: Align(
                                    alignment: Alignment.centerLeft, // force left align
                                    child: Text(
                                      item.toString(),
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: isSelected ? Colors.blue : const Color(0xFF444444),
                                        //fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                                if (index != items.length - 1)
                                  const Divider(
                                    height: 1,
                                    thickness: 0.8,
                                    color: Color(0xFFEEEEEE),
                                    // indent: 12,
                                    // endIndent: 12,
                                  ),
                              ],
                            );
                          },
                          onDismissed: () => setState(() => _isSubModulePopupOpen = false),
                          containerBuilder: (ctx, popupWidget) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!_isModulePopupOpen) {
                                setState(() => _isModulePopupOpen = true);
                              }
                            });
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
                        dropdownBuilder: (context, selectedItem) {
                          return Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F8FF),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(12),
                                topRight: const Radius.circular(12),
                                bottomLeft: Radius.circular(_isModulePopupOpen ? 0 : 12), // flatten bottom when open
                                bottomRight: Radius.circular(_isModulePopupOpen ? 0 : 12),
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 0, top: 4, bottom: 14, right: 12),
                            child: Text(
                              selectedItem ?? "Submodule Name",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: selectedItem == null ? Color(0xFF6E6A7C) : Colors.black,
                              ),
                            ),
                          );
                        },

                        onChanged: (val) {
                          if (val != null) {
                            final selected = provider.subModules
                                .firstWhere((e) => e.name == val);
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
                    child: DropdownSearch<String>(
                      selectedItem: provider.selectedTaskTypeId == null
                          ? null
                          : provider.taskTypes
                              .firstWhere(
                                  (t) => t.id == provider.selectedTaskTypeId)
                              .name,
                      items: (filter, infiniteScrollProps) =>
                          provider.taskTypes.map((e) => e.name).toList(),
                      enabled: provider.selectedProjectId != null,
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        fit: FlexFit.loose,
                        constraints: BoxConstraints(maxHeight: 250),
                        menuProps: MenuProps(
                          // this makes the opened list 2 px inset on left and right
                          margin: const EdgeInsets.symmetric(horizontal: -14, vertical: -4),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          backgroundColor: const Color(0xFFF5F8FF), // same bg as your field
                          elevation: 0,
                        ),
                        searchFieldProps: TextFieldProps(
                          style: const TextStyle(
                              color: Color(0xFF555555),
                              fontWeight: FontWeight.w500,// 👈 search text in grey
                              fontSize: 14,
                              fontFamily: 'Inter'
                          ),
                          decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500, // 👈 make hint (Search) also boldish
                              color: Color(0xFF555555),
                            ),
                            isDense: true,
                            suffixIcon: const Icon(Icons.search, size: 20),
                            suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 24),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.zero,
                            ),
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                              borderRadius: BorderRadius.zero,
                            ),

                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFDDDDDD), width: 1.2), // 👈 same as enabled, no highlight
                              borderRadius: BorderRadius.zero,
                            ),

                          ),
                        ),
                        listViewProps: const ListViewProps(
                          padding: EdgeInsets.zero, // 👈 remove gap above list
                        ),
                        itemBuilder: (context, item, isSelected, isFocused) {

                          // final items = ["Item 1", "Item 2", "Item 3"]; // your actual list
                          final isLast = item.indexOf(item.toString()) == item.length - 1;
                          final items = provider.projects.map((e) => e.name).toList(); // your list
                          final index = items.indexOf(item); // current item index

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 23),
                                child: Align(
                                  alignment: Alignment.centerLeft, // force left align
                                  child: Text(
                                    item.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      color: isSelected ? Colors.blue : const Color(0xFF444444),
                                      //fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              if (index != items.length - 1)
                                const Divider(
                                  height: 1,
                                  thickness: 0.8,
                                  color: Color(0xFFEEEEEE),
                                  // indent: 12,
                                  // endIndent: 12,
                                ),
                            ],
                          );
                        },
                        onDismissed: () => setState(() => _isTaskTypePopupOpen = false),
                        containerBuilder: (ctx, popupWidget) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (!_isModulePopupOpen) {
                              setState(() => _isModulePopupOpen = true);
                            }
                          });
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

                      dropdownBuilder: (context, selectedItem) {
                        return Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F8FF),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(12),
                              topRight: const Radius.circular(12),
                              bottomLeft: Radius.circular(_isModulePopupOpen ? 0 : 12), // flatten bottom when open
                              bottomRight: Radius.circular(_isModulePopupOpen ? 0 : 12),
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 0, top: 4, bottom: 14, right: 12),
                          child: Text(
                            selectedItem ?? "Task Type",
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: selectedItem == null ? Color(0xFF6E6A7C) : Colors.black,
                            ),
                          ),
                        );
                      },
                      onChanged: (val) {
                        if (val != null) {
                          final selected = provider.taskTypes
                              .firstWhere((e) => e.name == val);
                          provider.setSelectedTaskType(selected.id);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                _buildTextField('Task Name', taskNameController,
                    isRequired: true),
                const SizedBox(height: 4),
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
                const SizedBox(height: 6),
                _buildTextField(
                    'Estimated Time (In Hours)', estimatedTimeController,
                    isRequired: true, keyboardType: TextInputType.number),
                const SizedBox(height: 4),
                _buildTextField('Notes', notesController),

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
    // if (selectedProject == null) {
    //   setState(() => projectError = "Please select project");
    //   return;
    // }
    //
    // if (selectedModule == null) {
    //   setState(() => moduleError = "Please select module");
    //   return;
    // }

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

     // Navigator.pop(context, true);

      // as discussed with mohit, redirect to assigned page directly
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) =>
      //         AssignedTaskScreen(
      //           selectedDate: widget.selectedDate!,
      //           userId: userId,
      //         ),
      //
      //   ),
      // );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (_) => AssignedTaskProvider(),
            child: AssignedTaskScreen(
              selectedDate: widget.selectedDate!,
              userId: userId,
            ),
          ),
        ),
      );
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

// class ProjectDropdown extends StatefulWidget {
//   const ProjectDropdown({super.key});
//
//   @override
//   State<ProjectDropdown> createState() => _ProjectDropdownState();
// }
//
// class _ProjectDropdownState extends State<ProjectDropdown> {
//   bool _isOpen = false; // track dropdown state
//
//   @override
//   Widget build(BuildContext context) {
//     return DropdownSearch<String>(
//       items: ["NOC", "OptiSync"],
//       selectedItem: null,
//       popupProps: PopupProps.menu(
//         showSearchBox: true,
//         containerBuilder: (ctx, popupWidget) {
//           return Material(
//             color: Colors.white,
//             shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(0),
//                 topRight: Radius.circular(0),
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//             ),
//             child: popupWidget,
//           );
//         },
//       ),
//       dropdownBuilder: (context, selectedItem) {
//         return Container(
//           decoration: BoxDecoration(
//             color: const Color(0xFFF5F8FF),
//             borderRadius: BorderRadius.only(
//               topLeft: const Radius.circular(12),
//               topRight: const Radius.circular(12),
//               bottomLeft: Radius.circular(_isOpen ? 0 : 12), // 👈 flat when open
//               bottomRight: Radius.circular(_isOpen ? 0 : 12), // 👈 flat when open
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
//           child: Text(
//             selectedItem ?? "Project Name",
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.w500,
//               color: selectedItem == null ? Colors.grey : Colors.black,
//             ),
//           ),
//         );
//       },
//       onPopupOpen: () => setState(() => _isOpen = true),   // track open
//       onPopupClose: () => setState(() => _isOpen = false), // track close
//     );
//   }
// }

