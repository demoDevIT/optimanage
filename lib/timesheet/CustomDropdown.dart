import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CustomDropdown extends StatelessWidget {
  const CustomDropdown({super.key,});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return  Scaffold(
      key: scaffoldKey,
      body: DropdownSearch<String>(
        selectedItem: "BottomSheet",
        items: (String? filter, _) async {
          return ["Menu", "Dialog", "Modal", "BottomSheet"];
        },
        onChanged: (value){

        },
        popupProps: const PopupProps.bottomSheet(
          fit: FlexFit.loose,
          constraints: BoxConstraints(),
        ),
        decoratorProps: DropDownDecoratorProps(
          decoration: InputDecoration(
            labelText: 'Examples for: ',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
