import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/pages/expense_salary_detail.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/chart.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:follow_of_price/widget/month_picker_widget.dart';
import 'package:follow_of_price/widget/total_price.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late DateTime initialTime;

  @override
  void initState() {
    var now = DateTime.now();
    initialTime = DateTime(now.year, now.month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bloc.isDarkTheme ? black : white,
        title: Const.buildContent("Durumum", textSize: 17),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.donut_small_outlined,color: bloc.isDarkTheme ? white : black,),
          ),
        ],
      ),
      backgroundColor: Colors.transparent,
      body: getBody(),
    );
  }

  Widget getBody() {
    return BackgroundWidget(
      child: Column(
        children: [
          MonthPickerWidget(
            initialTime: initialTime,
            onChanged: (s) {
              setState(() {
                initialTime = s;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        color: bloc.isDarkTheme
                            ? Const.backgroundColor
                            : white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: grey.withOpacity(0.5),
                            blurRadius: 8,
                            // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Net Bakiye",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 13,
                                        color: Color(0xff67727d)),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TotalPrice(
                                    textSize: 20,
                                    month: initialTime,
                                    type: TotalType.total,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 8,
                              left: 8,
                              child: SizedBox(
                                width: (context.width - 20),
                                height: 150,
                                child: StreamBuilder(
                                    stream: bloc.pricesStream,
                                    builder: (context, snapshot) {
                                      return Chart(month: initialTime);
                                    }),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              width: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: bloc.isDarkTheme
                                            ? white
                                            : Const.primaryColor,
                                      ),
                                      4.width,
                                      Const.buildTitle("Gelir (₺)"),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        color: primary,
                                      ),
                                      4.width,
                                      Const.buildTitle("Gider (₺)"),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 20,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: bloc.isDarkTheme
                              ? Const.backgroundColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(.5),
                              blurRadius: 8,
                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: RawMaterialButton(
                          onPressed: () {
                            context.push(ExpenseSalaryDetails(
                              month: initialTime,
                            ));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          splashColor: green,
                          fillColor:
                              bloc.isDarkTheme ? Const.backgroundColor : white,
                          elevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          child: buildTotalPrice(
                            width: (context.width - 60) / 2,
                            icon: Icons.upload_rounded,
                            isExpenses: false,
                            color: Colors.green,
                            label: "Toplam Gelir",
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: bloc.isDarkTheme
                              ? Const.backgroundColor
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: grey.withOpacity(.5),
                              blurRadius: 8,
                              // changes position of shadow
                            ),
                          ],
                        ),
                        child: RawMaterialButton(
                          onPressed: () {
                            context.push(ExpenseSalaryDetails(
                              month: initialTime,
                              isExpenses: true,
                            ));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          splashColor: red,
                          fillColor:
                              bloc.isDarkTheme ? Const.backgroundColor : white,
                          elevation: 0,
                          focusElevation: 0,
                          hoverElevation: 0,
                          highlightElevation: 0,
                          child: buildTotalPrice(
                            width: (context.width - 60) / 2,
                            icon: Icons.download_rounded,
                            isExpenses: true,
                            color: Colors.red,
                            label: "Toplam Gider",
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildTotalPrice({
    required IconData icon,
    required Color color,
    required String label,
    required bool isExpenses,
    double? width,
  }) {
    return SizedBox(
      width: width,
      height: 170,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: white,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: Color(0xff67727d)),
                ),
                const SizedBox(
                  height: 8,
                ),
                TotalPrice(
                  month: initialTime,
                  type: isExpenses ? TotalType.expenses : TotalType.salary,
                  textSize: 20,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
