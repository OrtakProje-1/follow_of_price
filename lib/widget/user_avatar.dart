import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 6),
          ],
          color:bloc.isDarkTheme ? Const.backgroundColor : white,
          borderRadius: BorderRadius.circular(6),
        ),
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.only(right: 20),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: bloc.user!.getImageProvider,
            ),
          ),
        ),
      ),
    );
  }
}
