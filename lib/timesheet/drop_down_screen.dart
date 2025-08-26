import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter_svg/svg.dart';
import 'package:optimanage/timesheet/timesheet_provider.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../notaskassign/notaskassign_provider.dart';
import '../notaskassign/notaskassign_sceen.dart';
import '../utils/PrefUtil.dart';

class DropDownScreen extends StatefulWidget {

 final String type ;
 final DateTime date;
 const DropDownScreen({
   Key? key,required this.type,required this.date
 }) : super(key: key);

 @override
 State<DropDownScreen> createState() => _TimeSheetScreenState();
 }

 class _TimeSheetScreenState extends State<DropDownScreen> {
   final _formKey = GlobalKey<FormState>();
   String? leaveTypeError;
   String? timeError;
   final TextEditingController remarksController = TextEditingController();
   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

   @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        behavior: HitTestBehavior.opaque,
      child:  Scaffold(
        key: _scaffoldKey,
        body: Consumer<timesheet_provider>(
            builder:  (context, provider, child){
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Visibility(
                        visible: widget.type == "No Task Assigned",

                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 10, right: 10), // tighter padding
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'optimanage.devitsandbox.com Says',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    padding: EdgeInsets.zero, // Remove icon padding
                                    constraints: BoxConstraints(), // Shrink tap area
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5), // Smaller spacing

                              // Warning Message
                              const Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Warning: ',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                      'Kindly please add task carefully. If you haven\'t mapped with a Module then contact your team lead for the same. Task added in {No Task} will not be considered for your performance evaluation.',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 6),

                              // OK Button aligned right
                              Align(
                                alignment: Alignment.centerRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    int userId = await PrefUtil.getPrefUserId() ?? 0;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChangeNotifierProvider(
                                          create: (_) => NoTaskAssignProvider(),
                                          child: NoTaskAssignScreen(
                                            selectedDate: DateTime.now(),
                                            userId: userId,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF25507C),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    minimumSize: Size(0, 0), // Important: Shrink button height
                                  ),
                                  child: const Text(
                                    'OK',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // visible: type == "Add Leave" ? true : false,
                      Visibility(
                          visible: widget.type == "Add Leave" ? true : false,
                          child: Form(
                            key: _formKey,
                            //  child: SafeArea(
                            child: SingleChildScrollView(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: MediaQuery.of(context).size.height *
                                      0.6, // Adjust modal height
                                ),
                                //  child: IntrinsicHeight(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: Text(
                                            "Mark Leave (${widget.date.toIso8601String().split('T').first})",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF000000),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              provider.resetLeaveForm(); // 🧹 optional second cleanup
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    // ✅ Add horizontal line below title
                                    const Divider(
                                      color: Color(0xFFE6E6E6),
                                      thickness: 1,
                                      height: 1,
                                      indent: 0,
                                      // ✅ No left margin
                                      endIndent: 0, // ✅ No right margin
                                    ),

                                    const SizedBox(height: 12),

                                    Row(
                                        children: [
                                          Expanded(
                                              child: DropdownSearch<String>(
                                                selectedItem: "Half Day",
                                                items: (filter, infiniteScrollProps) =>
                                                ["Half Day",
                                                  "Full Day",
                                                  "Early Going",
                                                  "Late Coming"],

                                                popupProps: PopupProps.menu(
                                                  showSearchBox: false,
                                                  fit: FlexFit.loose,
                                                  searchFieldProps: TextFieldProps(
                                                    decoration: InputDecoration(
                                                      labelText: "Search",
                                                      prefixIcon:const Icon(Icons.search),
                                                      border: const OutlineInputBorder(),
                                                      enabledBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                                                      ),
                                                      focusedBorder: const OutlineInputBorder(
                                                        borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                      ),
                                                      // border:const OutlineInputBorder(border),
                                                    ),
                                                    style: const TextStyle(fontSize: 14),
                                                  ),
                                                ),

                                                dropdownBuilder: (context, selectedItem) => Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 16),
                                                  child: Text(
                                                    selectedItem ?? "Leave Type",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: selectedItem == null ? Colors.grey : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                onChanged: (val) {
                                                  if (val != null) {
                                                    provider.leaveType = val;
                                                  }
                                                },
                                                validator: (val) {
                                                  if (val == null || val.isEmpty) {
                                                    return 'Please select leave type';
                                                  }
                                                  return null;
                                                },
                                              )),]),

                                    const SizedBox(height: 16),
                                    if ( provider.leaveType == "Half Day" ||
                                        provider.leaveType == "Early Going" ||
                                        provider.leaveType == "Late Coming") ...[
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: GestureDetector(
                                              onTap: () => selectTime(
                                                  context, true, setState,provider),
                                              child: timeInfo("Start Time",
                                                  provider.startTime!.format(context)),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            flex: 5,
                                            child: GestureDetector(
                                              onTap: () => selectTime(
                                                  context, false, setState,provider),
                                              child: timeInfo("End Time",
                                                  provider.endTime!.format(context)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (timeError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 6, left: 4),
                                          child: Text(
                                            timeError!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                              flex: 5,
                                              child: timeInfo(
                                                  "Leave Hour",  provider.leaveHour)),
                                          const SizedBox(width: 12),
                                          Expanded(
                                              flex: 5,
                                              child: timeInfo(
                                                  "Leave Minute",  provider.leaveMinute)),
                                        ],
                                      ),
                                      if (leaveTypeError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6, left: 4),
                                          child: Text(
                                            leaveTypeError!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(height: 16),
                                    ],

                                    TextFormField(
                                      controller: remarksController,
                                      maxLines: 4,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        hintText: 'Description',
                                        filled: true,

                                        fillColor: Color(0xFFF5F9FE),
                                        // Light fill background
                                        contentPadding: const EdgeInsets.all(10),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide.none, // No border
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                              color: Color(0xFF2196F3),
                                              width: 2), // Blue border on focus
                                        ),
                                      ),
                                      validator: (val) =>
                                      (val == null || val.isEmpty)
                                          ? 'Please enter a description'
                                          : null,
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      // Right align
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            provider.resetLeaveForm(); // 🧹 optional second cleanup
                                            Navigator.pop(context);
                                          },
                                          style: OutlinedButton.styleFrom(
                                            side: BorderSide(
                                                color: Color(0xFF25507C)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 10),
                                          ),
                                          child: Text(
                                            'Close',
                                            style: TextStyle(
                                              color: Color(0xFF25507C),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        // Space between buttons
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (!_formKey.currentState!
                                                .validate()) {
                                              debugPrint(
                                                  "❌ Form validation failed");
                                              return;
                                            }
                                            // Navigator.pop(navigatorKey.currentState!.context);

                                            // Start-End Time Validation
                                            final startMinutes =
                                                provider.startTime!.hour * 60 +
                                                    provider.startTime!.minute;
                                            final endMinutes = provider.endTime!.hour * 60 +
                                                provider.endTime!.minute;

                                            if (startMinutes >= endMinutes) {
                                              setState(() {
                                                timeError =
                                                'Start time must be before end time';
                                              });
                                              return;
                                            } else {
                                              setState(() {
                                                timeError = null;
                                              });
                                            }

                                            print("leaveType-${provider.leaveType}");
                                            print("leaveHour-${provider.leaveHours}");
                                            print("leaveminutes-${provider.leaveMinutes}");
                                            // ✅ Half Day validation here (instead of dialog)
                                            if (provider.leaveType == "Half Day" &&
                                                !(provider.leaveHours == 4 && provider.leaveMinutes == 0)) {
                                              setState(() {
                                                leaveTypeError = 'Half Day leave should be exactly 4 hours';
                                              });
                                              return;
                                            }
                                            else {
                                              setState(() {
                                                Navigator.pop(navigatorKey.currentState!.context);
                                                leaveTypeError = null;
                                              });
                                            }

                                            provider.leaveDate = widget.date;

                                            try {
                                              final start = DateTime(
                                                  provider.leaveDate!.year,
                                                  provider.leaveDate!.month,
                                                  provider.leaveDate!.day,
                                                  provider.startTime!.hour,
                                                  provider.startTime!.minute);
                                              final end = DateTime(
                                                  provider.leaveDate!.year,
                                                  provider.leaveDate!.month,
                                                  provider.leaveDate!.day,
                                                  provider.endTime!.hour,
                                                  provider.endTime!.minute);

                                              final duration =
                                              end.difference(start);
                                              provider.leaveHours = duration.inHours;
                                              provider.leaveMinutes =
                                                  duration.inMinutes % 60;
                                              final totalMinutes =
                                                  duration.inMinutes;

                                              final formattedDate =
                                              provider.formatDate(provider.leaveDate!);
                                              final formattedStart =
                                              provider.formatTimeOfDay(provider.startTime!);
                                              final formattedEnd =
                                              provider.formatTimeOfDay(provider.endTime!);
                                              final remarks =
                                              remarksController.text.trim();

                                              final userId =
                                                  await PrefUtil.getPrefUserId() ??
                                                      0;

                                              await provider.submitLeaveRequest(
                                                context: context,
                                                leaveType: provider.leaveType,
                                                leaveDate: formattedDate,
                                                startTime: formattedStart,
                                                endTime: formattedEnd,
                                                leaveHours: provider.leaveHours,
                                                leaveMinutes: provider.leaveMinutes,
                                                leaveTimeInMinutes: totalMinutes,
                                                remarks: remarks,
                                                userId: userId,
                                              );

                                              // await fetchLeaveSummary(
                                              //     focusedDay, userId);
                                              // await fetchTimesheetData(
                                              //     context,
                                              //     focusedDay.month,
                                              //     focusedDay.year,
                                              //     userId);

                                              // Navigator.pop(navigatorKey.currentState!.context);
                                              // Navigator.pop(navigatorKey.currentState!.context);
                                              provider.resetLeaveForm();
                                              // Navigator.pop(navigatorKey.currentState!.context);
                                            } catch (e) {
                                              debugPrint("❌ Save button error: $e");
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF25507C),
                                            // Save button color
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(12),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 24, vertical: 10),
                                          ),
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                //),
                              ),
                            ),
                            // ),

                          )
                        // )
                        // )
                      ),
                    ],
                  ),
                ),
              );
            }
        ),
      )
    );

  }
   Future<void> selectTime(
       BuildContext context, bool isStart, StateSetter setState, timesheet_provider provider) async {
     final picked = await showTimePicker(
       context: context,
       initialTime: isStart ? provider.startTime! : provider.endTime!,
     );

     if (picked != null) {
       setState(() {
         if (isStart) {
           provider.startTime = picked;
         } else {
           provider.endTime = picked;
         }

         final startMinutes = provider.startTime!.hour * 60 + provider.startTime!.minute;
         final endMinutes = provider.endTime!.hour * 60 + provider.endTime!.minute;

         if (endMinutes > startMinutes) {
           final diff = endMinutes - startMinutes;

           // ✅ update both string and int values
           provider.leaveHours = diff ~/ 60;
           provider.leaveMinutes = diff % 60;

           provider.leaveHour = provider.leaveHours.toString();
           provider.leaveMinute = provider.leaveMinutes.toString();
         } else {
           provider.leaveHours = 0;
           provider.leaveMinutes = 0;
           provider. leaveHour = "0";
           provider.leaveMinute = "0";
         }
       });
     }
   }


   Widget timeInfo(String label, String value) {
     return Wrap(
       children: [
         Container(
           padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
           decoration: BoxDecoration(
             color: Color(0xFFF5F9FE), // ✅ Match dropdown background
             borderRadius: BorderRadius.circular(12), // Rounded corners
             // Removed border
           ),
           child: Row(
             children: [
               // Image.asset(
               //   'assets/icons/clockOLD.png',
               //   width: 20,
               //   height: 20,
               // ),
               SvgPicture.asset(
                 'assets/icons/clock.svg',
                 width: 20,
                 height: 20,
               ),
               const SizedBox(width: 8),
               Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text(
                     label,
                     style: const TextStyle(fontSize: 10, color: Colors.grey),
                   ),
                   const SizedBox(width: 20),
                   Text(
                     value,
                     style: const TextStyle(
                       fontSize: 14,
                       color: Color(0xFF25507C),
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                 ],
               ),
             ],
           ),
         )
       ],
     );
   }

 }
