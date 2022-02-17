import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:follow_of_price/models/budget.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';

class AddBudget extends StatefulWidget {
  const AddBudget({Key? key}) : super(key: key);

  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  late Category defaultCategory;
  TextEditingController amount = TextEditingController();
  Color defaultColor = Const.primaryColor;

  @override
  void initState() {
    defaultCategory = Const.defaultCategory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Const.backgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_backspace_rounded,
            color: bloc.isDarkTheme ? white : black,
          ),
        ),
        title: Const.buildContent("Bütçe Oluştur"),
      ),
      body: BackgroundWidget(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              ListTile(
                onTap: () {
                  showColorDialog();
                },
                horizontalTitleGap: 5,
                contentPadding: EdgeInsets.zero,
                dense: true,
                trailing: Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: defaultColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                title: Text(
                  "Renk",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: bloc.isDarkTheme ? white : black,
                  ),
                ),
              ),
              20.height,
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
                    Const.expensesCategories,
                  );
                  if (category != null) {
                    setState(() {
                      defaultCategory = category;
                    });
                  }
                },
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Const.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Const.svg(defaultCategory.imagePath!,
                      width: 25, height: 25),
                ),
                title: Text(
                  defaultCategory.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: bloc.isDarkTheme ? white : black,
                  ),
                ),
              ),
              12.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Fiyat",
                    style: TextStyle(color: grey.withOpacity(0.6)),
                  ),
                  TextField(
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
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            "₺",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bloc.isDarkTheme ? white : black,
                            ),
                          ),
                        ),
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
                        hintText: "Bütçe Fiyatı"),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color:amount.text.isNotEmpty ? Const.primaryColor : grey.withOpacity(0.4),
                          width: 2,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const StadiumBorder(),
                        primary: Const.primaryColor,
                      ),
                      onPressed: amount.text.isEmpty
                          ? null
                          : () {
                              Budget budget = Budget(
                                color: defaultColor,
                                amount: double.tryParse(amount.text) ?? 0,
                                category: defaultCategory,
                                id: DateTime.now().millisecondsSinceEpoch,
                              );
                              bloc.addBudget(budget);
                              Navigator.pop(context);
                            },
                      child:Text(
                        "Kaydet",
                        style: TextStyle(
                          color:amount.text.isNotEmpty ? Const.primaryColor : grey.withOpacity(0.4),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showColorDialog() {
    showDialog(
        context: context,
        builder: (_) {
          Color color = defaultColor;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
              contentPadding: const EdgeInsets.all(4),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(300), bottom: Radius.circular(20)),
              ),
              content: SizedBox(
                height: 280,
                width: 280,
                child: ColorPickerArea(HSVColor.fromColor(color), (s) {
                  setState(() {
                    color = s.toColor();
                  });
                }, PaletteType.hueWheel),
              ),
              actions: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: grey, width: 1),
                    primary: grey,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "İptal",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: color,
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Const.primaryColor, width: 1),
                    primary: Const.primaryColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context, color);
                  },
                  child: const Text(
                    "Tamam",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          });
        }).then((value) {
      if (value != null) {
        setState(() {
          defaultColor = value;
        });
      }
    });
  }
}
