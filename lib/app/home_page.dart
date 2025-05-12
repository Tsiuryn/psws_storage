import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:psws_storage/res/app_localizations.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:psws_storage/app/dimens/app_dim.dart';
import 'package:psws_storage/app/router/app_router.dart';
import 'package:psws_storage/app/theme/app_theme.dart';
import 'package:psws_storage/editor/presenter/main/widgets/life_cycle_widget.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      GButton(
        icon: Icons.format_list_bulleted_rounded,
        text: l10n.home_page_tab__notes,
      ),
      GButton(
        icon: Icons.radar_outlined,
        text: l10n.home_page_tab__habits,
      ),
      GButton(
        icon: Icons.settings_rounded,
        text: l10n.home_page_tab__settings,
      ),
    ];

    return LifeCycleWidget(
      routeData: context.routeData,
      child: AutoTabsRouter(
          routes: const [
            MainRoute(),
            GoalsRoute(),
            SettingsRoute(),
          ],
          builder: (context, child) {
            final tabsRouter = AutoTabsRouter.of(context);

            return Scaffold(
              backgroundColor: context.appColors.bodyColor,
              body: child,
              bottomNavigationBar: ColoredBox(
                color: context.appColors.appBarColor!,
                child: SafeArea(
                  child: GNav(
                    tabs: items,
                    padding: EdgeInsets.all(AppDim.fourteen),
                    backgroundColor: context.appColors.appBarColor!,
                    selectedIndex: tabsRouter.activeIndex,
                    onTabChange: tabsRouter.setActiveIndex,
                    duration: Duration(milliseconds: 500),
                    activeColor: context.appColors.negativeActionColor,
                    color: context.appColors.textColor,
                    gap: 8,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    curve: Curves.easeInCubic,
                  ),
                ),
              ),
            );
          }),
    );
  }
}
