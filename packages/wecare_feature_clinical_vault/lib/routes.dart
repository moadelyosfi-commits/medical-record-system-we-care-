import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch recordsBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/records',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Medical Records Placeholder')),
        ),
      ),
    ],
  );
}

StatefulShellBranch encountersBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/encounters',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Encounters Timeline Placeholder')),
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => Scaffold(
              body: Center(
                child: Text('Encounter Detail: ${state.pathParameters["id"]}'),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

StatefulShellBranch medicationsBranch() {
  return StatefulShellBranch(
    routes: [
      GoRoute(
        path: '/medications',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Medications Placeholder')),
        ),
      ),
    ],
  );
}

List<RouteBase> clinicalVaultRootRoutes(
  GlobalKey<NavigatorState> rootNavigatorKey,
) {
  return [
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/investigations',
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Investigations Placeholder')),
      ),
    ),
    GoRoute(
      parentNavigatorKey: rootNavigatorKey,
      path: '/attachments',
      builder: (context, state) =>
          const Scaffold(body: Center(child: Text('Attachments Placeholder'))),
    ),
  ];
}
