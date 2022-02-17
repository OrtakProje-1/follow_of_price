import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/change_user.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';

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

  FocusNode nameFocus=FocusNode();
  FocusNode priceFocus=FocusNode();

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
              clipper: const ThemeSwitcherCircleClipper(),
              builder: (ctx) {
                return Center(
                  child: StreamBuilder<ThemeMode>(
                      stream: bloc.theme,
                      initialData: bloc.themeMode,
                      builder: (context, tema) {
                        bool theme = tema.data == ThemeMode.dark;

                        return Transform.scale(
                          scale: 0.7,
                          child: CupertinoSwitch(
                            value: theme,
                            trackColor: black,
                            activeColor: black,
                            thumbColor: white,
                            onChanged: (s) {
                              bloc.themeMode =
                                  s ? ThemeMode.dark : ThemeMode.light;
                              ThemeSwitcher.of(ctx).changeTheme(
                                theme: s ? dark : light,
                              );
                            },
                          ),
                        );
                      }),
                );
              },
            ),
            5.width,
          ],
        ),
        body: getBody(),
      ),
    );
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
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
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
                            // Positioned(
                            //   bottom: -10,
                            //   right: -10,
                            //   child: RawMaterialButton(
                            //     fillColor: Const.backgroundColor,
                            //     constraints: const BoxConstraints(
                            //       maxHeight: 34,
                            //       maxWidth: 34,
                            //       minHeight: 34,
                            //       minWidth: 34,
                            //     ),
                            //     elevation: 0,
                            //     highlightElevation: 0,
                            //     hoverElevation: 0,
                            //     focusElevation: 0,
                            //     shape: const StadiumBorder(),
                            //     onPressed: () {
                            //       showImageSheet();
                            //     },
                            //     child: CircleAvatar(
                            //       radius: 15,
                            //       backgroundColor: Colors.transparent,
                            //       child: Icon(
                            //         Icons.camera,
                            //         color: Const.primaryColor,
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
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
                        style: TextStyle(
                            fontSize: 13, color: grey.withOpacity(0.6)),
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
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                    primary: Const.primaryColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 13),
                                    side: BorderSide(
                                      color: Const.primaryColor,
                                    ),
                                  ),
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
                                  child: Text(
                                    "Güncelle",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Const.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      20.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              elevation: 0,
                              primary: bloc.isDarkTheme ? white : black,
                              shape: const StadiumBorder(),
                            ),
                            onPressed: () {
                              context.push(const ChangeUser());
                            },
                            child: Const.buildContent("Hesap Değiştir"),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  void showImageSheet() {}
}
