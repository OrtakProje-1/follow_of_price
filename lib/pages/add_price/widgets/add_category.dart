import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';

class AddCategory extends StatefulWidget {
  final bool isExpenses;
  final ValueChanged<Category> nextPagePressed;
  final double amount;
  final String description;
  const AddCategory({
    Key? key,
    required this.isExpenses,
    required this.nextPagePressed,
    required this.amount,
    required this.description,
  }) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController description = TextEditingController();
  final FocusNode focusNode = FocusNode();
  late Category defaultCategory;

  @override
  void initState() {
    defaultCategory =
        widget.isExpenses ? Const.defaultExpCategory : Const.defaultSalCategory;
    super.initState();
  }

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
                                    "₺" + widget.amount.toString(),
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
                          "Kategori",
                          style: TextStyle(color: grey.withOpacity(0.6)),
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          horizontalTitleGap: 5,
                          onTap: () async {
                            Category? category = await Const.showCategorySheet(
                                context,
                                widget.isExpenses
                                    ? Const.expensesCategories
                                    : Const.salaryCategories);
                            if (category != null) {
                              setState(() {
                                defaultCategory = category;
                              });
                            }
                          },
                          leading: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Const.primaryColor
                                  .withOpacity(bloc.isDarkTheme ? 0.4 : 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Const.svg(defaultCategory.imagePath!,
                                width: 25, height: 25),
                          ),
                          title: Text(
                            defaultCategory.name,
                            style: TextStyle(
                              color: bloc.isDarkTheme ? white : black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
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
                    fillColor: bloc.isDarkTheme ? white : Const.primaryColor,
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
                      widget.nextPagePressed(defaultCategory);
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
