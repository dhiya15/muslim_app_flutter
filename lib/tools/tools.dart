import 'package:flutter/material.dart';
import 'package:permission/permission.dart';

class Tools{

  static Color backColor = Colors.lightBlueAccent;
  static Color textColor = Colors.white;

  static String transformeNumberOfSura(int position){
    String sura = "";
    switch(position.toString().length) {
      case 1:
        sura = "00" + position.toString();
        break;
      case 2:
        sura = "0" + position.toString();
        break;
      case 3:
        sura = position.toString();
        break;
    }
    return sura;
  }

  static updateNext(int next){
    next = next + 1;
    if(next == 115)
      return 114;
    return next;
  }

  static updatePrev(int prev){
    prev = prev - 1;
    if(prev == 0)
      return 1;
    return prev;
  }

  static Future<bool> requestPermissions() async {
    List<PermissionName> permissionNames = [];
    permissionNames.add(PermissionName.Storage);
    var permissions = await Permission.requestPermissions(permissionNames);
    return permissions[0].permissionStatus == PermissionStatus.allow;
  }

  static Widget getScrollWidget(Widget body) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate:
          SliverChildBuilderDelegate((BuildContext context, int index) {
            return body;
          }, childCount: 1),
        ),
      ],
    );
  }

}