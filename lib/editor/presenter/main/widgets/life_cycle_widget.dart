import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:psws_storage/app/app_bloc/app_bloc.dart';
import 'package:psws_storage/app/di/di.dart';
import 'package:psws_storage/app/domain/entity/environment.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/res/resources.dart';

class LifeCycleWidget extends StatefulWidget {
  final RouteData routeData;
  final Widget child;

  const LifeCycleWidget({
    Key? key,
    required this.routeData,
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
                AppIcons.icLock,
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
    final environment = getIt.get<AppBloc>().state;
    if (environment.hideScreen == HideScreen.no) {
      return;
    }
    final routeData = context.router.current;
    if (widget.routeData.hashCode == routeData.hashCode) {
      if (state == AppLifecycleState.inactive) {
        setState(() {
          showApp = false;
        });
      }
      if (state == AppLifecycleState.resumed) {
        if (PinRoute.name != routeData.name) {
          if (!showApp) {
            context.router.push(PinRoute(isFirstPage: false));
          }
        }
        setState(() {
          showApp = true;
        });
      }
    }
  }
}
