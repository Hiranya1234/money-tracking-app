import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppIcons{
  final List<Map<String,dynamic>> homeExpensesCategories = [
    {
      "name":"Gas Filling",
      "icon": FontAwesomeIcons.gasPump,
    },
    {
      "name":"Grocery",
      "icon": FontAwesomeIcons.cartShopping,
    },
    {
      "name":"Communication",
      "icon": FontAwesomeIcons.wifi,
    },
    {
      "name":"Electricity",
      "icon": FontAwesomeIcons.bolt,
    },
    {
      "name":"Education",
      "icon": FontAwesomeIcons.graduationCap,
    },
    {
      "name":"Health",
      "icon": FontAwesomeIcons.heartPulse,
    },
    {
      "name":"Trasportation",
      "icon": FontAwesomeIcons.bus,
    },
    {
      "name":"Entertainment",
      "icon": FontAwesomeIcons.music,
    },
    {
      "name":"Others",
      "icon": FontAwesomeIcons.bus,
    },
  ];

  IconData getExpenseCategoryIcons(String categoryName){
    final Category = homeExpensesCategories.firstWhere(
      (Category) => Category['name'] == categoryName, 
      orElse: ()=>{"icon": FontAwesomeIcons.moneyCheck});
    return Category['icon'];
  }
}
