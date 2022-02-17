import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/payment_method.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class AddPaymentMethod extends StatefulWidget {
  final bool isExpenses;
  final ValueChanged<PaymentMethod> finishPage;
  final double amount;
  final String description;
  final Category category;
  final DateTime time;
  const AddPaymentMethod({
    Key? key,
    required this.isExpenses,
    required this.finishPage,
    required this.amount,
    required this.description,
    required this.category,
    required this.time,
  }) : super(key: key);

  @override
  State<AddPaymentMethod> createState() => _AddPaymentMethodState();
}

class _AddPaymentMethodState extends State<AddPaymentMethod> {
  final TextEditingController description = TextEditingController();
  final FocusNode focusNode = FocusNode();
  PaymentMethod paymentMethod = Const.paymentMethods[1];


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: widget.isExpenses ? red : green,
                    child: Icon(
                      widget.isExpenses
                          ? Icons.download_rounded
                          : Icons.upload_rounded,
                      color: white,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "İşlem Tipi",
                                style: TextStyle(color: grey, fontSize: 12),
                              ),
                              Text(
                                widget.isExpenses ? "Gider" : "Gelir",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: bloc.isDarkTheme ? white : black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Fiyat",
                                style: TextStyle(color: grey, fontSize: 12),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "₺"+widget.amount.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: bloc.isDarkTheme ? white : black,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  DottedBorder(
                    dashPattern: const [3.3, 3.3],
                    borderType: BorderType.Circle,
                    color: Const.primaryColor,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: grey.withOpacity(0.2),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: Const.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Açıklama",
                        style: TextStyle(color: grey, fontSize: 12),
                      ),
                      Text(
                        widget.description,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: bloc.isDarkTheme ? white : black, ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                horizontalTitleGap: 8,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Const.primaryColor.withOpacity(bloc.isDarkTheme ? 0.4 : 0.1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Const.svg(widget.category.imagePath!,
                      width: 25, height: 25),
                ),
                title: const Text(
                  "Kategori",
                  style: TextStyle(color: grey, fontSize: 12),
                ),
                subtitle: Text(
                  widget.category.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: bloc.isDarkTheme ? white : black,
                  ),
                ),
              ),
              ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding: EdgeInsets.zero,
                dense: true,
                horizontalTitleGap: 8,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Const.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.date_range_outlined,
                    color: Const.primaryColor,
                  ),
                ),
                title: const Text(
                  "Tarih",
                  style: TextStyle(color: grey, fontSize: 12),
                ),
                subtitle: Text(
                  Const.getTimeText(widget.time),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: bloc.isDarkTheme ? white : black,
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ödeme Yöntemi",
                          style: TextStyle(color: grey.withOpacity(0.6)),
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 5,
                          onTap: () async {
                            PaymentMethod? paymentMethod =
                                await showModalBottomSheet(
                                    context: context,
                                    backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
                                    builder: (_) {
                                      return SizedBox(
                                        height: 200,
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Container(
                                                margin: const EdgeInsets.all(8),
                                                width: 90,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            22),
                                                    color:
                                                        Colors.grey.shade300),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: Const.paymentMethods
                                                    .map((e) {
                                                  return ListTile(
                                                    dense: true,
                                                    tileColor: e==this.paymentMethod ? Const.cardColor.withOpacity(0.15) : Colors.transparent,
                                                    onTap: () {
                                                      Navigator.pop(context, e);
                                                    },
                                                    title: Text(
                                                      e.name,
                                                      style:  TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: bloc.isDarkTheme ? white : black,
                                                      ),
                                                    ),
                                                    leading: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              6),
                                                      decoration: BoxDecoration(
                                                        color: Const
                                                            .primaryColor
                                                            .withOpacity(0.1),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      child: Const.svg(e.image,
                                                          width: 15,
                                                          height: 15),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                            if (paymentMethod != null) {
                              setState(() {
                                this.paymentMethod = paymentMethod;
                              });
                            }
                          },
                          leading: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Const.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Const.svg(paymentMethod.image,
                                  width: 15, height: 15)),
                          title: Text(
                            paymentMethod.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18,color: bloc.isDarkTheme ? white : black,),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  RawMaterialButton(
                    fillColor:bloc.isDarkTheme ? white : Const.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 40,
                      maxWidth: 40,
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    onPressed: () {
                      widget.finishPage(paymentMethod);
                    },
                    child: Icon(
                      Icons.check_rounded,
                      color: bloc.isDarkTheme ? black : white,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
