import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:follow_of_price/json/expenses_categories.dart';
import 'package:follow_of_price/json/salary_categories.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/payment_method.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/models/save_model.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/update_price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/widget/calculator/ui.dart';
import 'package:follow_of_price/widget/month_picker.dart';
import 'package:follow_of_price/util/extensions.dart';
export 'package:follow_of_price/util/extensions.dart';

class Const {
  static Color get backgroundColor {
    return bloc.isDarkTheme ? Colors.grey.shade900 : const Color(0xfff0f1f5);
  }

  static Color get primaryColor {
    return bloc.isDarkTheme ? Colors.white70 : const Color(0xff3b3dbf);
  }

  static Color get cardColor => const Color(0xff7fc3dc);
  static Color get textColor => const Color(0xff121328);

  static List<Category> get expensesCategories {
    return expensesCategoriesJson.map((e) => Category.fromMap(e)).toList();
  }

  static List<String> get days => _days;
  static List<String> get months => _months;
  static Category get defaultExpCategory => defaultCategory;
  static Category get defaultSalCategory => defaultCategory;
  static Category get defaultCategory =>
      Category(name: "Diğer", imagePath: "diger.svg", id: 0);

  static List<Category> get salaryCategories {
    return salaryCategoriesJson.map((e) => Category.fromMap(e)).toList();
  }

  static List<String> get allCategoryImages => _allCetagoryImages;
  static List<PaymentMethod> get paymentMethods => [
        PaymentMethod(id: 1, name: "Banka", image: "maas.svg"),
        PaymentMethod(id: 2, name: "Nakit", image: "odenek.svg"),
        PaymentMethod(id: 3, name: "Kart", image: "kredikarti.svg"),
      ];

  static Widget svg(String name,
      {double width = 40, double height = 40, Color? color, BoxFit? fit}) {
    return SvgPicture.asset(
      "assets/svg/" + name,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      color: color,
    );
  }

  // static tl(
  //     {double width = 10, double height = 10, Color? color, BoxFit? fit}) {
  //   return Const.svg("tl.svg",
  //       width: width, height: height, color: color, fit: fit ?? BoxFit.contain);
  // }

  static AutoSizeText buildContent(
    String txt, {
    Color? color,
    TextOverflow? overflow,
    int? maxLines,
    TextAlign? textAlign,
    double? textSize,
    double? minSize,
    double? maxSize,
  }) {
    return AutoSizeText(
      txt,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: textAlign,
      maxLines: maxLines,
      minFontSize: minSize ?? 14,
      maxFontSize: maxSize ?? double.infinity,
      style: TextStyle(
        fontSize: textSize,
        fontWeight: FontWeight.bold,
        color: bloc.isDarkTheme ? white : color ?? Const.textColor,
      ),
    );
  }

  static Future<DateTime?> showMyMonthPicker(BuildContext ctx,
      {DateTime? minTime,
      DateTime? maxTime,
      DateTime? initialTime,
      double height = 220}) async {
    return showModalBottomSheet<DateTime>(
      context: ctx,
      backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
      builder: (_) {
        return MyMonthPicker(
          height: height,
          maxTime: maxTime ?? DateTime(2100),
          minTime: minTime ?? DateTime(1900),
          initialTime: initialTime ?? DateTime.now(),
        );
      },
    );
  }

  static List<double> getPricesSorted(DateTime time, List<Price> prices,
      {bool isExpenses = false}) {
    int dayCount = getDayCountFromMonth(time);
    List<double> liste = List.generate(dayCount, (index) {
      return getTotalAmountFromDay(time.add(Duration(days: index)), prices,
          isExpense: isExpenses);
    });
    return liste;
  }

  static double getTotalAmountFromDay(DateTime time, List<Price> prices,
      {bool isExpense = false}) {
    List<Price> sameDaysPrices =
        prices.where((element) => element.time.isSameDateAs(time)).toList();
    if (sameDaysPrices.isEmpty) return 0;
    double amount = 0;
    for (var i in sameDaysPrices) {
      if (i.isExpense == isExpense) {
        amount += i.amount;
      }
    }
    return amount;
  }

  // static double maxPriceAmount(List<Price> allPrices) {
  //   double amount=1;
  //   for (var i in allPrices) {
  //     double tempAmount=getTotalAmountFromDay(i.time, allPrices,isExpense: i.isExpense);
  //     if(amount<tempAmount){
  //       amount=tempAmount;
  //     }
  //   }
  //   return amount;
  // }

  static int getDayCountFromMonth(DateTime time) {
    List<int> days31 = [1, 3, 5, 7, 8, 10, 12];
    List<int> days30 = [4, 6, 9, 11];
    if (days31.any((element) => element == time.month)) {
      return 31;
    } else if (days30.any((element) => element == time.month)) {
      return 30;
    }
    return time.year % 4 == 0 ? 29 : 28;
  }

  static AutoSizeText buildTitle(String title, {Color? color}) {
    return AutoSizeText(
      title,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: TextStyle(color: color ?? grey),
    );
  }

  static String getTimeText(DateTime time,
      {bool isTodayString = true, bool isMonth = false}) {
    if (isMonth) {
      return Const.months[time.month - 1] + " " + time.year.toString();
    }

    DateTime today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    time = DateTime(time.year, time.month, time.day);
    int dif = today.difference(time).inDays;
    if (isTodayString) {
      if (dif == 0) {
        return "Bugün";
      } else if (dif == 1) {
        return "Dün";
      } else if (dif == -1) {
        return "Yarın";
      }
    }
    return time.day.toString() +
        " " +
        Const.months[time.month - 1] +
        " " +
        time.year.toString();
  }

  static Widget outlinedButton(String text, {VoidCallback? onPressed}) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Const.buildContent(text),
      style: OutlinedButton.styleFrom(
        primary: Const.primaryColor,
        side: BorderSide(
          color: grey.withOpacity(0.4),
        ),
        shape: const StadiumBorder(),
      ),
    );
  }

  static String dateToString(DateTime time) {
    String day = time.day < 10 ? "0${time.day}" : time.day.toString();
    String month = time.month < 10 ? "0${time.month}" : time.month.toString();
    String year = time.year < 2000
        ? time.year.toString()
        : time.year.toString().split("").sublist(2).join("");
    return day + "-" + month + "-" + year;
  }

  static Widget buildLatestWidget(Price price, BuildContext context) {
    return Slidable(
      direction: Axis.horizontal,
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (c) {
              c.push(UpdatePrice(price: price));
            },
            backgroundColor: const Color(0xFF21B7CA),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Düzenle',
          ),
          SlidableAction(
            onPressed: (c) {
              showCheckDialog(
                      context, "Bu işlemi silmek istediğine emin misin?")
                  .then((value) {
                if (value != null) {
                  if (value) {
                    bloc.removePrice(price);
                  }
                }
              });
            },
            backgroundColor: red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Sil',
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          price.category.name + " (" + Const.dateToString(price.time) + ")",
          style: TextStyle(
              color: bloc.isDarkTheme ? white : black,
              fontWeight: FontWeight.bold,
              fontSize: 14),
        ),
        subtitle:
            Text(price.description, style: const TextStyle(color: Colors.grey)),
        contentPadding: const EdgeInsets.only(right: 8),
        leading: Container(
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Const.primaryColor.withOpacity(0.1),
          ),
          child: Const.svg(price.category.imagePath!, height: 30, width: 30),
        ),
        trailing: Text(
          (price.isExpense ? "-" : "") + price.amount.toStringAsFixed(1) + " ₺",
          style: TextStyle(
              color: bloc.isDarkTheme ? white : black,
              fontSize: 12,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static showMsg(String msg, {Toast toastLength = Toast.LENGTH_SHORT}) {
    Fluttertoast.showToast(msg: msg, toastLength: toastLength);
  }

  static Future<bool?> showCheckDialog(BuildContext context, String content) {
    return showDialog<bool>(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Const.backgroundColor,
          title: Text(
            "Emin misin?",
            style: TextStyle(
              color: bloc.isDarkTheme ? white : black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            content,
            style: TextStyle(
              color: bloc.isDarkTheme ? white : black,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                primary: bloc.isDarkTheme ? white : black,
              ),
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("Hayır"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: bloc.isDarkTheme ? white : black,
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("Evet"),
            ),
          ],
        );
      },
    );
  }

  static Future<Category?> showCategorySheet(
      BuildContext context, List<Category> categories) async {
    var size = MediaQuery.of(context).size;
    return showModalBottomSheet<Category>(
      isScrollControlled: true,
      context: context,
      backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
      builder: (_) {
        return SizedBox(
          height: 400,
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
                child: GridView.count(
                  physics: const BouncingScrollPhysics(),
                  crossAxisCount: size.width ~/ 120,
                  children: categories.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Const.cardColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.pop(context, e);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Const.svg(e.imagePath!),
                                Text(
                                  e.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: bloc.isDarkTheme ? white : black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<double?> showCalculateSheet(BuildContext context,
      {double initial = 0}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: bloc.isDarkTheme ? Const.backgroundColor : white,
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(22),
          ),
        ),
        builder: (_) {
          return SizedBox(
            height: context.height * 0.65,
            child: SimpleCalculator(
              theme: CalculatorThemeData(
                borderRadius: 22,
                commandColor: bloc.isDarkTheme ? black : white,
                commandStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: bloc.isDarkTheme ? white : black,
                ),
                displayStyle: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: bloc.isDarkTheme ? white : black,
                ),
              ),
              value: initial,
            ),
          );
        });
  }

  static Widget shopGif({double radius = 100}) {
    return CircleAvatar(
      radius: radius,
      backgroundImage: const AssetImage("assets/gifs/shop.gif"),
    );
  }

  static List<User> getUsers() {
    return (usersBox!.get("users", defaultValue: []) as List<dynamic>).map((e) {
      return User.fromJson(e.toString());
    }).toList();
  }

  static List<SaveModel> getSaveModels() {
    List<SaveModel> saveModels = [];
    for (var i in getUsers()) {
      String? data = datasBox!.get(i.id.toString());
      if (data != null) {
        saveModels.add(SaveModel.fromJson(data));
      }
    }
    return saveModels;
  }

  static Future<bool> getBackup() async {
    FilePickerResult? value = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ["txt"],
    );
    try {
      if (value != null) {
        if (value.files.isNotEmpty) {
          File file = File(value.files.first.path!);
          String saveModelTxt = await file.readAsString();
          List<SaveModel> saveModels =
              (jsonDecode(saveModelTxt)["saveModels"] as List)
                  .map((e) => SaveModel.fromJson(e.toString()))
                  .toList();
          List<User> users = saveModels.map((e) => e.user).toList();
          List<User> savedUsers = Const.getUsers();
          for (var i in saveModels) {
            if (!savedUsers.any((element) => element.id == i.user.id)) {
              datasBox!.put(i.user.id.toString(), i.toJson());
            }
          }
          for (var user in users) {
            if (!savedUsers.any((element) => element == user)) {
              savedUsers.add(user);
            }
          }
          usersBox!.put("users", users.map((e) => e.toJson()).toList());
          Const.showMsg("Yedeklenmiş Veriler Yüklendi");
        }
      }
      return true;
    } on Exception catch (e) {
      Const.showMsg("Hata: " + e.toString());
      return false;
    }
  }
}

const List<String> _days = ["Pzt", "Sal", "Çar", "Per", "Cum", "Cmrt", "Pzr"];

const List<String> _months = [
  "Ocak",
  "Şubat",
  "Mart",
  "Nisan",
  "Mayıs",
  "Haziran",
  "Temmuz",
  "Ağustos",
  "Eylül",
  "Ekim",
  "Kasım",
  "Aralık"
];

const List<String> _allCetagoryImages = [
  "alisveris.svg",
  "araba.svg",
  "bakim.svg",
  "bakkaliye.svg",
  "bonus.svg",
  "cocuk.svg",
  "diger.svg",
  "dogalgaz.svg",
  "egitim.svg",
  "eglence.svg",
  "elektrik.svg",
  "emeklilik.svg",
  "evcilhayvan.svg",
  "fatura.svg",
  "ida.svg",
  "hediye.svg",
  "icecekler.svg",
  "ilac.svg",
  "internet.svg",
  "is.svg",
  "kira.svg",
  "kirtasiye.svg",
  "kisiselbakim.svg",
  "kredikarti.svg",
  "maas.svg",
  "mobilya.svg",
  "odenek.svg",
  "saglik.svg",
  "sigara.svg",
  "sigorta.svg",
  "spor.svg",
  "su.svg",
  "tasarruf.svg",
  "telefon.svg",
  "televizyon.svg",
  "ulasim.svg",
  "yakit.svg",
  "yatirim.svg",
  "yatirimgeliri.svg",
];
