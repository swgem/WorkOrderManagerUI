import 'package:flutter/material.dart';

class ResponsivePageUi extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;
  final Widget? mobileFloatingActionButton;
  final Widget? tabletFloatingActionButton;
  final Widget? desktopFloatingActionButton;
  final Widget? mobileDrawer;
  final Widget? tabletDrawer;
  final Widget? desktopDrawer;

  const ResponsivePageUi({
    super.key,
    required this.appBar,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
    this.mobileFloatingActionButton,
    this.tabletFloatingActionButton,
    this.desktopFloatingActionButton,
    this.mobileDrawer,
    this.tabletDrawer,
    this.desktopDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildBody(context),
      floatingActionButton: _buildFloatingActionButton(context),
      drawer: _buildDrawer(context),
    );
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 680;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
      MediaQuery.of(context).size.width >= 680;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1100;

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return appBar;
  }

  Widget _buildBody(BuildContext context) {
    if (isDesktop(context)) {
      if (desktopDrawer != null) {
        return Row(children: [
          SizedBox(
            width: 300,
            child: desktopDrawer,
          ),
          desktopBody,
        ]);
      } else {
        return desktopBody;
      }
    } else if (isTablet(context)) {
      return tabletBody;
    } else /*if (isMobile(context))*/ {
      return mobileBody;
    }
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    if (isDesktop(context)) {
      return desktopFloatingActionButton;
    } else if (isTablet(context)) {
      return tabletFloatingActionButton;
    } else /*if (isMobile(context))*/ {
      return mobileFloatingActionButton;
    }
  }

  Widget? _buildDrawer(BuildContext context) {
    if (isDesktop(context)) {
      return null;
    } else if (isTablet(context)) {
      return tabletDrawer;
    } else /*if (isMobile(context))*/ {
      return mobileDrawer;
    }
  }
}
