// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

import 'package:auto_route/auto_route.dart' as _i5;
import 'package:flutter/material.dart' as _i6;

import '../model/index_entity.dart' as _i8;
import '../page/choose_profile.dart' as _i2;
import '../page/performance.dart' as _i4;
import '../page/preventive.dart' as _i3;
import '../user/login.dart' as _i1;
import 'auth_guard.dart' as _i7;

class AppRouter extends _i5.RootStackRouter {
  AppRouter(
      {_i6.GlobalKey<_i6.NavigatorState>? navigatorKey,
      required this.authGuard})
      : super(navigatorKey);

  final _i7.AuthGuard authGuard;

  @override
  final Map<String, _i5.PageFactory> pagesMap = {
    LoginRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i1.Login());
    },
    ChooseProfileRoute.name: (routeData) {
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData, child: const _i2.ChooseProfile());
    },
    PreventiveRoute.name: (routeData) {
      final args = routeData.argsAs<PreventiveRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i3.Preventive(
              key: args.key, indexSelect: args.indexSelect, plant: args.plant));
    },
    PerformanceRoute.name: (routeData) {
      final args = routeData.argsAs<PerformanceRouteArgs>();
      return _i5.MaterialPageX<dynamic>(
          routeData: routeData,
          child: _i4.Performance(
              key: args.key, indexSelect: args.indexSelect, plant: args.plant));
    }
  };

  @override
  List<_i5.RouteConfig> get routes => [
        _i5.RouteConfig(LoginRoute.name, path: '/Login'),
        _i5.RouteConfig(ChooseProfileRoute.name, path: '/choose-profile'),
        _i5.RouteConfig(PreventiveRoute.name,
            path: '/Preventive', guards: [authGuard]),
        _i5.RouteConfig(PerformanceRoute.name,
            path: '/Performance', guards: [authGuard])
      ];
}

/// generated route for
/// [_i1.Login]
class LoginRoute extends _i5.PageRouteInfo<void> {
  const LoginRoute() : super(LoginRoute.name, path: '/Login');

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i2.ChooseProfile]
class ChooseProfileRoute extends _i5.PageRouteInfo<void> {
  const ChooseProfileRoute()
      : super(ChooseProfileRoute.name, path: '/choose-profile');

  static const String name = 'ChooseProfileRoute';
}

/// generated route for
/// [_i3.Preventive]
class PreventiveRoute extends _i5.PageRouteInfo<PreventiveRouteArgs> {
  PreventiveRoute(
      {_i6.Key? key,
      required _i8.IndexSelect indexSelect,
      required String plant})
      : super(PreventiveRoute.name,
            path: '/Preventive',
            args: PreventiveRouteArgs(
                key: key, indexSelect: indexSelect, plant: plant));

  static const String name = 'PreventiveRoute';
}

class PreventiveRouteArgs {
  const PreventiveRouteArgs(
      {this.key, required this.indexSelect, required this.plant});

  final _i6.Key? key;

  final _i8.IndexSelect indexSelect;

  final String plant;

  @override
  String toString() {
    return 'PreventiveRouteArgs{key: $key, indexSelect: $indexSelect, plant: $plant}';
  }
}

/// generated route for
/// [_i4.Performance]
class PerformanceRoute extends _i5.PageRouteInfo<PerformanceRouteArgs> {
  PerformanceRoute(
      {_i6.Key? key,
      required _i8.IndexSelect indexSelect,
      required String plant})
      : super(PerformanceRoute.name,
            path: '/Performance',
            args: PerformanceRouteArgs(
                key: key, indexSelect: indexSelect, plant: plant));

  static const String name = 'PerformanceRoute';
}

class PerformanceRouteArgs {
  const PerformanceRouteArgs(
      {this.key, required this.indexSelect, required this.plant});

  final _i6.Key? key;

  final _i8.IndexSelect indexSelect;

  final String plant;

  @override
  String toString() {
    return 'PerformanceRouteArgs{key: $key, indexSelect: $indexSelect, plant: $plant}';
  }
}
