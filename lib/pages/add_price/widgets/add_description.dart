import 'package:flutter/material.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class AddDescription extends StatefulWidget {
  final bool isExpenses;
  final ValueChanged<String> nextPagePressed;
  final double amount;
  const AddDescription({
    Key? key,
    required this.isExpenses,
    required this.nextPagePressed,
    required this.amount,
  }) : super(key: key);

  @override
  State<AddDescription> createState() => _AddDescriptionState();
}

class _AddDescriptionState extends State<AddDescription> {
  final TextEditingController description = TextEditingController();
  final FocusNode focusNode=FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Açıklama",
                          style: TextStyle(color: grey.withOpacity(0.6)),
                        ),
                        TextField(
                          autofocus: true,
                          focusNode: focusNode,
                          onChanged: (s) {
                            setState(() {});
                          },
                          controller: description,
                          cursorRadius: const Radius.circular(6),
                          cursorColor: Const.primaryColor,
                          style:TextStyle(
                              color: bloc.isDarkTheme ? white : black, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                              isCollapsed: true,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 12),
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
                                      " Açıklaması"),
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
                    fillColor: description.text.isEmpty
                        ? grey.withOpacity(0.5)
                        : bloc.isDarkTheme ? white : Const.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    constraints: const BoxConstraints(
                      maxHeight: 40,
                      maxWidth: 40,
                      minHeight: 40,
                      minWidth: 40,
                    ),
                    onPressed: description.text.isEmpty
                        ? null
                        : () {
                            focusNode.unfocus();
                            widget.nextPagePressed(description.text);
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
