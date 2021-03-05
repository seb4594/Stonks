import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import 'package:stonks/Providers/PortfolioAction.dart';
import 'package:stonks/Providers/senator.dart';

import 'package:stonks/components/Dashboard/OpenPostions.dart';
import 'package:stonks/components/Dashboard/openOrders.dart';
import 'package:stonks/components/Dashboard/senatorHolds.dart';
import 'package:stonks/components/Dashboard/statsMenu.dart';
import 'package:stonks/core/constants.dart';
import 'package:stonks/core/responsive.dart';
import 'package:stonks/core/widgets/side_menu.dart';

// import '../extensions.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Provider.of<PortfolioAction>(context, listen: false).fetchPortfolio().then(
        (_) => Provider.of<PortfolioAction>(context, listen: false)
            .getLiveData()
            .then((value) =>
                Provider.of<PortfolioAction>(context, listen: false)
                    .fetchSenatorData()));

    // Provider.of<PortfolioAction>(context, listen: false).newPortfolio();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final portfolio = Provider.of<PortfolioAction>(context).activePorfolio;
    final stocks = Provider.of<PortfolioAction>(context).currentStocks;
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 250), child: SideMenu()),
      body: Container(
        padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
        color: kBgDarkColor,
        width: double.infinity,
        height: size.height,
        // padding: EdgeInsets.only(top: 20),
        child: SafeArea(
          // top: false,
          child: Responsive.isMobile(context)
              ? SingleChildScrollView(
                  child: Container(
                    height: size.height,
                    child: Column(children: [
                      StatsMenu(context, portfolio, stocks, _scaffoldKey),
                      // OpenOrdersCard(context),
                      SenatorHolds(),
                      openPositionsCard(context, stocks),
                    ]),
                  ),
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                StatsMenu(
                                    context, portfolio, stocks, _scaffoldKey),
                                OpenOrdersCard(context)
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                OpenOrdersCard(context),
                                SenatorHolds(),
                                // OpenOrdersCard(context),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [openPositionsCard(context, stocks)],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
