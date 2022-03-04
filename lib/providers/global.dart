import 'dart:math';

import 'package:flutter/material.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/budget.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/chart_model.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/models/save_model.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/pages/pie_chart.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:rxdart/rxdart.dart';

class Global extends ChangeNotifier {
  Global() {
    _pricesSubject = BehaviorSubject.seeded([]);
    _budgetsSubject = BehaviorSubject.seeded([]);
    _userSubject = BehaviorSubject.seeded(null);
  }

  List<VoidCallback> themeListeners = [];

  late BehaviorSubject<ThemeMode> theme =
      BehaviorSubject.seeded(ThemeMode.light);
  late BehaviorSubject<User?> _userSubject;

  User? get user => _userSubject.value;
  ThemeMode get themeMode => theme.value;

  List<Budget> get budgets => _budgetsSubject.value;
  List<Price> get prices => _pricesSubject.value;
  List<Price> get expensesPrices => prices.where((e) => e.isExpense).toList();
  List<Price> get salaryPrices => prices.where((e) => !e.isExpense).toList();

  Stream<List<Price>> get pricesStream => _pricesSubject.stream;
  Stream<List<Budget>> get budgetsStream => _budgetsSubject.stream;
  Stream<User?> get userStream => _userSubject.stream;

  late BehaviorSubject<List<Budget>> _budgetsSubject;
  late BehaviorSubject<List<Price>> _pricesSubject;

  int pageIndex = 0;

  set themeMode(ThemeMode newMode) {
    theme.add(newMode);
    datasBox!.put("theme", newMode.index.toString());
  }

  void changeUser(User user) {
    _userSubject.add(user);
    datasBox!.put("currentUser", user.id.toString());
    getUserDatas(user);
  }

  void updateUser(User user) {
    List<User> users = Const.getUsers();
    int index = users.indexWhere((element) => element.id == user.id);
    if (index != -1) {
      users[index] = user;
      usersBox!.put("users", users.map((e) => e.toJson()).toList());
      _userSubject.add(user);
      Const.showMsg("Kullanıcı Güncellendi");
    } else {
      Const.showMsg("Kullanıcı Güncellenemedi");
    }
  }

  void saveUserDatas() {
    SaveModel saveModel =
        SaveModel(prices: prices, budgets: budgets, user: user!);
    datasBox!.put(user!.id.toString(), saveModel.toJson());
  }

  void getUserDatas(User user) {
    String? data = datasBox!.get(user.id.toString());
    if (data == null) {
      _budgetsSubject.add([]);
      _pricesSubject.add([]);
    } else {
      SaveModel saveModel = SaveModel.fromJson(data);
      _budgetsSubject.add(saveModel.budgets);
      _pricesSubject.add(saveModel.prices);
    }
  }

  bool get isDarkTheme {
    return themeMode == ThemeMode.dark;
  }

  void addPrice(Price price) {
    List<Price> prices2 = prices;
    prices2.add(price);
    _pricesSubject.add(prices2);
    Const.showMsg("İşlem Eklendi");
    saveUserDatas();
    notifyListeners();
  }

  void updatePrice(Price price) {
    List<Price> allPrices = prices;
    int index = allPrices.indexWhere((element) => element.id == price.id);

    if (index != -1) {
      allPrices[index] = price;
      _pricesSubject.add(allPrices);
      saveUserDatas();
      Const.showMsg("Güncelleme Başarılı");
    } else {
      Const.showMsg("Güncelleme Başarısız");
    }
  }

  void removePrice(Price price) {
    List<Price> allPrices = prices;
    int index = allPrices.indexWhere((element) => element == price);

    if (index != -1) {
      allPrices.removeAt(index);
      _pricesSubject.add(allPrices);
      saveUserDatas();
      Const.showMsg("Silme işlemi Başarılı");
    } else {
      Const.showMsg("Silme İşlemi Başarısız");
    }
  }

  void removeBudget(Budget budget) {
    List<Budget> allBudgets = budgets;
    int index = allBudgets.indexWhere((element) => element.id == budget.id);
    if (index != -1) {
      allBudgets.removeAt(index);
      _budgetsSubject.add(allBudgets);
      saveUserDatas();
      Const.showMsg("Bütçe Silindi");
    } else {
      Const.showMsg("Bütçe Silinemedi");
    }
  }

  void addBudget(Budget budget) {
    List<Budget> budgets2 = budgets;

    int index = budgets2
        .indexWhere((element) => element.category.id == budget.category.id);
    if (index != -1) {
      Budget temp = budgets2[index];
      temp = temp.copyWith(
        amount: temp.amount + budget.amount,
        color: budget.color,
      );
      budgets2[index] = temp;
      _budgetsSubject.add(budgets2);
      Const.showMsg("Bütçe Güncellendi");
    } else {
      Const.showMsg("Bütçe Eklendi");
      budgets2.add(budget);
      _budgetsSubject.add(budgets2);
    }
    saveUserDatas();
  }

  void setIndex(int newIndex) {
    if (pageIndex != newIndex) {
      pageIndex = newIndex;
      notifyListeners();
    }
  }

  List<Price> getPricesFromMonth(DateTime time) {
    return prices.where((element) => element.time.isSameMonthAs(time)).toList();
  }

  List<Price> getPricesFromDay(DateTime time) {
    return prices.where((element) => element.time.isSameDateAs(time)).toList();
  }

  double get getMaxPriceAmount {
    double amount = 1;
    for (var i in prices) {
      double tempAmount = Const.getTotalAmountFromDay(
        i.time,
        prices,
        isExpense: i.isExpense,
      );
      if (amount < tempAmount) {
        amount = tempAmount;
      }
    }
    return amount;
  }

  double getAmountFromPrices(List<Price> prices) {
    double amount = 0;
    for (var i in prices) {
      amount += i.amount;
    }
    return amount;
  }

  List<ChartModel> getChartModelFromType(ChartType type) {
    if (type == ChartType.all) {
      return [
        ChartModel(
          name: "Gelir",
          prices: salaryPrices,
          color: isDarkTheme ? white : Const.primaryColor,
        ),
        ChartModel(name: "Gider", prices: expensesPrices, color: primary),
      ];
    } else if (type == ChartType.expenses) {
      List<Color> colors = [];
      return getCategoriesFromPrices(expensesPrices).map((e) {
        Color color = randomColor();
        while (colors.any((element) => element == color)) {
          color = randomColor();
        }
        return ChartModel(
          name: e.name,
          prices: getPricesFromCategoryAndPrices(e, expensesPrices),
          color: color,
        );
      }).toList();
    } else {
      List<Color> colors = [];
      return getCategoriesFromPrices(salaryPrices).map((e) {
        Color color = randomColor();
        while (colors.any((element) => element == color)) {
          color = randomColor();
        }
        return ChartModel(
          name: e.name,
          prices: getPricesFromCategoryAndPrices(e, salaryPrices),
          color: color,
        );
      }).toList();
    }
  }

  Color randomColor() {
    int r = (Random().nextDouble() * 255).toInt();
    int g = (Random().nextDouble() * 255).toInt();
    int b = (Random().nextDouble() * 255).toInt();
    return Color.fromARGB(255, r, g, b);
  }

  List<Price> getPricesFromCategoryAndPrices(
      Category category, List<Price> prices) {
    List<Price> filteredPrices = [];
    for (var i in prices) {
      if (i.category.id == category.id) {
        filteredPrices.add(i);
      }
    }
    return filteredPrices;
  }

  List<Category> getCategoriesFromPrices(List<Price> prices) {
    List<Category> categories = [];
    for (var i in prices) {
      if (!categories.any((element) => element.id == i.category.id)) {
        categories.add(i.category);
      }
    }
    return categories;
  }

  double getTotalAmountPricesFromBudget(DateTime month, Budget budget) {
    List<Price> monthPrices = getPricesFromMonth(month);
    List<Price> monthExpensesPrices = monthPrices
        .where((element) => element.category.id == budget.category.id)
        .toList();
    if (monthExpensesPrices.isNotEmpty) {
      double amount = getAmountFromPrices(monthExpensesPrices);
      return amount;
    }
    return 0;
  }
}

Global bloc = Global();
