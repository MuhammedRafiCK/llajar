import 'package:flutter/material.dart';
import 'package:llajar/src/utils/responsive.dart';
import 'package:llajar/src/view/home/responsive_views/desktop_view.dart';
import 'package:llajar/src/view/home/responsive_views/mobile_view.dart';
import 'package:llajar/src/view/home/responsive_views/tab_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive.builder(
      context: context,
      mobile: const HomeMobileView(),
      tablet: const HomeTabletView(),
      desktop: const HomeDesktopView(),
    );
  }
}
