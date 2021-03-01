import 'package:flutter/material.dart';
import 'package:stonks/core/responsive.dart';

Widget OpenOrdersCard(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Expanded(
    flex: 2,
    child: Container(
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey,
          spreadRadius: 1,
          blurRadius: 7,
          offset: Offset(0, 5),
        )
      ], borderRadius: BorderRadius.circular(10), color: Colors.white),

      padding: EdgeInsets.only(top: 20, left: 20),
      // color: Colors.grey,
      width: Responsive.isMobile(context) ? size.width : size.width * .3,
      height: Responsive.isMobile(context) ? size.height * .3 : size.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Open Orders',
            style: TextStyle(
              fontSize: 20,
              // fontFamily: 'Phosphate',
            ),
          ),
        ],
      ),
    ),
  );
}
