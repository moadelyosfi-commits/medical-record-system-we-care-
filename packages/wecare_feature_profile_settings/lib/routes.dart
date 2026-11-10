import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch settingsBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/settings',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('Settings Placeholder'))),
        routes: [
          GoRoute(
            path: 'profile',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Patient Profile Placeholder')),
            ),
          ),
        ],
      ),
    ],
  );
}
