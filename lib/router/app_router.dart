import 'package:auto_route/annotations.dart';
import 'package:base_app/page/choose_profile.dart';
import 'package:base_app/user/login.dart';

//flutter packages pub run build_runner build
@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: Login, initial: true),
    AutoRoute(page: ChooseProfile),
  ],
)
class $AppRouter {}