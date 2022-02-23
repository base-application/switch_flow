import 'package:base_app/model/bottom_nav_item_model.dart';
import 'package:base_app/user/login.dart';
import 'package:flutter/material.dart';

class AppConfig{
  static const  String title = "title";
  static const  String serverUrl = "http://sf.ligengxin.com/api.php/v1";
  static  List<BottomNavItemModel> bottomNavItem = [
    BottomNavItemModel(title:"nav1",icon: const Icon(Icons.ac_unit)),
    BottomNavItemModel(title:"nav1",icon: const Icon(Icons.ac_unit)),
    BottomNavItemModel(title:"nav1",icon: const Icon(Icons.ac_unit)),
    BottomNavItemModel(title:"nav1",icon: const Icon(Icons.ac_unit)),
  ];
  static bool showBottomBar = false;
  static bool showFloatingActionButton = false;
  static FloatingActionButtonLocation floatingActionButtonLocation = FloatingActionButtonLocation.centerDocked;
  static Widget firstPage = const Login();


  static const String operate0 = "0";	//展示
  static const String operate1 = "1";	//输入
  static const String operate2 = "2";	//选择：Yes / No
  static const String operate3 = "3";	//输入 / 选择日期
  static const String operate4 = "4";	//选择：Done / Not Done
  static const String operate5 = "5";	//选择：Clear / Turbid
  static const String operate6 = "6";	//输入 (限制1个小数点)
  static const String operate7 = "7";	//选择: Clean / Dirty
  static const String operate8 = "8";	//选择: Acceptable / To be improve

  static const String  preOperate0 = "0";	//展示
  static const String  preOperate1 = "1";	//输入
  static const String  preOperate2 = "2";	//	输入 (限制1个小数点)
  static const String  preOperate3 = "3";	//选择： Poor condition / Good condition / No equipment at side
  static const String  preOperate4 = "4";	//选择： To be improve / Acceptable
  static const String  preOperate5 = "5";	//输入 (限制2个小数点) 此类型需要演算法运作
  static const String  preOperate6 = "6";	//选择： Have white buble / Don’t have white bubble
  static const String  preOperate7 = "7";	//输入 (所输入的价值必须在0.00 - 14.00之间)
  static const String  preOperate8 = "8";	//选择： Bad condition / Good condition / Unable to calibrate / No pH probe onsite



  static const String type1 = "1";//	Setting range Actual reading Within setting range
  static const String type2 = "2";//	Within setting range
  static const String type3 = "3";//	Action
  static const String type4 = "4";//	Actual reading Within setting range
  static const String type5 = "5";//	Actual reading to fill in
  static const String type6 = "6";//	Clean / Dirty selection
  static const String type7 = "7";//	Acceptable / To be improve selection
  static const String type8 = "8";//	Done / Not done selection
}

enum Category{
  performance,preventive
}

