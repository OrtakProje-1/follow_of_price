import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:follow_of_price/pages/budget_page/budget_page.dart';
import 'package:follow_of_price/pages/create_price_page.dart';
import 'package:follow_of_price/pages/daily_page.dart';
import 'package:follow_of_price/pages/profile_page.dart';
import 'package:follow_of_price/pages/stats_page.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:follow_of_price/util/const.dart';

class RootApp extends StatefulWidget {
  const RootApp({Key? key}) : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      ThemeModelInheritedNotifier.of(context).addListener(() {
        setState(() {});
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeSwitchingArea(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          body: const Body(),
          bottomNavigationBar: getFooter(),
          floatingActionButton: AnimatedBuilder(
            animation: bloc,
            builder: (c, s) {
              Color color = bloc.pageIndex == 4
                  ? bloc.isDarkTheme
                      ? white
                      : Const.primaryColor
                  : bloc.isDarkTheme
                      ? black
                      : Colors.white;
              return FloatingActionButton(
                onPressed: () {
                  selectedTab(4);
                },
                child: Icon(
                  Icons.add,
                  color: bloc.pageIndex == 4
                      ? bloc.isDarkTheme
                          ? black
                          : white
                      : bloc.isDarkTheme
                          ? white.withOpacity(0.4)
                          : Const.primaryColor,
                ),

                elevation: bloc.pageIndex == 4 ? 16 : 0,
                backgroundColor: color,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: bloc.isDarkTheme ? white : Const.primaryColor,
                      width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                //params
              );
            },
          ),
          floatingActionButtonLocation: MyFloatLocation(),
        ),
      ),
    );
  }

  Widget getFooter() {
    List<IconData> iconItems = [
      Icons.calendar_today,
      Icons.bar_chart_rounded,
      Icons.account_balance_wallet_outlined,
      Icons.person,
    ];

    return AnimatedBuilder(
        animation: bloc,
        builder: (c, s) {
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: bloc.isDarkTheme
                      ? Colors.white12
                      : Const.primaryColor.withOpacity(0.15),
                  offset: const Offset(0, -4),
                  blurRadius: 4,
                ),
              ],
              border: Border(
                top: BorderSide(color: Const.primaryColor, width: 1),
              ),
            ),
            child: AnimatedBottomNavigationBar(
              activeColor: bloc.isDarkTheme ? white : Const.primaryColor,
              backgroundColor: bloc.isDarkTheme ? black : white,
              notchMargin: 0,
              elevation: 0,
              splashColor: bloc.isDarkTheme ? white : Const.primaryColor,
              inactiveColor: bloc.isDarkTheme
                  ? white.withOpacity(0.4)
                  : Colors.black.withOpacity(0.3),
              icons: iconItems,
              activeIndex: bloc.pageIndex,
              gapLocation: GapLocation.none,
              notchSmoothness: NotchSmoothness.sharpEdge,
              leftCornerRadius: 0,
              iconSize: 25,
              rightCornerRadius: 0,
              onTap: (index) {
                selectedTab(index);
              },
              //other params
            ),
          );
        });
  }

  selectedTab(index) {
    bloc.setIndex(index);
  }
}

class MyFloatLocation extends FloatingActionButtonLocation {
  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    return Offset(
      (scaffoldGeometry.scaffoldSize.width / 2) -
          (scaffoldGeometry.floatingActionButtonSize.width / 2),
      scaffoldGeometry.scaffoldSize.height -
          (scaffoldGeometry.floatingActionButtonSize.height * 1.25),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  void initState() {
    bloc.addListener(() {
      if (mounted) setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: bloc.pageIndex,
      children: const [
        DailyPage(),
        StatsPage(),
        BudgetPage(),
        ProfilePage(),
        CreatPricePage()
      ],
    );
  }
}
