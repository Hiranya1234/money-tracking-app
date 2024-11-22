import 'package:flutter/material.dart';
import 'package:flutter_application_4/utils/icon_list.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryDropDown extends StatefulWidget {
  CategoryDropDown({
    super.key,
    this.cattype,
    required this.onChanged,
    required this.userCategories,
  });
  
  final String? cattype;
  final ValueChanged<String?> onChanged;
  final List<String> userCategories;

  @override
  State<CategoryDropDown> createState() => _CategoryDropDownState();
}

class _CategoryDropDownState extends State<CategoryDropDown> {
  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> allCategories = [
      ...appIcons.homeExpensesCategories,
      ...widget.userCategories.map((e) => {"name": e, "icon": FontAwesomeIcons.tags}),
    ];

    return DropdownButton<String>(
      value: widget.cattype,
      isExpanded: true,
      hint: Text("Select Category"),
      items: allCategories
          .map((e) => DropdownMenuItem<String>(
                value: e['name'],
                child: Row(
                  children: [
                    Icon(
                      e['icon'],
                      color: Colors.black54,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      e['name'],
                      style: TextStyle(color: Colors.black45),
                    ),
                  ],
                ),
              ))
          .toList(),
      onChanged: widget.onChanged,
    );
  }
}
