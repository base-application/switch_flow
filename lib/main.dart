import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/privider/company_provider.dart';
import 'package:base_app/router/app_router.gr.dart';
import 'package:base_app/router/auth_guard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'config/app_init.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  AppInit().init().then((value) {
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (BuildContext context) => AuthProvider()),
        ChangeNotifierProvider<CompanyProvider>(create: (BuildContext context) => CompanyProvider()),
      ],
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final _appRouter = AppRouter(navigatorKey: AppConfig.navigatorKey,authGuard: AuthGuard());
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String? token = Provider.of<AuthProvider>(context,listen: false).authUserEntity?.token;

    return MaterialApp.router(
      title: AppConfig.title,
      theme: AppConfig.themeData,
      routerDelegate: _appRouter.delegate(
        initialRoutes: token == null ? [const LoginRoute()] : [const ChooseProfileRoute()]
      ),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
