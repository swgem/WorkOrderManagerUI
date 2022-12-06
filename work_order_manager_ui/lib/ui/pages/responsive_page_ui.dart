import 'package:flutter/material.dart';
import 'package:work_order_manager_ui/ui/responsive.dart';

class ResponsivePageUi extends StatelessWidget {
  final PreferredSizeWidget mobileAppBar;
  final PreferredSizeWidget tabletAppBar;
  final PreferredSizeWidget desktopAppBar;
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
    required this.mobileAppBar,
    required this.tabletAppBar,
    required this.desktopAppBar,
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    if (Responsive.platform(context) == Platform.desktop) {
      return desktopAppBar;
    } else if (Responsive.platform(context) == Platform.tablet) {
      return tabletAppBar;
    } else /*if (isMobile(context))*/ {
      return mobileAppBar;
    }
  }

  Widget _buildBody(BuildContext context) {
    if (Responsive.platform(context) == Platform.desktop) {
      if (desktopDrawer != null) {
        return Row(children: [
          SizedBox(
            width: 250,
            child: desktopDrawer,
          ),
          Expanded(child: desktopBody),
        ]);
      } else {
        return desktopBody;
      }
    } else if (Responsive.platform(context) == Platform.tablet) {
      return tabletBody;
    } else /*if (isMobile(context))*/ {
      return mobileBody;
    }
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    if (Responsive.platform(context) == Platform.desktop) {
      return desktopFloatingActionButton;
    } else if (Responsive.platform(context) == Platform.tablet) {
      return tabletFloatingActionButton;
    } else /*if (isMobile(context))*/ {
      return mobileFloatingActionButton;
    }
  }

  Widget? _buildDrawer(BuildContext context) {
    if (Responsive.platform(context) == Platform.desktop) {
      return null;
    } else if (Responsive.platform(context) == Platform.tablet) {
      return tabletDrawer;
    } else /*if (isMobile(context))*/ {
      return mobileDrawer;
    }
  }
}
