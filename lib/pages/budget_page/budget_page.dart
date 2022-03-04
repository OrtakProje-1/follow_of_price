import 'dart:math';

import 'package:follow_of_price/models/budget.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/pages/budget_page/add_budget.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/month_picker_widget.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  DateTime month = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Const.buildContent("Bütçe", textSize: 17),
        backgroundColor: bloc.isDarkTheme ? black : Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              context.push(const AddBudget());
            },
            icon: Icon(
              Icons.add,
              color: bloc.isDarkTheme ? white : black,
            ),
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return BackgroundWidget(
      child: Column(
        children: [
          MonthPickerWidget(
            initialTime: month,
            onChanged: (s) {
              setState(() {
                month = s;
              });
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    10.height,
                    StreamBuilder<List<Price>>(
                        stream: bloc.pricesStream,
                        initialData: bloc.prices,
                        builder: (context, prices) {
                          return StreamBuilder<List<Budget>>(
                            stream: bloc.budgetsStream,
                            initialData: bloc.budgets,
                            builder: (context, budgets) {
                              if (budgets.data!.isEmpty) {
                                return SizedBox(
                                  height: context.height * 0.6,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Const.buildContent(
                                          "Hiç bütçe yok!!!",
                                        ),
                                      ),
                                      5.height,
                                      Center(
                                        child: Const.buildTitle(
                                          "Yeni bir bütçe eklemek için '+' butonuna tıkla!!!",
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return Column(
                                children: budgets.data!.map((e) {
                                  return buildBudget(e);
                                }).toList(),
                              );
                            },
                          );
                        }),
                    10.height,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBudget(Budget budget) {
    double totalExpense = bloc.getTotalAmountPricesFromBudget(month, budget);
    double different = budget.amount - totalExpense;
    double percentage = (max(0, different / budget.amount) * 100);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
          color: bloc.isDarkTheme ? black : white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: bloc.isDarkTheme
                  ? white.withOpacity(0.15)
                  : black.withOpacity(0.15),
              blurRadius: 16,
              // changes position of shadow
            ),
          ]),
      child: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Const.primaryColor.withOpacity(0.1),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Const.svg(budget.category.imagePath!),
                    ),
                    4.width,
                    Text(
                      budget.category.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: const Color(0xff67727d).withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          different.toStringAsFixed(2) + "₺",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: bloc.isDarkTheme ? white : black,
                          ),
                        ),
                        8.width,
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Text(
                            "%" + percentage.toStringAsFixed(1),
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 13,
                                color:
                                    const Color(0xff67727d).withOpacity(0.6)),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          budget.amount.toStringAsFixed(2) + "₺",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              color: const Color(0xff67727d).withOpacity(0.6)),
                        ),
                      ],
                    ),
                  ],
                ),
                15.height,
                Stack(
                  children: [
                    Container(
                      width: (context.width - 40),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: primary.withOpacity(0.2),
                      ),
                    ),
                    Container(
                      width: (context.width - 40) * (percentage / 100),
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: budget.color,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () {
                Const.showCheckDialog(
                        context, "Bütçeyi silmek istediğine emin misin?")
                    .then((value) {
                  if (value != null) {
                    if (value) {
                      bloc.removeBudget(budget);
                    }
                  }
                });
              },
              icon: Icon(
                Icons.delete_outline,
                color: bloc.isDarkTheme ? white : black,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
