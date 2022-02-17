import 'package:flutter/material.dart';
import 'package:follow_of_price/main.dart';
import 'package:follow_of_price/models/budget.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/models/save_model.dart';
import 'package:follow_of_price/models/user.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:rxdart/rxdart.dart';

class Global extends ChangeNotifier {
  Global() {
    _pricesSubject = BehaviorSubject.seeded([]);
    _budgetsSubject = BehaviorSubject.seeded([]);
  }

  List<VoidCallback> themeListeners = [];

  BehaviorSubject<ThemeMode> theme = BehaviorSubject.seeded(ThemeMode.light);
  final BehaviorSubject<User?> _userSubject = BehaviorSubject();

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
    getUserDatas(user);
  }

  void updateUser(User user) {
    List<User> users = Const.getUsers();
    int index = users.indexWhere((element) => element.id == user.id);
    if (index != -1) {
      users[index] = user;
      usersBox!.put("users", users.map((e) => e.toJson()).toList());
      _userSubject.add(user);
    }
  }

  void saveUserDatas() {
    SaveModel saveModel = SaveModel(prices: prices, budgets: budgets);
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
    saveUserDatas();
    notifyListeners();
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
    } else {
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
