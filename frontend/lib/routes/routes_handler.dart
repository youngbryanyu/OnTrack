/* Route handler to determine which page to show */
import 'package:flutter/material.dart';
import 'package:frontend/pages/core/root_page_wrapper.dart';
import 'package:frontend/pages/auth/login_page.dart';
import 'package:frontend/pages/auth/register_page.dart';
import 'package:frontend/pages/home/home_page.dart';
import 'package:frontend/routes/routes.dart';

/* Generates the page route based on the route settings */
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.authWrapper:
      return getPageRoute(
        routeName: settings.name!,
        screen: const RootPageWrapper(),
      );
    case Routes.login:
      return getPageRoute(
        routeName: settings.name!,
        screen: const LoginPage(),
      );
    case Routes.register:
      return getPageRoute(
        routeName: settings.name!,
        screen: const RegisterPage(),
      );
    case Routes.home:
      return getPageRoute(
        routeName: settings.name!,
        screen: HomePage(),
      );
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('No Route defined for ${settings.name}'),
          ),
        ),
      );
  }
}

/* Gets a page depending on the route and uses the animation to transition */
PageRoute getPageRoute({
  required String routeName,
  required Widget screen,
  PageTransitionType? type,
}) {
  return PageTransition(
    child: screen,
    type: type ?? PageTransitionType.none,
  );
}

/* Types of page transitions */
enum PageTransitionType {
  none,
  fade,
  rightToLeft,
  leftToRight,
  upToDown,
  downToUp,
  scale,
  rotate,
  size,
  rightToLeftWithFade,
  leftToRightWithFade,
}

/* The page transition to use for switching pages */
class PageTransition extends PageRouteBuilder {
  final Widget child;
  final PageTransitionType type;
  final Curve curve;
  final Alignment alignment;
  final Duration duration;

  PageTransition({
    required this.child,
    this.type = PageTransitionType.rightToLeft,
    this.curve = Curves.linear,
    this.alignment = Alignment.center,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return child;
          },
          transitionDuration: duration,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            switch (type) {
              case PageTransitionType.none:
                return child; // No animation, return the child directly
              case PageTransitionType.fade:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              case PageTransitionType.rightToLeft:
                return SlideTransition(
                  transformHitTests: false,
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(-1.0, 0.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case PageTransitionType.downToUp:
                return SlideTransition(
                  transformHitTests: false,
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 1.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(0.0, -1.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );

              case PageTransitionType.rightToLeftWithFade:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: Offset.zero,
                        end: const Offset(-1.0, 0.0),
                      ).animate(secondaryAnimation),
                      child: child,
                    ),
                  ),
                );

              default:
                return child; // default no animation
            }
          },
        );
}
