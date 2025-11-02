import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

//첫 실행인지 위젯~
Future<bool> checkFirstLaunch() async {

  if (kIsWeb) {
    return false;
  }
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

  if (isFirstLaunch) {
    await prefs.setBool('isFirstLaunch', false);
  }

  return isFirstLaunch;
}
Future showNotice(BuildContext context,String content){
  return showDialog(
      context: context,
      builder: (_){
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            constraints: BoxConstraints(maxHeight: 400),
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("공지사항"),
                SizedBox(height: 10,),
                Expanded(child: SingleChildScrollView(
                  child: Text(content),
        )
        )
                ]
          ),
        )
        );
      }
  );
}
