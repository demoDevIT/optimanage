import 'dart:async';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';



class CommonDropdownSearch<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String labelText;
  final String searchHintText;
  final String dropdownHintText;
  final bool showSearchBox;
  final String Function(T)? itemAsString;
  final Widget Function(BuildContext, T?)? dropdownBuilder;
  final FutureOr<List<T>> Function(String, LoadProps?)? itemsCallback;
  final bool Function(T, String)? filterFn;

  CommonDropdownSearch({
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.labelText,
    required this.searchHintText,
    required this.dropdownHintText,
    this.showSearchBox = true,
    this.itemAsString,
    this.dropdownBuilder,
    this.itemsCallback,
    this.filterFn,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      items: itemsCallback ??
              (String filter, LoadProps? loadProps) async {
            if (filter.isEmpty) {
              return items;
            } else {
              return items
                  .where((item) => itemAsString!(item)
                  .toLowerCase()
                  .contains(filter.toLowerCase()))
                  .toList();
            }
          },
      compareFn: (T item1, T item2) => item1 == item2,
      selectedItem: selectedItem,
      itemAsString: itemAsString,
      onChanged: onChanged,
      dropdownBuilder: dropdownBuilder,
      popupProps: PopupProps.menu(
        fit: FlexFit.loose,
        showSearchBox: true,
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHintText,
            prefixIcon: const Icon(Icons.search, size: 20),
            border: InputBorder.none, // 🔥 removes border
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          style: const TextStyle(fontSize: 14),
        ),
        containerBuilder: (_, searchBox) => Container(
          margin:const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
          child: searchBox,
        ),
      ),
      filterFn: filterFn,
      validator: (T? item) => null,
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F8FF), // bg color
          hintText: dropdownHintText,
          labelText: labelText,
          hintStyle: const TextStyle(fontSize: 14),
          labelStyle: const TextStyle(fontSize: 14),
          border: InputBorder.none, // 🔥 removes outline border
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
      // decoratorProps: DropDownDecoratorProps(
      //   decoration: InputDecoration(
      //     labelText: labelText,
      //     hintText: dropdownHintText,
      //     border:const OutlineInputBorder(borderRadius: BorderRadius.all(
      //       Radius.circular(16.0),
      //     ),),
      //     hintStyle: const TextStyle(fontSize: 14),
      //     labelStyle:const  TextStyle(fontSize: 14),
      //   ),
      // ),
    );
  }


}
