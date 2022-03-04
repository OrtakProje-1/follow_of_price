import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/root_app.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';

class CreateUser extends StatefulWidget {
  final bool isProfile;
  const CreateUser({Key? key,this.isProfile=false}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  Genre genre = Genre.male;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceLimit = TextEditingController();
  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.isProfile;
      },
      child: BackgroundWidget(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            title: Const.buildContent("Yeni Hesap Oluştur", textSize: 17),
            leading:!widget.isProfile ? null : IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace_rounded,
              color: bloc.isDarkTheme ? white : black,
            ),
          ),
            actions: [
             if(!widget.isProfile) IconButton(
                onPressed: () async {
                  bool result= await Const.getBackup();
                  if(result){
                    List<User> users=Const.getUsers();
                    if(users.isNotEmpty){
                      bloc.changeUser(users.first);
                      context.pushReplacement(const RootApp());
                    }
                  }
                },
                icon: const Icon(
                  Icons.settings_backup_restore_rounded,
                ),
              ),
            ],
          ),
          body: getBody(),
        ),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Const.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/male.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Const.primaryColor.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/female.png"),
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
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Const.buildContent(
                  "Erkek",
                  color: genre == Genre.male
                      ? bloc.isDarkTheme
                          ? white
                          : black
                      : grey.withOpacity(0.5),
                ),
                Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                      trackColor: grey,
                      activeColor: grey,
                      value: genre == Genre.female,
                      onChanged: (s) {
                        bool isMale = !s;
                        setState(() {
                          genre = isMale ? Genre.male : Genre.female;
                        });
                        pageController.animateToPage(
                          isMale ? 0 : 1,
                          duration: const Duration(milliseconds: 450),
                          curve: Curves.linear,
                        );
                      }),
                ),
                Const.buildContent(
                  "Kadın",
                  color: genre == Genre.female
                      ? bloc.isDarkTheme
                          ? white
                          : black
                      : grey.withOpacity(0.5),
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
                  height: 10,
                ),
                Text(
                  "İsim",
                  style: TextStyle(
                    fontSize: 13,
                    color: grey.withOpacity(0.6),
                  ),
                ),
                TextField(
                  controller: nameController,
                  cursorColor: bloc.isDarkTheme ? white : black,
                  onChanged: (s) {
                    setState(() {});
                  },
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
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
                    fontSize: 13,
                    color: grey.withOpacity(0.6),
                  ),
                ),
                TextField(
                  controller: priceLimit,
                  keyboardType: TextInputType.number,
                  cursorColor: bloc.isDarkTheme ? white : black,
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: bloc.isDarkTheme ? white : black,
                  ),
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
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const StadiumBorder(),
                          elevation: 0,
                          primary: Const.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: BorderSide(
                            color: Const.primaryColor,
                          ),
                        ),
                        onPressed: nameController.text.isEmpty
                            ? null
                            : () {
                                User user = User(
                                  imagePath: "",
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  name: nameController.text,
                                  genre: genre,
                                  expensesLimit:
                                      double.tryParse(priceLimit.text),
                                );
                                List<User> users = Const.getUsers();
                                if (!users.any((element) => element == user)) {
                                  users.add(user);
                                  usersBox!.put("users",
                                      users.map((e) => e.toJson()).toList());
                                  bloc.changeUser(user);
                                  context.push(const RootApp());
                                }
                              },
                        child: Text(
                          "Kaydet",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Const.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
