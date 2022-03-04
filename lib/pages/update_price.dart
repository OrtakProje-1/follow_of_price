import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/payment_method.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/pages/root_app.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/calculator/ui.dart';

class UpdatePrice extends StatefulWidget {
  const UpdatePrice({Key? key, required this.price}) : super(key: key);

  final Price price;

  @override
  State<UpdatePrice> createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  late String description;
  late double amount;
  final FocusNode focusNode = FocusNode();
  late PaymentMethod paymentMethod;
  late Category category;

  Price get price => widget.price;
  late DateTime time;
  late bool isExpenses;

  @override
  void initState() {
    paymentMethod = price.paymentMethod;
    time = price.time;
    isExpenses = price.isExpense;
    description = price.description;
    amount = price.amount;
    category = price.category;
    super.initState();
  }

  @override
  Widget build(BuildContext ctx) {
    return BackgroundWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Const.buildContent("İşlem Güncelle", textSize: 17),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.keyboard_backspace_rounded,
                color: bloc.isDarkTheme ? white : black,
              )),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: customListTile(
                    title: "İşlem Tipi",
                    leadingBgColor: isExpenses ? red : green,
                    content: isExpenses ? "Gider" : "Gelir",
                    onPressed: () async {
                      showPriceType().then((value) {
                        if (value != null) {
                          setState(() {
                            isExpenses = value;
                          });
                        }
                      });
                    },
                    leadingChild: Icon(
                      isExpenses
                          ? Icons.download_rounded
                          : Icons.upload_rounded,
                      color: white,
                    ),
                  ),
                ),
                Expanded(
                  child: customListTile(
                    title: "Fiyat",
                    content: "₺" + amount.toStringAsFixed(2),
                    onPressed: () {
                      showTextSheet<double>(
                        defaultValue: amount.toStringAsFixed(2),
                        isPrice: true,
                      ).then((value) {
                        if (value != null) {
                          setState(() {
                            amount = value;
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
            customListTile(
              title: "Açıklama",
              content: description,
              onPressed: () {
                showTextSheet<String>(
                  defaultValue: description,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      description = value;
                    });
                  }
                });
              },
              leadingChild: const Icon(
                Icons.info_outline_rounded,
                color: Colors.blue,
                size: 25,
              ),
            ),
            customListTile(
              title: "Kategori",
              content: category.name,
              onPressed: () {
                Const.showCategorySheet(
                  context,
                  isExpenses
                      ? Const.expensesCategories
                      : Const.salaryCategories,
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                });
              },
              leadingChild:
                  Const.svg(category.imagePath!, width: 25, height: 25),
            ),
            customListTile(
              title: "Tarih",
              content: Const.getTimeText(time),
              onPressed: showDateTimePickerSheet,
              leadingChild: Icon(
                Icons.date_range_outlined,
                color: Const.primaryColor,
                size: 25,
              ),
            ),
            customListTile(
              title: "Ödeme Yöntemi",
              content: paymentMethod.name,
              onPressed: showPaymentMethodSheet,
              leadingChild:
                  Const.svg(paymentMethod.image, width: 25, height: 25),
            ),
            const Spacer(),
            Const.outlinedButton(
              "Güncelle",
              onPressed: () {
                Price price = widget.price.copyWith(
                  category: category,
                  amount: amount,
                  description: description,
                  isExpense: isExpenses,
                  paymentMethod: paymentMethod,
                  time: time,
                );
                print(price);
                bloc.updatePrice(price);
                context.pushReplacement(const RootApp());
              },
            ),
            8.height,
          ],
        ),
      ),
    );
  }

  void showDateTimePickerSheet() async {
    DateTime? value = await DatePicker.showDatePicker(
      context,
      locale: LocaleType.tr,
      currentTime: time,
      showTitleActions: true,
      theme: DatePickerTheme(
        backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
        cancelStyle: TextStyle(
          color: grey.withOpacity(0.6),
          fontWeight: FontWeight.bold,
        ),
        itemStyle: TextStyle(
          color: bloc.isDarkTheme ? white : black,
        ),
        doneStyle: TextStyle(
          color: bloc.isDarkTheme ? white : Const.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    if (value != null) {
      setState(() {
        time = value;
      });
    }
  }

  void showPaymentMethodSheet() async {
    PaymentMethod? paymentMethod = await showModalBottomSheet(
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
                        borderRadius: BorderRadius.circular(22),
                        color: Colors.grey.shade300),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: Const.paymentMethods.map((e) {
                      return ListTile(
                        dense: true,
                        tileColor: e == this.paymentMethod
                            ? Const.cardColor.withOpacity(0.15)
                            : Colors.transparent,
                        onTap: () {
                          Navigator.pop(context, e);
                        },
                        title: Text(
                          e.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bloc.isDarkTheme ? white : black,
                          ),
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Const.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Const.svg(e.image, width: 15, height: 15),
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
  }

  Future<bool?> showPriceType() async {
    return await showModalBottomSheet(
        context: context,
        backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
        builder: (_) {
          return SizedBox(
            height: 140,
            child: Column(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 90,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(2, (index) {
                      bool isExp = index == 0;
                      return Expanded(
                        child: ListTile(
                          tileColor: isExpenses == isExp
                              ? Const.cardColor.withOpacity(0.15)
                              : Colors.transparent,
                          onTap: () {
                            Navigator.pop(context, isExp);
                          },
                          title: Text(
                            isExp ? "Gider" : "Gelir",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: bloc.isDarkTheme ? white : black,
                            ),
                          ),
                          leading: CircleAvatar(
                            radius: 16,
                            backgroundColor: isExp ? red : green,
                            child: Icon(
                              isExp
                                  ? Icons.download_rounded
                                  : Icons.upload_rounded,
                              color: white,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<T?> showTextSheet<T>(
      {bool isPrice = false, String defaultValue = ""}) {
    TextEditingController controller =
        TextEditingController(text: defaultValue);
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
      isScrollControlled: true,
      builder: (_) {
        return Container(
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          height: 150,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            color: bloc.isDarkTheme ? Const.backgroundColor : white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Const.buildContent(isPrice ? "Fiyat" : "Açıklama",
                        color: grey.withOpacity(0.6)),
                    TextButton(
                      style: TextButton.styleFrom(
                        primary: grey.withOpacity(0.4),
                      ),
                      onPressed: () {
                        if (isPrice) {
                          double? amount =
                              double.tryParse(controller.text.trim());
                          if (amount != null) {
                            String amountString = amount.toStringAsFixed(2);
                            amount = double.tryParse(amountString);
                          }
                          Navigator.pop(context, amount);
                        } else {
                          Navigator.pop(
                              context,
                              controller.text.trim().isNotEmpty
                                  ? controller.text.trim()
                                  : null);
                        }
                      },
                      child: Const.buildContent("Kaydet"),
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: bloc.isDarkTheme
                    ? white.withOpacity(0.1)
                    : Const.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: TextField(
                    autofocus: true,
                    controller: controller,
                    keyboardType: isPrice ? TextInputType.number : null,
                    style: TextStyle(
                      color: bloc.isDarkTheme ? white : black,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: isPrice ? "Fiyat" : "Açıklama",
                      hintStyle: TextStyle(color: grey.withOpacity(0.4)),
                      prefix: isPrice
                          ? Padding(
                              padding: const EdgeInsets.only(
                                right: 8,
                              ),
                              child: Const.buildContent("₺"),
                            )
                          : null,
                      suffixIcon:!isPrice ? null : IconButton(
                        onPressed: () {
                          Const.showCalculateSheet(context,initial: double.tryParse(controller.text)??0).then((value){
                            if(value!=null){
                              controller.text=value.toStringAsFixed(2);
                              
                            }
                          });
                        },
                        icon: Icon(
                          Icons.calculate,
                          color: bloc.isDarkTheme ? white : black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  

  Widget customListTile({
    required String title,
    required String content,
    required VoidCallback onPressed,
    Widget? leadingChild,
    Color? leadingBgColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      onTap: onPressed,
      dense: true,
      leading: leadingChild == null
          ? null
          : CircleAvatar(
              radius: 20.5,
              backgroundColor:
                  leadingBgColor ?? Const.primaryColor.withOpacity(0.1),
              child: leadingChild,
            ),
      title: Text(
        title,
        style: const TextStyle(color: grey, fontSize: 12),
      ),
      subtitle: Text(
        content,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: bloc.isDarkTheme ? white : black,
        ),
      ),
    );
  }
}
