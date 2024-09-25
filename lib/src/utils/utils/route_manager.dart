// ignore_for_file: avoid_dynamic_calls

import 'dart:developer';
import 'package:flutter/material.dart';

extension NavigationService on BuildContext {
  Future<void> pushReplacement(String routeName, {required Object arguments}) async {
    await Navigator.of(this).pushReplacementNamed(routeName, arguments: arguments);
  }

  Future<void> push(Widget page) async {
    await Navigator.of(this).push<MPageRoutes>(MPageRoutes(page));
  }

  Future<void> pop() async {
    Navigator.of(this).pop();
  }

  /// Pop until the route with the specified name is at the top of the navigator.
  /// [routeName] should be with the initial "/"
  Future<void> popUntil(String routeName) async {
    Navigator.of(this).popUntil((route) => route.settings.name == routeName);
  }

  /// Clear all stack and push the page
  Future<void> pushAndRemoveUntil(Widget page) async {
    await Navigator.of(this).pushAndRemoveUntil(MPageRoutes(page), (route) => false);
  }
}

class MPageRoutes<T> extends PageRoute<T> with MaterialRouteTransitionMixin<T> {
  @override
  final bool maintainState;
  final Widget child;
  MPageRoutes(
    this.child, {
    super.settings,
    super.fullscreenDialog,
    super.allowSnapshotting,
    super.barrierDismissible,
    this.maintainState = true,
  });

  String get name => "/${child.runtimeType}";

  @override
  Widget buildContent(BuildContext context) {
    return child;
  }
}

class RouteHistoryObserver extends NavigatorObserver {
  List<String> routeHistory = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is MPageRoutes) {
      routeHistory.add((route as dynamic).name.toString());
    } else if (route is MaterialPageRoute) {
      routeHistory.add(route.settings.name.toString());
    }
    printRouteHistory();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is MPageRoutes || route is MaterialPageRoute) {
      routeHistory.removeLast();
    }
    printRouteHistory();
  }

  void printRouteHistory() {
    log("Route History: $routeHistory", name: "Navigator");
  }
}
