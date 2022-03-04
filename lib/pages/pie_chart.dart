import 'package:flutter/material.dart';
import 'package:follow_of_price/models/category.dart';
import 'package:follow_of_price/models/category_prices.dart';
import 'package:follow_of_price/models/chart_model.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

enum ChartType { salary, expenses, all }

class PieChartPage extends StatefulWidget {
  const PieChartPage({Key? key}) : super(key: key);

  @override
  State<PieChartPage> createState() => _PieChartPageState();
}

class _PieChartPageState extends State<PieChartPage> {
  ChartType type = ChartType.all;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.keyboard_backspace_rounded,
              color: bloc.isDarkTheme ? white : black,
            ),
          ),
          title: Const.buildContent("Verilerim", textSize: 17),
          actions: [
            DropdownButtonHideUnderline(
              child: DropdownButton<ChartType>(
                borderRadius: BorderRadius.circular(12),
                value: type,
                dropdownColor: bloc.isDarkTheme ? black : Const.backgroundColor,
                items: [
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    child: Const.buildContent("Özet"),
                    value: ChartType.all,
                  ),
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    child: Const.buildContent("Gelir"),
                    value: ChartType.salary,
                  ),
                  DropdownMenuItem(
                    alignment: Alignment.center,
                    child: Const.buildContent("Gider"),
                    value: ChartType.expenses,
                  ),
                ],
                onChanged: (s) {
                  if (s != null) {
                    setState(() {
                      type = s;
                    });
                  }
                },
              ),
            ),
            6.width,
          ],
        ),
        body: StreamBuilder<List<Price>>(
            stream: bloc.pricesStream,
            initialData: bloc.prices,
            builder: (context, snapshot) {
              List<ChartModel> chartModelList = bloc
                  .getChartModelFromType(type)
                  .where((element) => element.totalAmount != 0)
                  .toList();
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    10.height,
                    Center(
                      child: SfCircularChart(
                        tooltipBehavior: TooltipBehavior(
                          enable: true,
                        ),
                        onTooltipRender: (tooltipArgs) {
                          if (tooltipArgs.text != null) {
                            tooltipArgs.text = tooltipArgs.text! + "₺";
                          }
                        },
                        legend: Legend(
                          isVisible: true,
                          backgroundColor:
                              Const.backgroundColor.withOpacity(0.1),
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: bloc.isDarkTheme ? white : black,
                          ),
                          position: LegendPosition.bottom,
                          overflowMode: LegendItemOverflowMode.wrap,
                          orientation: LegendItemOrientation.horizontal,
                        ),
                        annotations: <CircularChartAnnotation>[
                          CircularChartAnnotation(
                            widget: Text(
                              "Net:\n" +
                                  (type == ChartType.expenses ? "-" : "") +
                                  getChartModelAmount(chartModelList)
                                      .toStringAsFixed(1) +
                                  "₺",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: bloc.isDarkTheme ? white : black,
                              ),
                            ),
                          ),
                        ],
                        series: <CircularSeries<ChartModel, String>>[
                          DoughnutSeries<ChartModel, String>(
                            xValueMapper: (d, _) => d.name,
                            yValueMapper: (d, _) => d.totalAmount,
                            dataSource: chartModelList,
                            dataLabelMapper: (datum, index) {
                              return datum.name;
                            },
                            pointColorMapper: (c, _) => c.color,
                            radius: "100%",
                            innerRadius: "65%",
                            sortingOrder: SortingOrder.ascending,
                            dataLabelSettings: const DataLabelSettings(
                              isVisible: true,
                              useSeriesColor: true,
                              overflowMode: OverflowMode.shift,
                              labelPosition: ChartDataLabelPosition.outside,
                            ),
                          ),
                        ],
                      ),
                    ),
                    15.height,
                    if (type == ChartType.all) ...[
                      Row(
                        children: [
                          Const.buildContent("Tüm İşlemler", textSize: 19),
                        ],
                      ),
                      6.height,
                      Column(
                        children: bloc.prices
                            .map((e) => Const.buildLatestWidget(e, context))
                            .toList(),
                      ),
                    ],
                    if (type != ChartType.all) ...[
                      Row(
                        children: [
                          Const.buildContent(
                              "Kategoriye Göre ${type == ChartType.expenses ? "Giderler" : "Gelirler"}",
                              textSize: 19),
                        ],
                      ),
                      6.height,
                      Column(
                        children: getCategoryPricesFromPrices(
                                type == ChartType.expenses
                                    ? bloc.expensesPrices
                                    : bloc.salaryPrices)
                            .map((e) => buildCategoryPrices(
                                e, getChartModelAmount(chartModelList)))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildCategoryPrices(CategoryPrices categoryPrices, double total) {
    double progress = categoryPrices.totalAmount / total * 100;
    return ListTile(
      title: Text(
        categoryPrices.category.name,
        style: TextStyle(
            color: bloc.isDarkTheme ? white : black,
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
      contentPadding: const EdgeInsets.only(right: 8),
      leading: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Const.primaryColor.withOpacity(0.1),
        ),
        child: Const.svg(categoryPrices.category.imagePath!,
            height: 30, width: 30),
      ),
      trailing: Text(
        categoryPrices.totalAmount.toStringAsFixed(1) +
            " ₺\n" +
            progress.toStringAsFixed(1) +
            "%",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: bloc.isDarkTheme ? white : black,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  List<CategoryPrices> getCategoryPricesFromPrices(List<Price> prices) {
    List<Category> categories = [];
    for (var i in prices) {
      if (!categories.any((element) => element.id == i.category.id)) {
        categories.add(i.category);
      }
    }
    List<CategoryPrices> categoryPrices = [];
    for (var i in categories) {
      categoryPrices.add(CategoryPrices(
        category: i,
        prices: prices.where((element) => element.category.id == i.id).toList(),
      ));
    }
    return categoryPrices;
  }

  double getChartModelAmount(List<ChartModel> models) {
    if (type == ChartType.all) {
      if (models.isNotEmpty) {
        double totalAmount = 0;
        for (var i in models) {
          if (i.name == "Gelir") {
            totalAmount += i.totalAmount;
          } else if (i.name == "Gider") {
            totalAmount -= i.totalAmount;
          }
        }
        return totalAmount;
      } else {
        return 0;
      }
    } else {
      double total = 0;
      for (var i in models) {
        total += i.totalAmount;
      }
      return total;
    }
  }
}
