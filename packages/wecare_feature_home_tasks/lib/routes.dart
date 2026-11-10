import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch homeTasksBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Home Dashboard Placeholder')),
        ),
        routes: [
          GoRoute(
            path: 'tasks',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Tasks & Reminders Placeholder')),
            ),
          ),
        ],
      ),
    ],
  );
}
