---
title: "How to implement popUntil in GoRouter 14.1.0"
keywords: [ "go_router"]
author: "Ruben Lopez"
date: "03 July 2025"
readTime: "3 min"
authorImage: https://avatars.githubusercontent.com/u/810004?s=96&v=4
tags: [ "Go Router" ]
layout: blog
---

<DropCap />
GoRouter is the official routing library recommended by the Flutter team. The goal of GoRouter is to make it easier to implement declarative navigation, as stated in the official [docs](https://docs.flutter.dev/ui/navigation#using-the-router). Like us at [Cuballama](https://www.cuballama.com/), many projects that where using imperative navigation (`pop`, `push`, `popUntil`), decided to migrate to GoRouter, in part because of this recommendation. But there was a piece missing, GoRouter does not have a `popUntil` method. There is an open [issue](https://github.com/flutter/flutter/issues/131625) about it, but it is very unlikely that it will ever be implemented because GoRouter is now considered "feature complete."

That’s why in our code we kept using [Navigator.popUntil](https://api.flutter.dev/flutter/widgets/Navigator/popUntil.html) when needed, but starting with GoRouter 14.1.0, it was causing an infinite loop and crashing the app. A lot of people also implemented their own versions of `popUntil`, like the one shown in this [post](https://medium.com/@ngocmanh1609/designing-gorouters-routes-for-popuntil-feature-in-flutter-480d66e4c356), but all of them started failing too, as reported in this [issue](https://github.com/flutter/flutter/issues/148185). Furthermore, the problem only seemed to appear when using GoRouter together with GoRouterBuilder, as stated in this [comment](https://github.com/flutter/flutter/issues/148185#issuecomment-2107491804).

## So, what’s the problem?

In our case, the reason why `popUntil` was causing the infinite loop was that we were using GoRouterBuilder to generate routes, and the generated code calls a static method in [`route_data.dart`](https://github.com/flutter/packages/blob/e4fd6c0e9f1abf4579b916f667996d66bcc7ce89/packages/go_router/lib/src/route_data.dart#L86) to create `GoRoute` objects with a non-null `onExit` callback.

```dart
  /// A helper function used by generated code.
  ///
  /// Should not be used directly.
  static GoRoute $route<T extends GoRouteData>({
    required String path,
    String? name,
    required T Function(GoRouterState) factory,
    GlobalKey<NavigatorState>? parentNavigatorKey,
    List<RouteBase> routes = const <RouteBase>[],
  }) {
     ...

    FutureOr<bool> onExit(BuildContext context, GoRouterState state) =>
        factoryImpl(state).onExit(context, state);

    return GoRoute(
      path: path,
      name: name,
      builder: builder,
      pageBuilder: pageBuilder,
      redirect: redirect,
      routes: routes,
      parentNavigatorKey: parentNavigatorKey,
      onExit: onExit, // THIS LINE WAS ADDED 
    );
  }
```

This prevents [`_completeRouteMatch`](https://github.com/flutter/packages/blob/e4fd6c0e9f1abf4579b916f667996d66bcc7ce89/packages/go_router/lib/src/delegate.dart#L175) from being called immediately in [`_handlePopPageWithRouteMatch`](https://github.com/flutter/packages/blob/e4fd6c0e9f1abf4579b916f667996d66bcc7ce89/packages/go_router/lib/src/delegate.dart#L138). The next call to `pop` in the [NavigatorState.popUntil](https://api.flutter.dev/flutter/widgets/NavigatorState/popUntil.html) implementation occurs before the scheduled microtask runs, when the route is not popped yet, causing an infinite loop.

```dart
  bool _handlePopPageWithRouteMatch(
      Route<Object?> route, Object? result, RouteMatchBase match) {
    ...
    final RouteBase routeBase = match.route;
    if (routeBase is! GoRoute || routeBase.onExit == null) { // onExit IS NEVER NULL
      route.didPop(result);
      _completeRouteMatch(result, match); // THIS WILL NEVER BE CALLED
      return true;
    }
    // The _handlePopPageWithRouteMatch is called during draw frame, schedule
    // a microtask in case the onExit callback want to launch dialog or other
    // navigator operations.
    scheduleMicrotask(() async {
      ...
    });
  }
```

The same problem occurs in all the custom implementations of `popUntil` that rely on a `pop` call.

## And what’s the solution?

The simplest way I found to implement `popUntil` correctly without using any `pop` invocations is to use [RouteMatchBase.remove](https://pub.dev/documentation/go_router/latest/go_router/RouteMatchList/remove.html) to "pop" the routes (except the very first one), and then call [GoRouterDelegate.setNewRoutePath](https://pub.dev/documentation/go_router/latest/go_router/GoRouterDelegate/setNewRoutePath.html) to set the new routes list.

```dart
extension ContextExtension on BuildContext {
  void popUntil(bool Function(GoRoute route) predicate) {
    final delegate = GoRouter.of(this).routerDelegate;
    var config = delegate.currentConfiguration;
    while (!predicate(config.last.route) && config.routes.length > 1) {
      config = config.remove(config.last);
    }
    delegate.setNewRoutePath(config);
  }
}
```

I implemented a full example in this [repo](https://github.com/rubenlop88/go_router_pop_until_example).

## Conclusion

GoRouter was not built specifically to do imperative navigation, but in legacy code that only supports Android and iOS, sometimes it is necessary to use `popUntil`. For those cases the usual implementations that use `pop` under the hood do not work after upgrading to GoRouter 14.1.0. Fortunately, we were able to find a solution that works for us. I hope it can work for you too.

