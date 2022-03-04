import 'dart:convert';
import 'dart:io';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/save_model.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/change_user.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:permission_handler/permission_handler.dart';

enum Backup {
  // ignore: constant_identifier_names
  SAVE_BACKUP,
  // ignore: constant_identifier_names
  GET_BACKUP
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController =
      TextEditingController(text: bloc.user!.name);
  TextEditingController priceLimit =
      TextEditingController(text: (bloc.user!.expensesLimit ?? "").toString());

  bool isUpdate = false;

  FocusNode nameFocus = FocusNode();
  FocusNode priceFocus = FocusNode();
  bool isDark = bloc.themeMode == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Const.buildContent("Profilim", textSize: 17),
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            ThemeSwitcher(
              builder: (ctx) {
                return StatefulBuilder(
                  builder: (context, state) {
                    return AnimatedSwitcher(
                      duration: const Duration(
                        milliseconds: 300,
                      ),
                      transitionBuilder: (c, anim) {
                        return ScaleTransition(
                          scale: anim,
                          child: c,
                        );
                      },
                      child: getThemeIconButton(ctx, isDark, pressed: (s) {
                        state(() {
                          isDark = s == ThemeMode.dark;
                        });
                      }),
                    );
                  },
                );
              },
            ),
            // ThemeSwitcher(
            //   clipper: const ThemeSwitcherCircleClipper(),
            //   builder: (ctx) {
            //     return Center(
            //       child: StreamBuilder<ThemeMode>(
            //           stream: bloc.theme,
            //           initialData: bloc.themeMode,
            //           builder: (context, tema) {
            //             bool theme = tema.data == ThemeMode.dark;
            //             return Transform.scale(
            //               scale: 0.7,
            //               child: CupertinoSwitch(
            //                 value: theme,
            //                 trackColor: black,
            //                 activeColor: black,
            //                 thumbColor: white,
            //                 onChanged: (s) async {
            //                   bloc.themeMode =
            //                       s ? ThemeMode.dark : ThemeMode.light;
            //                   await Future.delayed(
            //                       const Duration(milliseconds: 60));
            //                   ThemeSwitcher.of(ctx).changeTheme(
            //                     theme: s ? dark : light,
            //                   );
            //                 },
            //               ),
            //             );
            //           }),
            //     );
            //   },
            // ),
            PopupMenuButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              itemBuilder: (c) {
                return const [
                  PopupMenuItem(
                    child: Text("Yedekle"),
                    value: Backup.SAVE_BACKUP,
                  ),
                  PopupMenuItem(
                    child: Text("Yükle"),
                    value: Backup.GET_BACKUP,
                  ),
                ];
              },
              onSelected: onSelected,
            ),
          ],
        ),
        body: getBody(),
      ),
    );
  }

  IconButton getThemeIconButton(BuildContext ctx, bool isDark,
      {ValueChanged<ThemeMode>? pressed}) {
    if (isDark) {
      return IconButton(
        key:const ValueKey("dark"),
        onPressed: () async {
          if (pressed != null) {
            pressed(ThemeMode.light);
          }
          Future.delayed(const Duration(milliseconds: 300), () {
            bloc.themeMode = ThemeMode.light;
            ThemeSwitcher.of(ctx).changeTheme(
              theme: light,
            );
          });
        },
        icon: const Icon(Icons.brightness_7),
      );
    } else {
      return IconButton(
        key:const ValueKey("light"),
        onPressed: () {
          if (pressed != null) {
            pressed(ThemeMode.dark);
          }
          Future.delayed(const Duration(milliseconds: 300), () {
            bloc.themeMode = ThemeMode.dark;
            ThemeSwitcher.of(ctx).changeTheme(
              theme: dark,
            );
          });
        },
        icon: const Icon(Icons.mode_night_rounded),
      );
    }
  }

  Widget getBody() {
    return StreamBuilder<User?>(
      stream: bloc.userStream,
      initialData: bloc.user,
      builder: (context, userSnap) {
        User user = userSnap.data!;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Const.primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: user.getImageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Text(
                      "İsim",
                      style: TextStyle(
                        fontSize: 13,
                        color: grey.withOpacity(0.6),
                      ),
                    ),
                    TextField(
                      focusNode: nameFocus,
                      controller: nameController,
                      cursorColor: bloc.isDarkTheme ? white : black,
                      onChanged: (s) {
                        if (s != user.name) {
                          setState(() {
                            isUpdate = true;
                          });
                        } else {
                          double? price = double.tryParse(priceLimit.text);
                          if (user.expensesLimit == price) {
                            setState(() {
                              isUpdate = false;
                            });
                          }
                        }
                      },
                      style: TextStyle(
                        color: bloc.isDarkTheme ? white : black,
                      ),
                      decoration: const InputDecoration(
                        hintText: "İsim",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: grey),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Günlük Harcama Limiti",
                      style:
                          TextStyle(fontSize: 13, color: grey.withOpacity(0.6)),
                    ),
                    TextField(
                      focusNode: priceFocus,
                      controller: priceLimit,
                      keyboardType: TextInputType.number,
                      cursorColor: bloc.isDarkTheme ? white : black,
                      style: TextStyle(
                        color: bloc.isDarkTheme ? white : black,
                      ),
                      onChanged: (s) {
                        double? price = double.tryParse(s);
                        if (price != user.expensesLimit) {
                          setState(() {
                            isUpdate = true;
                          });
                        } else {
                          if (user.name == nameController.text) {
                            setState(() {
                              isUpdate = false;
                            });
                          }
                        }
                      },
                      decoration: InputDecoration(
                        hintText: "Günlük Harcama Limiti",
                        hintStyle: const TextStyle(color: grey),
                        border: InputBorder.none,
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 13),
                          child: Text(
                            "₺",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: bloc.isDarkTheme ? white : black,
                            ),
                          ),
                        ),
                      ),
                    ),
                    30.height,
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      height: isUpdate ? 50 : 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 250),
                        opacity: isUpdate ? 1 : 0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Const.outlinedButton(
                                "Güncelle",
                                onPressed: () {
                                  User newUser = user.copyWith(
                                    name: nameController.text,
                                    expensesLimit:
                                        double.tryParse(priceLimit.text),
                                  );
                                  bloc.updateUser(newUser);
                                  setState(() {
                                    isUpdate = false;
                                  });
                                  nameFocus.unfocus();
                                  priceFocus.unfocus();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.height,
                    Center(
                      child: Const.outlinedButton(
                        "Hesap Değiştir",
                        onPressed: () {
                          context.push(const ChangeUser());
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void onSelected(Backup backup) {
    if (backup == Backup.GET_BACKUP) {
      Const.getBackup();
    } else {
      saveBackup();
    }
  }

  void saveBackup() async {
    List<SaveModel> saveModels = Const.getSaveModels();
    if (saveModels.isEmpty) {
      Const.showMsg("Kayıtlı Veri Yok");
      return;
    }
    if (!(await Permission.storage.isGranted)) {
      if (!(await Permission.storage.request()).isGranted) {
        return;
      }
    }

    FilePicker.platform.getDirectoryPath().then(
      (value) async {
        if (value != null) {
          Map<String, dynamic> map = {
            "saveModels": saveModels.map((e) => e.toJson()).toList(),
          };
          String path = value +
              "/" +
              "(Backup)" +
              DateTime.now().toString().split(" ").first;
          int index = 0;
          while ((await File(path + (index == 0 ? '' : '($index)') + ".txt")
              .exists())) {
            index += 1;
          }
          path += (index == 0 ? '' : '($index)') + ".txt";
          File file = await File(path).create();
          file.writeAsString(jsonEncode(map));
          Const.showMsg("Veriler ${path.split("/").last} Dosyasına Yedeklendi",
              toastLength: Toast.LENGTH_LONG);
        }
      },
    );
  }
}
