import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/create_user.dart';
import 'package:follow_of_price/pages/root_app.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Box<List<String>>? usersBox;
Box<String>? datasBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isHaveUser = false;
  if (Platform.isAndroid) {
    String path = (await getApplicationDocumentsDirectory()).path;
    Hive.init(path);
    usersBox = await Hive.openBox("users");
    datasBox = await Hive.openBox("datas");
    List<User> users = ((usersBox!.get("users", defaultValue: [])) ?? [])
        .map((e) => User.fromJson(e))
        .toList();
    if (users.isNotEmpty) {
      String? uid = datasBox!.get("currentUser");
      if (uid != null) {
        int id=int.parse(uid);
        int index= users.indexWhere((element) => element.id==id);
        if(index!=-1){
          bloc.changeUser(users[index]);
        }
      } else {
        bloc.changeUser(users.first);
      }
    }
    isHaveUser = users.isNotEmpty;
  }
  runApp(Main(isHaveUser: isHaveUser));
}

class Main extends StatefulWidget {
  const Main({Key? key, required this.isHaveUser}) : super(key: key);
  final bool isHaveUser;
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    String? theme = datasBox!.get("theme");
    bool isDarkTheme = theme == null
        ? false
        : ThemeMode.values[int.parse(theme)] == ThemeMode.dark;
    ThemeData themeData = isDarkTheme ? dark : light;
    bloc.themeMode = isDarkTheme ? ThemeMode.dark : ThemeMode.light;
    return ThemeProvider(
      initTheme: themeData,
      builder: (c, theme) {
        return MaterialApp(
          title: "Bütçem",
          debugShowCheckedModeBanner: false,
          home: widget.isHaveUser ? const RootApp() : const CreateUser(),
          color: Const.backgroundColor,
          theme: theme,
        );
      },
    );
  }
}

ThemeData light = ThemeData(
  fontFamily: "WorkSans",
  brightness: Brightness.light,
  canvasColor: Const.cardColor,
  scaffoldBackgroundColor: Const.backgroundColor,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: Const.textColor,
    ),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Const.textColor,
      fontWeight: FontWeight.bold,
    ),
  ),
);

ThemeData dark = ThemeData(
  fontFamily: "WorkSans",
  brightness: Brightness.light,
  canvasColor: Const.cardColor,
  scaffoldBackgroundColor: Const.backgroundColor,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle.light,
    backgroundColor: Colors.transparent,
    iconTheme: IconThemeData(
      color: white,
    ),
    elevation: 0,
    titleTextStyle: const TextStyle(
      color: white,
      fontWeight: FontWeight.bold,
    ),
  ),
);
