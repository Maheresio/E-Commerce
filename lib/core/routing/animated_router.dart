import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Custom page transitions for smooth animated navigation
class PageTransitions {
  static PageRouteBuilder<T> slideRight<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings, // <— CRITICAL
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder<T> slideLeft<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        final tween = Tween(begin: begin, end: Offset.zero)
            .chain( CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder<T> slideUp<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        final tween = Tween(begin: begin, end: Offset.zero)
            .chain( CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder<T> fadeScale<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }

  static PageRouteBuilder<T> heroTransition<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.3);
        final offsetTween =
            Tween(begin: begin, end: Offset.zero).chain( CurveTween(curve: Curves.easeOutCubic));
        final fadeTween =
            Tween<double>(begin: 0, end: 1).chain( CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(offsetTween),
          child: FadeTransition(opacity: animation.drive(fadeTween), child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static PageRouteBuilder<T> checkoutTransition<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        final tween = Tween(begin: begin, end: Offset.zero)
            .chain( CurveTween(curve: Curves.easeInOutQuart));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static PageRouteBuilder<T> searchTransition<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  static PageRouteBuilder<T> profileTransition<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 0.2);
        final offsetTween =
            Tween(begin: begin, end: Offset.zero).chain( CurveTween(curve: Curves.easeOutCubic));
        final fadeTween =
            Tween<double>(begin: 0, end: 1).chain( CurveTween(curve: Curves.easeOut));
        return SlideTransition(
          position: animation.drive(offsetTween),
          child: FadeTransition(opacity: animation.drive(fadeTween), child: child),
        );
      },
      transitionDuration: const Duration(milliseconds: 350),
    );
  }
}

class AnimatedRoute {
  /// Slide right
  static GoRoute slideRight({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.slideRight(child: child, settings: settings),
      ),
    );
  }

  static GoRoute slideUp({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.slideUp(child: child, settings: settings),
      ),
    );
  }

  static GoRoute fadeScale({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.fadeScale(child: child, settings: settings),
      ),
    );
  }

  static GoRoute hero({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.heroTransition(child: child, settings: settings),
      ),
    );
  }

  static GoRoute checkout({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.checkoutTransition(child: child, settings: settings),
      ),
    );
  }

  static GoRoute search({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.searchTransition(child: child, settings: settings),
      ),
    );
  }

  static GoRoute profile({
    required String path,
    required Widget Function(BuildContext, GoRouterState) builder,
  }) {
    return GoRoute(
      path: path,
      pageBuilder: (context, state) => _MyTransitionPage(
        key: state.pageKey,
        name: path,
        child: builder(context, state),
        routeFactory: (child, settings) =>
            PageTransitions.profileTransition(child: child, settings: settings),
      ),
    );
  }
}

/// Renamed to avoid clashing with go_router's CustomTransitionPage
class _MyTransitionPage<T> extends Page<T> {
  const _MyTransitionPage({
    required this.child,
    required this.routeFactory,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  final Widget child;
  final PageRoute<T> Function(Widget child, RouteSettings settings) routeFactory;

  @override
  Route<T> createRoute(BuildContext context) {
    // IMPORTANT: pass `this` as the RouteSettings so route.settings is a Page
    return routeFactory(child, this);
  }
}

