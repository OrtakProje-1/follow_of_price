import 'package:flutter/material.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/month_picker_widget.dart';

class ExpenseSalaryDetails extends StatefulWidget {
  final bool isExpenses;
  final DateTime month;
  const ExpenseSalaryDetails(
      {Key? key, this.isExpenses = false, required this.month})
      : super(key: key);

  @override
  State<ExpenseSalaryDetails> createState() => _ExpenseSalaryDetailsState();
}

class _ExpenseSalaryDetailsState extends State<ExpenseSalaryDetails> {
  late DateTime month;
  bool get isExpenses => widget.isExpenses;

  @override
  void initState() {
    month = widget.month;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_backspace_rounded,color:bloc.isDarkTheme ? white : black,)),
        title: Const.buildContent(widget.isExpenses ? "Gider" : "Gelir"),
        backgroundColor: bloc.isDarkTheme ? black : white,
      ),
      body: BackgroundWidget(
        child: Column(
          children: [
            MonthPickerWidget(
              initialTime: widget.month,
              onChanged: (d) {
                setState(() {
                  month = d;
                });
              },
            ),
            Expanded(
              child: StreamBuilder<List<Price>>(
                  stream: bloc.pricesStream,
                  initialData: bloc.prices,
                  builder: (context, snapshot) {
                    List<Price> allPrices = bloc.getPricesFromMonth(month);
                    List<Price> prices = allPrices
                        .where((a) => a.isExpense == isExpenses)
                        .toList();

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.height,
                            Container(
                              padding: const EdgeInsets.all(8),
                              height: 120,
                              width: double.maxFinite,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: getColor,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: getColor,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 8,
                                    child: Image.asset(
                                      "assets/images/nakit.png",
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Const.buildTitle(
                                              Const.months[month.month - 1],
                                              color: white.withOpacity(0.7)),
                                          4.height,
                                          Row(
                                            children: [
                                              Const.buildContent(
                                                "Toplam: ",
                                                color: white.withOpacity(0.8),
                                                textSize: 18,
                                              ),
                                              Const.buildContent(
                                                "₺" +
                                                    totalAmount(
                                                      prices,
                                                    ),
                                                color: white,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Container(
                                        height: 3,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            colors: [
                                              white,
                                              white.withOpacity(0.1),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            if (prices.isNotEmpty) ...[
                              20.height,
                              Const.buildTitle(Const.months[month.month - 1] +
                                  " ayındaki işlemler"),
                              20.height,
                              Column(
                                children: prices
                                    .map((e) => Const.buildLatestWidget(e,context))
                                    .toList(),
                              ),
                            ],
                            if (prices.isEmpty) ...[
                              SizedBox(
                                height: context.height - 280,
                                child: Center(
                                  child: Const.buildContent(
                                      Const.months[month.month - 1] +
                                          " ayında hiç işlem yok!!!"),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  String totalAmount(List<Price> p) {
    double totalAmount = 0;
    for (var s in p) {
      totalAmount += s.amount;
    }
    return totalAmount.toString();
  }

  Color get getColor {
    return isExpenses ? red : green;
  }

  String getString({bool isLow = false}) {
    String text = (isExpenses ? "Gider" : "Gelir");
    return isLow ? text.toLowerCase() : text;
  }
}
