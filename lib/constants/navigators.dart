import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// adds a new entry to the pages stack
void moveToNextScreen(
    {required BuildContext context,
    required PageRouteInfo<dynamic> pageRoute}) {
  context.router.push(pageRoute);
}

// or by using paths
void moveToNextScreenWithRoute(
    {required BuildContext context, required String routePath}) {
  context.router.pushNamed(routePath);
}

// removes last entry in stack and pushes provided route
// if last entry == provided route page will just be updated
void replaceNextScreen(
    {required BuildContext context,
    required PageRouteInfo<dynamic> pageRoute}) {
  context.router.replace(pageRoute);
}

// or by using using paths
void replaceNextScreenWithRoute(
    {required BuildContext context, required String routePath}) {
  context.router.replaceNamed(routePath);
}

// pops until provided route, if it already exists in stack
// else adds it to the stack (good for web Apps).
void navigateNextScreen(
    {required BuildContext context,
    required PageRouteInfo<dynamic> pageRoute}) {
  context.router.navigate(pageRoute);
}

// or by using using paths
void navigateNextScreenWithRoute(
    {required BuildContext context, required String routePath}) {
  context.router.navigateNamed(routePath);
}

// on Web it calls window.history.back();
// on Native it navigates you back
// to the previous location

void backToPreviousScreen({required BuildContext context}) {
  context.router.back();
}

void backToScreen({required BuildContext context}) {
  Navigator.pop(context);
}

void backToScreenWithArg(
    {required BuildContext context, required dynamic result}) {
  Navigator.pop(context, result);
}
