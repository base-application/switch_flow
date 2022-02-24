import 'package:auto_route/auto_route.dart';
import 'package:base_app/config/app_config.dart';
import 'package:base_app/privider/auth_provider.dart';
import 'package:base_app/router/app_router.gr.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;
class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    developer.log(resolver.route.name,name: "auth guard");

    String? token = Provider.of<AuthProvider>(AppConfig.navigatorKey.currentContext!,listen: false).authUserEntity.token;
    if(token == null && resolver.route.name != LoginRoute.name){
      router.push(const LoginRoute());
    }
    if (token!=null && resolver.route.name == LoginRoute.name) {
      router.replaceAll([const ChooseProfileRoute()]);
    } else {
      resolver.next(true);
    }
  }
}
