import 'package:base_app/model/bottom_nav_item_model.dart';
import 'package:base_app/user/login.dart';
import 'package:flutter/material.dart';

class AppConfig{
  static const  String title = "title";
//  static const  String serverUrl = "http://sf.ligengxin.com/api.php/v1";
  static const  String serverUrl = "http://47.254.213.211/api.php/v1";
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
  static GlobalKey<NavigatorState> navigatorKey=GlobalKey();
  static ThemeData themeData = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(
      headline1: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
      headline2: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
      headline3: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
      headline4: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
      headline5: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
      headline6: TextStyle(fontSize: 16,),
      bodyText1: TextStyle(fontSize: 14,),
      bodyText2: TextStyle(fontSize: 14,),
      subtitle1: TextStyle(fontSize: 14),
      subtitle2: TextStyle(fontSize: 12),
      caption: TextStyle(fontSize: 10),
      button: TextStyle(fontSize: 14),
      overline: TextStyle(fontSize: 30),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(50))
      ),
    ),
    inputDecorationTheme:InputDecorationTheme(
        hintStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal),
        contentPadding: const EdgeInsets.only(left: 16,right: 16),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
        ),
),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 0
    ),
  );


  static const String operate0 = "0";	//??????
  static const String operate1 = "1";	//??????
  static const String operate2 = "2";	//?????????Yes / No
  static const String operate3 = "3";	//?????? / ????????????
  static const String operate4 = "4";	//?????????Done / Not Done
  static const String operate5 = "5";	//?????????Clear / Turbid
  static const String operate6 = "6";	//?????? (??????1????????????)
  static const String operate7 = "7";	//??????: Clean / Dirty
  static const String operate8 = "8";	//??????: Acceptable / To be improve
  static const String operate9 = "9";	//??????: Good / Bad selection
  static const String operate10 = "10";	//??????: Carry over / No carryover selection
  static const String operate11 = "11";	//??????: Clear / Turbid selection

  static const String  preOperate0 = "0";	//??????
  static const String  preOperate1 = "1";	//??????
  static const String  preOperate2 = "2";	//	?????? (??????1????????????)
  static const String  preOperate3 = "3";	//????????? Poor condition / Good condition / No equipment at side
  static const String  preOperate4 = "4";	//????????? To be improve / Acceptable
  static const String  preOperate5 = "5";	//?????? (??????2????????????) ??????????????????????????????
  static const String  preOperate6 = "6";	//????????? Have white buble / Don???t have white bubble
  static const String  preOperate7 = "7";	//?????? (???????????????????????????0.00 - 14.00??????)
  static const String  preOperate8 = "8";	//????????? Bad condition / Good condition / Unable to calibrate / No pH probe onsite
  static const String preOperate9 = "9";//	?????????????????? [(calibrated volume/calibration time)*3600]/1000??? 2????????????
  static const String preOperate10 = "10";//	D [(20/calibration time)*3600]/1000??? 2????????????


  static const String type1 = "1";//	Setting range Actual reading Within setting range
  static const String type2 = "2";//	Within setting range
  static const String type3 = "3";//	Action
  static const String type4 = "4";//	Actual reading Within setting range
  static const String type5 = "5";//	Actual reading to fill in
  static const String type6 = "6";//	Clean / Dirty selection
  static const String type7 = "7";//	Acceptable / To be improve selection
  static const String type8 = "8";//	Done / Not done selection
  static const String type9 = "9";//	?????????????????? [(calibrated volume/calibration time)*3600]/1000??? 2????????????
  static const String type10 = "10";//	D [(20/calibration time)*3600]/1000??? 2????????????
}

enum Category{
  performance,preventive
}

