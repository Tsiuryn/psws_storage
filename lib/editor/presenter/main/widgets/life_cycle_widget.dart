import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/router/app_router.dart';

class LifeCycleWidget extends StatefulWidget {
  final StackRouter router;
  final String currentRouteName;
  final Widget child;

  const LifeCycleWidget({
    Key? key,
    required this.router,
    required this.currentRouteName,
    required this.child,
  }) : super(key: key);

  @override
  State<LifeCycleWidget> createState() => _LifeCycleWidgetState();
}

class _LifeCycleWidgetState extends State<LifeCycleWidget>
    with WidgetsBindingObserver {
  bool showApp = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Visibility(
          visible: !showApp,
          child: Container(
            key: const Key('Close page'),
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).unselectedWidgetColor,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/lock.svg',
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final String routeName = context.router.current.name;
    if (widget.currentRouteName == routeName) {
      if (state == AppLifecycleState.inactive) {
        setState(() {
          showApp = false;
        });
      }
      if (state == AppLifecycleState.resumed) {
        if (PinRoute.name != routeName) {
          if (!showApp) {
            widget.router.push(PinRoute(isFirstPage: false));
          }
        }
        setState(() {
          showApp = true;
        });
      }
    }
  }
}
