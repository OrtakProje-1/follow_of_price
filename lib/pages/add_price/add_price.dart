import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/payment_method.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/pages/add_price/widgets/add_amount.dart';
import 'package:follow_of_price/pages/add_price/widgets/add_category.dart';
import 'package:follow_of_price/pages/add_price/widgets/add_datetime.dart';
import 'package:follow_of_price/pages/add_price/widgets/add_description.dart';
import 'package:follow_of_price/pages/add_price/widgets/add_paymentmethod.dart';
import 'package:follow_of_price/pages/add_price/widgets/congratulation.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';

class AddPrice extends StatefulWidget {
  final bool isExpenses;
  const AddPrice({Key? key, required this.isExpenses}) : super(key: key);

  @override
  State<AddPrice> createState() => _AddPriceState();
}

class _AddPriceState extends State<AddPrice> {
  bool get isExpenses => widget.isExpenses;

  Category? defaultCategory;
  late List<Category> categories;
  PageController pageController = PageController();
  String description = "";
  double amount = 0;
  DateTime time = DateTime.now();
  PaymentMethod? paymentMethod;

  @override
  void initState() {
    defaultCategory =
        widget.isExpenses ? Const.defaultExpCategory : Const.defaultSalCategory;
    categories = isExpenses ? Const.expensesCategories : Const.salaryCategories;
    categories.sort((a, b) => a.name.compareTo(b.name));
    super.initState();
    pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close_rounded,color: bloc.isDarkTheme ? white : black,)),
          title: Const.buildContent((isExpenses ? "Gider" : "Gelir") + " Ekle"),
        ),
        body: Column(
          children: [
            if (page < 5)
              LinearProgressIndicator(
                backgroundColor:bloc.isDarkTheme ? white.withOpacity(0.1) : Colors.white,
                color: Const.primaryColor,
                value: min(
                  1,
                  0.20 * (page + 1),
                ),
                minHeight: 2,
              ),
            Expanded(
              child: PageView(
                scrollDirection: Axis.horizontal,
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  AddAmount(
                    description: description,
                    isExpenses: isExpenses,
                    nextPagePressed: (s) async {
                      amount = s;
                      await pageController.animateToPage(
                        1,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.linear,
                      );
                    },
                  ),
                  AddDescription(
                      amount: amount,
                      isExpenses: isExpenses,
                      nextPagePressed: (s) async {
                        description = s;
                        await pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.linear,
                        );
                      }),
                  AddCategory(
                      description: description,
                      amount: amount,
                      isExpenses: isExpenses,
                      nextPagePressed: (s) async {
                        defaultCategory = s;
                        await pageController.animateToPage(
                          3,
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.linear,
                        );
                      }),
                  AddDateTime(
                    category: defaultCategory!,
                    description: description,
                    amount: amount,
                    isExpenses: isExpenses,
                    nextPagePressed: (s) async {
                      time = s;
                      await pageController.animateToPage(
                        4,
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.linear,
                      );
                    },
                  ),
                  AddPaymentMethod(
                    time: time,
                    category: defaultCategory!,
                    description: description,
                    amount: amount,
                    isExpenses: isExpenses,
                    finishPage: (s) async {
                      paymentMethod = s;
                      bloc.addPrice(
                        Price(
                          amount: amount,
                          time: time,
                          isExpense: isExpenses,
                          category: defaultCategory!,
                          description: description,
                          paymentMethod:
                              paymentMethod ?? Const.paymentMethods[1],
                        ),
                      );
                      context.push(
                        CongratulationPage(
                          price: Price(
                            amount: amount,
                            time: time,
                            isExpense: isExpenses,
                            category: defaultCategory!,
                            description: description,
                            paymentMethod:
                                paymentMethod ?? Const.paymentMethods[1],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Expanded(
            //   child: ListView(
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     children: [
            //       const CustomTextField(labelText: "Fiyat"),
            //       const CustomTextField(labelText: "Açıklama"),
            //       customButton(
            //         context,
            //         "Kategori:",
            //         secondChild: Row(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           children: [
            //             Const.svg(
            //               defaultCategory.imagePath!,
            //               width: 20,
            //               height: 20,
            //             ),
            //             const SizedBox(
            //               width: 8,
            //             ),
            //             Text(
            //               defaultCategory.name,
            //               style: const TextStyle(fontWeight: FontWeight.bold),
            //             )
            //           ],
            //         ),
            //         onPressed: () async {
            //           Category? category = await showCategorySheet(context);
            //           if (category != null) {
            //             setState(() {
            //               defaultCategory = category;
            //             });
            //           }
            //         },
            //       ),
            //       customButton(context, "Tarih:", secondChild: Text("ALl")),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  int get page {
    if (pageController.positions.isNotEmpty) {
      return (pageController.page ?? 0).toInt();
    } else {
      return 0;
    }
  }

  Padding customButton(BuildContext context, String label,
      {required Widget secondChild, VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          boxShadow: [
            BoxShadow(
                blurRadius: 8,
                color: black.withOpacity(0.06),
                offset: const Offset(0, 4)),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                      color: black.withOpacity(0.4),
                      fontWeight: FontWeight.w600),
                ),
                secondChild
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({Key? key, required this.labelText}) : super(key: key);

  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey.shade100,
      elevation: 8,
      shadowColor: black.withOpacity(0.24),
      child: TextField(
        cursorColor: Const.primaryColor,
        cursorRadius: const Radius.circular(6),
        style: TextStyle(
          color: Const.primaryColor,
          // fontWeight: FontWeight.bold
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(width: 1.5, color: Const.primaryColor),
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            color: black.withOpacity(0.4),
          ),
          floatingLabelStyle: const TextStyle(
            color: black,
          ),
          hintStyle: TextStyle(
              color: Colors.grey.shade600, fontWeight: FontWeight.w100),
        ),
      ),
    );
  }
}
