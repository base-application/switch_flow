
import 'package:auto_route/annotations.dart';
import 'package:base_app/page/choose_profile.dart';
import 'package:base_app/page/performance.dart';
import 'package:base_app/page/preventive.dart';
import 'package:base_app/user/login.dart';

import 'auth_guard.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    AutoRoute(page: Login),
    AutoRoute(page: ChooseProfile),
    AutoRoute(page: Preventive,guards: [AuthGuard],),
    AutoRoute(page: Performance,guards: [AuthGuard],),
  ],
)
class $AppRouter {}