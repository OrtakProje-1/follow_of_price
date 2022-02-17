import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/payment_method.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';

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
          title: Const.buildContent("İşlem Güncelle"),
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
                  child: RawMaterialButton(
                    onPressed: () async {
                      showPriceType().then((value) {
                        if (value != null) {
                          setState(() {
                            isExpenses = value;
                          });
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,vertical: 10,
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: isExpenses ? red : green,
                            child: Icon(
                              isExpenses
                                  ? Icons.download_rounded
                                  : Icons.upload_rounded,
                              color: white,
                            ),
                          ),
                          const SizedBox(
                            width: 22,
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
                                isExpenses ? "Gider" : "Gelir",
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
                    ),
                  ),
                ),
                Expanded(
                  child: RawMaterialButton(
                    onPressed: () {
                      showTextSheet(
                        defaultValue: price.amount.toStringAsFixed(2),
                        isPrice: true,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
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
                                "₺" + amount.toString(),
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
                  ),
                ),
              ],
            ),
            RawMaterialButton(
              onPressed: () {
                showTextSheet(
                  defaultValue: description,
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
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
                      width: 22,
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
                          description,
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
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              onTap: () async {
                Const.showCategorySheet(
                        context,
                        isExpenses
                            ? Const.expensesCategories
                            : Const.salaryCategories)
                    .then((value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                });
              },
              dense: true,
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Const.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Const.svg(category.imagePath!, width: 25, height: 25),
              ),
              title: const Text(
                "Kategori",
                style: TextStyle(color: grey, fontSize: 12),
              ),
              subtitle: Text(
                category.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: bloc.isDarkTheme ? white : black,
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              dense: true,
              onTap: () {
                DatePicker.showDatePicker(
                  context,
                  locale: LocaleType.tr,
                  currentTime: time,
                  showTitleActions: true,
                  theme: DatePickerTheme(
                    backgroundColor:
                        bloc.isDarkTheme ? Const.backgroundColor : white,
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
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      time = value;
                    });
                  }
                });
              },
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
                Const.getTimeText(time),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: bloc.isDarkTheme ? white : black,
                ),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              dense: true,
              onTap: () async {
                PaymentMethod? paymentMethod = await showModalBottomSheet(
                    context: context,
                    backgroundColor:
                        bloc.isDarkTheme ? Const.backgroundColor : white,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
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
                                        color:
                                            Const.primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Const.svg(e.image,
                                          width: 15, height: 15),
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Const.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Const.svg(paymentMethod.image, width: 25, height: 25),
              ),
              subtitle: Text(
                paymentMethod.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: bloc.isDarkTheme ? white : black,
                ),
              ),
              title: Text(
                "Ödeme Yöntemi",
                style: TextStyle(color: grey.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> showPriceType() async {
    return await showModalBottomSheet(
        context: context,
        backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
        builder: (_) {
          return SizedBox(
            height: 150,
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
                      return ListTile(
                        dense: true,
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
                            isExpenses
                                ? Icons.download_rounded
                                : Icons.upload_rounded,
                            color: white,
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
          height: 120,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            color: bloc.isDarkTheme ? Const.backgroundColor : white,
          ),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              color: bloc.isDarkTheme ? Const.backgroundColor : white,
              child: TextField(
                controller: controller,
              ),
            ),
          ),
        );
      },
    );
  }
}
