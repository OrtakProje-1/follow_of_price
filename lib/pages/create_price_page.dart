import 'package:follow_of_price/models/price.dart';
import 'package:follow_of_price/pages/add_price/add_price.dart';
import 'package:follow_of_price/providers/global.dart';
import 'package:follow_of_price/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:follow_of_price/util/const.dart';
import 'package:follow_of_price/widget/background.dart';
import 'package:follow_of_price/widget/user_avatar.dart';

class CreatPricePage extends StatefulWidget {
  const CreatPricePage({Key? key}) : super(key: key);

  @override
  _CreatPricePageState createState() => _CreatPricePageState();
}

class _CreatPricePageState extends State<CreatPricePage> {
  int activeCategory = 0;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Const.buildContent("Gelir-Gider Ekle", textSize: 17),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: const [
            UserAvatar(),
          ],
        ),
        body: getBody(),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<ThemeMode>(
          stream: bloc.theme,
          builder: (context, theme) {
            return Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  invertColors:bloc.isDarkTheme,
                  colorFilter: ColorFilter.mode(bloc.isDarkTheme ? grey : white, BlendMode.color),
                  image:const AssetImage("assets/gifs/shop.gif"),
                ),
              ),
            );
          }
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RawMaterialButton(
              splashColor: green.withOpacity(0.5),
              onPressed: () {
                context.push(const AddPrice(isExpenses: false)).then((value) {
                  setState(() {});
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: (size.width) / 2 - 30,
                padding: const EdgeInsets.all(6),
                height: 90,
                decoration: BoxDecoration(
                  color: bloc.isDarkTheme
                      ? white.withOpacity(0.1)
                      : white.withOpacity(0.7),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20, color: Colors.black.withOpacity(0.1)),
                  ],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: green,
                      child: Icon(
                        Icons.upload_rounded,
                        color: white,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Gelir Ekle",
                      style:
                          TextStyle(color: green, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            RawMaterialButton(
              splashColor: Colors.red.withOpacity(0.5),
              onPressed: () async {
                context.push(const AddPrice(isExpenses: true)).then((value) {
                  setState(() {});
                });
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: (size.width) / 2 - 30,
                height: 90,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 20, color: Colors.black.withOpacity(0.1)),
                  ],
                  color: bloc.isDarkTheme
                      ? white.withOpacity(0.1)
                      : white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: red,
                      child: Icon(
                        Icons.download_rounded,
                        color: white,
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Gider Ekle",
                      style: TextStyle(
                        color: red,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        12.height,
        Row(
          children: [
            Expanded(
              child: RawMaterialButton(
                splashColor: black.withOpacity(0.5),
                onPressed: () {
                  context.push(const AddPrice(isExpenses: false)).then((value) {
                    setState(() {});
                  });
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  width: double.maxFinite,
                  padding: const EdgeInsets.all(6),
                  height: 90,
                  decoration: BoxDecoration(
                    color: bloc.isDarkTheme
                        ? white.withOpacity(0.1)
                        : white.withOpacity(0.7),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 20, color: Colors.black.withOpacity(0.1)),
                    ],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.transparent,
                        child: Icon(
                          Icons.timelapse_sharp,
                          color: black,
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text(
                        "Taksit Ekle",
                        style:
                            TextStyle(color: black, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Geçmiş Girdiler",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19,
                color: bloc.isDarkTheme ? white : black,
              ),
            ),
            Container(
              constraints: const BoxConstraints(
                  maxHeight: 30, maxWidth: 30, minHeight: 30, minWidth: 30),
              decoration: BoxDecoration(
                  color: Const.cardColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6)),
              child: PopupMenuButton(
                padding: const EdgeInsets.all(0),
                icon: Icon(
                  Icons.sort,
                  color: bloc.isDarkTheme ? white : black,
                ),
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
                itemBuilder: (_) {
                  return const [
                    PopupMenuItem(child: Text("A-Z")),
                    PopupMenuItem(child: Text("Z-A")),
                    PopupMenuItem(child: Text("1-9")),
                  ];
                },
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(4),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(6),
            //     color: Const.cardColor.withOpacity(0.2),
            //   ),
            //   child: Icon(
            //     Icons.sort_rounded,
            //     color: Const.cardColor,
            //   ),
            // ),
          ],
        ),
        6.height,
        StreamBuilder<List<Price>>(
          stream: bloc.pricesStream,
          initialData: bloc.prices,
          builder: (context, pricesSnap){
            return Column(
              children: pricesSnap.data!.map((e) {
                return Const.buildLatestWidget(e, context);
              }).toList(),
            );
          }
        ),
      ],
    );
  }

  // SingleChildScrollView buildCategoryCard() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     child: Row(
  //         children: List.generate(categories.length, (index) {
  //       return GestureDetector(
  //         onTap: () {
  //           setState(() {
  //             activeCategory = index;
  //           });
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.only(
  //             left: 10,
  //           ),
  //           child: Container(
  //             margin: const EdgeInsets.only(
  //               left: 10,
  //             ),
  //             width: 100,
  //             height: 120,
  //             decoration: BoxDecoration(
  //                 color: white.withOpacity(0.5),
  //                 border: Border.all(
  //                   width: 2,
  //                   color: activeCategory == index ? primary : Colors.black12,
  //                 ),
  //                 borderRadius: BorderRadius.circular(12),
  //                 boxShadow: [
  //                   BoxShadow(
  //                     color: grey.withOpacity(0.01),
  //                     spreadRadius: 10,
  //                     blurRadius: 3,
  //                     // changes position of shadow
  //                   ),
  //                 ]),
  //             child: Padding(
  //               padding: const EdgeInsets.only(
  //                   left: 25, right: 25, top: 20, bottom: 20),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Container(
  //                       width: 40,
  //                       height: 40,
  //                       decoration: BoxDecoration(
  //                           shape: BoxShape.circle,
  //                           color: grey.withOpacity(0.15)),
  //                       child: Center(
  //                         child: Image.asset(
  //                           categories[index]['icon'],
  //                           width: 30,
  //                           height: 30,
  //                           fit: BoxFit.contain,
  //                         ),
  //                       )),
  //                   Text(
  //                     categories[index]['name'],
  //                     style: TextStyle(
  //                       fontWeight: FontWeight.bold,
  //                       fontSize: 20,
  //                     ),
  //                   )
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     })),
  //   );
  // }
}
