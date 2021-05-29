import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/screenManager.dart';
import 'package:window_size/window_size.dart';

import '../constants.dart';
import '../extensions.dart';
import '../responsive.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: kBgLightColor,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Spacer(),
                  // We don't want to show this close button on Desktop mood
                  if (Responsive.isMobile(context)) CloseButton(),
                ],
              ),
              Text(
                'STONKS',
                style: TextStyle(fontSize: 30, fontFamily: 'Phosphate'),
              ),

              SizedBox(height: kDefaultPadding),
              // ignore: deprecated_member_use
              FlatButton(
                minWidth: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                // onPressed: () => Navigator.of(context).pushNamed('/market'),
                onPressed: () =>
                    Provider.of<ScreenManager>(context, listen: false)
                        .changePage('/dashboard'),
                child: Text(
                  "DashBoard",
                  style: TextStyle(color: Colors.white),
                ),
              ).addNeumorphism(
                topShadowColor: Colors.white,
                bottomShadowColor: Color(0xFF234395).withOpacity(0.2),
              ),
              SizedBox(
                height: 15,
              ),
              // ignore: deprecated_member_use
              FlatButton(
                minWidth: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: kDefaultPadding,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                color: kPrimaryColor,
                // onPressed: () => Navigator.of(context).pushNamed('/market'),
                onPressed: () =>
                    Provider.of<ScreenManager>(context, listen: false)
                        .changePage('/marketSearch', false),
                child: Text(
                  "Search Market",
                  style: TextStyle(color: Colors.white),
                ),
              ).addNeumorphism(
                topShadowColor: Colors.white,
                bottomShadowColor: Color(0xFF234395).withOpacity(0.2),
              ),
              SizedBox(
                height: 15,
              ),

              InkWell(
                  onTap: () =>
                      Provider.of<ScreenManager>(context, listen: false)
                          .changePage('/marketSearch', true),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.blue),
                    width: size.width * .14,
                    height: 45,
                    child: Center(
                      child: Text(
                        "Crypto Market",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )),
              SizedBox(height: kDefaultPadding),
              // ignore: deprecated_member_use

              SizedBox(height: kDefaultPadding * 2),
              // Menu Items

              SizedBox(height: kDefaultPadding * 2),
              // Tags
            ],
          ),
        ),
      ),
    );
  }
}
