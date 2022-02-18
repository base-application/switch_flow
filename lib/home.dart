import 'package:base_app/config/app_config.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: const Center(
        child: Text("body"),
      ),
      extendBody: true,
      floatingActionButton: AppConfig.showFloatingActionButton? FloatingActionButton(
        onPressed: () {  },
      ):null,
      floatingActionButtonLocation: AppConfig.showFloatingActionButton? AppConfig.floatingActionButtonLocation : null,
      bottomNavigationBar: AppConfig.showBottomBar ? BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: AppConfig.bottomNavItem.map<Widget>((e) =>
              SizedBox(
                height: 60,
                child:  Text(e.title),
              )
          ).toList(),
        ),
      ) : null
    );
  }
}
