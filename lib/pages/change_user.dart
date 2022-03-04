import 'package:flutter/material.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/create_user.dart';
import 'package:follow_of_price/pages/root_app.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:hive/hive.dart';

class ChangeUser extends StatefulWidget {
  const ChangeUser({Key? key}) : super(key: key);

  @override
  State<ChangeUser> createState() => _ChangeUserState();
}

class _ChangeUserState extends State<ChangeUser> {
  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace_rounded,
              color: bloc.isDarkTheme ? white : black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                context.push(const CreateUser(isProfile: true,));
                bloc.setIndex(0);
              },
              icon: Icon(
                Icons.person_add_alt_rounded,
                color: bloc.isDarkTheme ? white : black,
              ),
            ),
          ],
          title: Const.buildContent("Hesaplarım",textSize: 17),
        ),
        body: StreamBuilder<BoxEvent>(
          stream: usersBox!.watch(),
          builder: (context, snapshot) {
            List<User> users = Const.getUsers();

            if (users.isEmpty) {
              return Center(
                child: Const.buildContent("Kayıtlı Başka Hesap Yok..."),
              );
            }

            return ListView.builder(
              padding:const EdgeInsets.symmetric(vertical: 8),
              itemCount: users.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                User user = users[index];
                bool isMe=user==bloc.user;
                return ListTile(
                  tileColor: isMe ? grey.withOpacity(0.2) : Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  leading: user.image(size: 40, radius: 8, padding: 4),
                  title: Const.buildContent(user.name),
                  subtitle: Const.buildTitle("Kayıt tarihi: " +
                      Const.dateToString(
                          DateTime.fromMillisecondsSinceEpoch(user.id))),
                  trailing:user.expensesLimit!=null ? Const.buildContent(user.expensesLimit!.toStringAsFixed(2)+" ₺") : null,
                  onTap:isMe ? null : () {
                    bloc.changeUser(user);
                    bloc.setIndex(0);
                    context.push(const RootApp());
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
