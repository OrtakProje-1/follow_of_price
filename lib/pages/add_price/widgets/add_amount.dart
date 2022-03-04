import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class AddAmount extends StatefulWidget {
  final bool isExpenses;
  final String description;
  final ValueChanged<double> nextPagePressed;
  const AddAmount({
    Key? key,
    required this.isExpenses,
    required this.nextPagePressed,
    required this.description,
  }) : super(key: key);

  @override
  State<AddAmount> createState() => _AddAmountState();
}

class _AddAmountState extends State<AddAmount> {
  final TextEditingController amount = TextEditingController();
  final FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
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
                  Column(
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
                ],
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
                          "Fiyat",
                          style: TextStyle(color: grey.withOpacity(0.6)),
                        ),
                        TextField(
                          autofocus: true,
                          focusNode: focusNode,
                          onChanged: (s) {
                            setState(() {});
                          },
                          keyboardType: TextInputType.number,
                          controller: amount,
                          cursorRadius: const Radius.circular(6),
                          cursorColor: Const.primaryColor,
                          style: TextStyle(
                            color: bloc.isDarkTheme ? white : black,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                              // prefixIcon: Padding(
                              //   padding:
                              //       const EdgeInsets.only(top: 13),
                              //   child: Text(
                              //     "₺",
                              //     style: TextStyle(
                              //       fontWeight: FontWeight.bold,
                              //       fontSize: 17,
                              //       color: bloc.isDarkTheme ? white : black,
                              //     ),
                              //   ),
                              // ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  Const.showCalculateSheet(context,
                                          initial:
                                              double.tryParse(amount.text) ?? 0)
                                      .then((value) {
                                    if (value != null) {
                                      amount.text = value.toStringAsFixed(2);
                                      setState(() {});
                                    }
                                  });
                                },
                                icon: Icon(
                                  Icons.calculate,
                                  color: bloc.isDarkTheme ? white : black,
                                ),
                              ),
                              isCollapsed: true,
                              contentPadding:
                                  const EdgeInsets.only(top: 15, left: 0),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Const.primaryColor.withOpacity(0.4),
                                  width: 2,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Const.primaryColor,
                                  width: 2,
                                ),
                              ),
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: grey.withOpacity(0.7)),
                              hintText:
                                  (widget.isExpenses ? "Gider" : "Gelir") +
                                      " Fiyatı (₺)"),
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
                    fillColor: amount.text.isEmpty
                        ? grey.withOpacity(0.5)
                        : bloc.isDarkTheme
                            ? white
                            : Const.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 40,
                      maxWidth: 40,
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    onPressed: amount.text.isEmpty
                        ? null
                        : () {
                            focusNode.unfocus();
                            widget.nextPagePressed(
                                double.tryParse(amount.text) ?? 0);
                          },
                    child: Icon(
                      Icons.navigate_next_rounded,
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
