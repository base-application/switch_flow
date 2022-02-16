import 'package:base_app/model/bottom_nav_item_model.dart';
import 'package:base_app/user/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class AppConfig{
  static const  String title = "title";
  static const  String serverUrl = "http://sf.ligengxin.com/api.php/v1";
  static  List<BottomNavItemModel> bottomNavItem = [
    BottomNavItemModel(title:"nav1",icon: Icon(Icons.ac_unit)),
    BottomNavItemModel(title:"nav1",icon: Icon(Icons.ac_unit)),
    BottomNavItemModel(title:"nav1",icon: Icon(Icons.ac_unit)),
    BottomNavItemModel(title:"nav1",icon: Icon(Icons.ac_unit)),
  ];
  static bool showBottomBar = false;
  static bool showFloatingActionButton = false;
  static FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked;
  static Widget firstPage = const Login();
}