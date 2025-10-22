import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Navigates back if possible, otherwise redirects to the home route.
void popOrGoHome(BuildContext context, {String homeRoute = '/home'}) {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go(homeRoute);
  }
}
