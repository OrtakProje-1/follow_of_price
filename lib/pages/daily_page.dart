import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/user_avatar.dart';
import 'package:follow_of_price/widget/weekly_date_picker.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({Key? key}) : super(key: key);

  @override
  _DailyPageState createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  int activeDay = 3;
  DateTime initialDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: StreamBuilder<User?>(
            stream: bloc.userStream,
            initialData: bloc.user,
            builder: (context, userSnap) {
              User user = userSnap.data!;
              return Const.buildContent("Hoş Geldin, ${user.name}!",
                  textSize: 17);
            }),
        backgroundColor: bloc.isDarkTheme ? black : white,
        actions: const [
          UserAvatar(),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return BackgroundWidget(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              bottom: 4,
              right: 8,
              left: 8,
            ),
            decoration: BoxDecoration(
              color: bloc.isDarkTheme ? black : white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 4,
                  color: grey.withOpacity(0.5),
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
            ),
            child: StreamBuilder<User?>(
                stream: bloc.userStream,
                initialData: bloc.user,
                builder: (context, userSnap) {
                  User user = userSnap.data!;
                  return StreamBuilder(
                      stream: bloc.pricesStream,
                      initialData: bloc.prices,
                      builder: (context, snapshot) {
                        return WeeklyDatePicker(
                          backgroundColor: Colors.transparent,
                          selectedBackgroundColor:
                              bloc.isDarkTheme ? white : Const.primaryColor,
                          digitsColor:
                              bloc.isDarkTheme ? white.withOpacity(0.6) : black,
                          selectedDigitColor: bloc.isDarkTheme ? black : white,
                          weekdayTextColor:
                              bloc.isDarkTheme ? white.withOpacity(0.6) : black,
                          weekdays: Const.days,
                          enableWeeknumberText: false,
                          selectedDay: initialDate,
                          progress: (s) {
                            if (user.expensesLimit == null) return 0;
                            double expensesPrice = 0;
                            bloc.getPricesFromDay(s).forEach((e) {
                              if (e.isExpense) {
                                expensesPrice += e.amount;
                              }
                            });
                            return expensesPrice / user.expensesLimit!;
                          },
                          changeDay: (s) {
                            setState(() {
                              initialDate = s;
                            });
                          },
                        );
                      });
                }),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  12.height,
                  StreamBuilder<List<Price>>(
                      stream: bloc.pricesStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: bloc.getPricesFromDay(initialDate).isEmpty
                              ? SizedBox(
                                  height: context.height * 0.65,
                                  child: Center(
                                    child: Const.buildContent(
                                        Const.getTimeText(initialDate,
                                                isTodayString: false) +
                                            " Tarihinde Hiç Veri Yok!!!",
                                        overflow: TextOverflow.visible,
                                        textAlign: TextAlign.center),
                                  ),
                                )
                              : Column(
                                  children: bloc
                                      .getPricesFromDay(initialDate)
                                      .map((e) {
                                    return Const.buildLatestWidget(e);
                                  }).toList(),
                                ),
                        );
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color getCardColor(int index) {
    return index % 2 == 1 ? white.withOpacity(1) : black.withOpacity(0.8);
  }
}
