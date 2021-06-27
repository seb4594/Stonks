import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stonks/Providers/PreferenceProvider.dart';
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
    theme appTheme = Provider.of<Prefrence>(context).globalTheme;
    List themeColors = Provider.of<Prefrence>(context).themeColors;
    Color altDark = Provider.of<Prefrence>(context).altDark;

    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: appTheme == theme.Light ? themeColors[0] : altDark,
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
              Text('STONKS',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Phosphate',
                    color: themeColors[1],
                  )),

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
                color: themeColors[1],
                // onPressed: () => Navigator.of(context).pushNamed('/market'),
                onPressed: () =>
                    Provider.of<ScreenManager>(context, listen: false)
                        .changePage('/dashboard'),
                child: Text(
                  "DashBoard",
                  style: TextStyle(color: themeColors[0]),
                ),
              ),
              // .addNeumorphism(
              //   topShadowColor: Colors.white,
              //   bottomShadowColor: Color(0xFF234395).withOpacity(0.2),
              // ),
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
                color: themeColors[1],
                // onPressed: () => Navigator.of(context).pushNamed('/market'),
                onPressed: () =>
                    Provider.of<ScreenManager>(context, listen: false)
                        .changePage('/marketSearch', false),
                child: Text(
                  "Search Market",
                  style: TextStyle(color: themeColors[0]),
                ),
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
                color: themeColors[1],
                onPressed: () =>
                    Provider.of<ScreenManager>(context, listen: false)
                        .changePage('/marketSearch', true),
                child: Text(
                  "Crypto Market",
                  style: TextStyle(color: themeColors[0]),
                ),
              ),

              SizedBox(height: kDefaultPadding),
              // ignore: deprecated_member_use

              SizedBox(height: kDefaultPadding * 2),
              // Menu Items

              SizedBox(height: kDefaultPadding * 2),

              // ignore: deprecated_member_use
              FlatButton(
                  minWidth: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: themeColors[1],
                  onPressed: () {
                    bool changed = appTheme == theme.Light ? true : false;

                    Provider.of<Prefrence>(context, listen: false)
                        .toggleDarkTheme(changed);
                  },
                  child: Text(
                    'Dark Theme',
                    style: TextStyle(color: themeColors[0]),
                  ))

              // Tags
            ],
          ),
        ),
      ),
    );
  }
}
