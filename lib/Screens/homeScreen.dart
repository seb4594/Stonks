import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:stonks/Providers/screenManager.dart';
import 'package:stonks/Screens/marketSearch.dart';
import 'package:stonks/Screens/positionDetailScreen.dart';
import 'package:stonks/components/Dashboard/Dashboard.dart';
import 'package:stonks/core/responsive.dart';
import 'package:stonks/core/widgets/side_menu.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    final pageIndex = Provider.of<ScreenManager>(context).currentPage;

    Widget currentPage() {
      if (pageIndex == '/dashboard') {
        return DashBoard();
      } else if (pageIndex == '/marketSearch') {
        return MarketSearchPage();
      } else if (pageIndex == '/positionDetail') {
        return PositionDetailScreen();
      }
    }

    return Scaffold(
      body: Responsive(
        mobile: currentPage(),
        desktop: Row(
          children: [
            Expanded(
              child: SideMenu(),
              flex: _size.width > 1340 ? 1 : 1,
            ),
            Expanded(
              child: currentPage(),
              flex: _size.width > 1340 ? 5 : 7,
            )
          ],
        ),
        tablet: Row(
          children: [
            // Expanded(
            //   child: SideMenu(),
            //   flex: _size.width > 1340 ? 1 : 2,
            // ),
            Expanded(
              child: currentPage(),
              flex: _size.width > 1340 ? 5 : 7,
            )
          ],
        ),
      ),
    );
  }
}
