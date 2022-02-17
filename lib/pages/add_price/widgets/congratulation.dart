import 'package:flutter/material.dart';
import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/pages/root_app.dart';
import 'package:follow_of_price/pages/update_price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:follow_of_price/ticket_example.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/ticket_view.dart';

class CongratulationPage extends StatefulWidget {
  const CongratulationPage({Key? key, required this.price}) : super(key: key);

  final Price price;

  @override
  State<CongratulationPage> createState() => _CongratulationPageState();
}

class _CongratulationPageState extends State<CongratulationPage> {
  Price get price => widget.price;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
         appBar: AppBar(
           backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  context.pushReplacement(const RootApp());
                },
                icon: Icon(Icons.close_rounded,color: bloc.isDarkTheme ? white : black,)),
          ),
        body: Column(
          children: [
            8.height,
            Const.svg("tebrikler.svg", width: 150, height: 150),
            8.height,
            const Text(
              "Tebrikler!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const Text(
              "İşleminiz uygulamaya başarıyla eklendi.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: grey),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Ticket(
                  bottomClipWidth: 20,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildWidget("Açıklama", price.description),
                               Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child:buildWidget("Kategori", price.category.name),),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: SizedBox(
                                        height: 22,
                                        width: 2,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: buildWidget(
                                      "İşlem Tipi",
                                      price.isExpense ? "Gider" : "Gelir",
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: buildWidget(
                                          "Ödeme Şekli", price.paymentMethod.name)),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: SizedBox(
                                        height: 22,
                                        width: 2,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: grey.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: buildWidget(
                                      "Tarih",
                                      Const.dateToString(
                                        price.time,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Const.buildTitle("Fiyat"),
                                  5.height,
                                  Row(
                                    children: [
                                      Const.buildContent(
                                        "₺"+price.amount.toString(),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Const.primaryColor,
                                  side: BorderSide(
                                    color: Const.primaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  context.push(UpdatePrice(price: price));
                                },
                                child: const Text(
                                  "Düzenle",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  

  Widget buildWidget(String label, String content) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Const.buildTitle(label),
        3.height,
        Const.buildContent(content),
      ],
    );
  }

}
