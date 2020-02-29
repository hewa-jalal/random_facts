import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:random_color/random_color.dart';
import 'package:random_facts/constants.dart';
import 'package:random_facts/facts.dart';
import 'package:random_facts/facts_bank.dart';

import 'facts.dart';
import 'favourite_facts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Random Facts",
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.blue),
      home: RandomFactsPage(),
    );
  }
}

class RandomFactsPage extends StatefulWidget {
  @override
  _RandomFactsPageState createState() => _RandomFactsPageState();
}

Box introDialogBox;

class _RandomFactsPageState extends State<RandomFactsPage> {
  Box factsBox;
  List<Fact> factList = FactsBank.factList;
  bool isDuplicate;

  Fact savedFact;
  bool isRight = false;

  static Color getRandomColor() {
    RandomColor _randomColor = RandomColor();
    Color _color = _randomColor.randomColor(
        colorSaturation: ColorSaturation.lowSaturation);
    return _color;
  }

  @override
  Widget build(BuildContext context) {
    CardController controller;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.favorite,
          semanticLabel: 'Favourites',
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FavouriteFacts()));
        },
        backgroundColor: Colors.red,
        foregroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 160),
        child: TinderSwapCard(
          orientation: AmassOrientation.BOTTOM,
          totalNum: factList.length,
          stackNum: factList.length - 1,
          swipeEdge: 4.0,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
          maxHeight: MediaQuery.of(context).size.width * 0.9,
          minWidth: MediaQuery.of(context).size.width * 0.8,
          minHeight: MediaQuery.of(context).size.width * 0.8,
          cardBuilder: (context, index) {
            return Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(34),
                  ),
                  color: Color(factList[index].factColor),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        '${factList[index].factText}',
                        maxLines: 3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
          cardController: controller = CardController(),
          swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
            if (align.x < 0) {
              //Card is LEFT swiping
              print("left");
            } else if (align.x > 0) {
              //Card is RIGHT swiping
              isRight = true;
            }
          },
          swipeCompleteCallback:
              (CardSwipeOrientation orientation, int index) async {
            // Get orientation & index of swiped card!
            savedFact = factList[index];
            if (isRight) {}
            isRight = false;
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initializeHive();
    factList.shuffle();
  }

  void initializeHive() async {
    final appDocumentary =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentary.path);
    Hive.registerAdapter(FactAdapter());
    factsBox = await Hive.openBox(factData);
    introDialogBox = await Hive.openBox(introDialog);
//    factsBox.clear();
//    factsBox.add(Fact('dumb', getRandomColor().value));
    if (checkIntroCount()) startUpDialogs();
  }

  void startUpDialogs() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => AssetGiffyDialog(
          title: Text(
            "Swipe right to add card to favourites",
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          image: Image.asset("images/right.gif"),
          onlyOkButton: true,
          onOkButtonPressed: () {
            SchedulerBinding.instance.addPostFrameCallback(
              (_) => showDialog(
                context: context,
                builder: (BuildContext context) => AssetGiffyDialog(
                  title: Text(
                    'Swipe left to go to a new card',
                    style: TextStyle(fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  image: Image.asset("images/left.gif"),
                  onlyOkButton: true,
                  buttonOkText: Text(
                    'Got it',
                    style: TextStyle(fontSize: 26, color: Colors.white),
                  ),
                  onOkButtonPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    );
    introDialogBox.put('intro', 1);
  }

  bool checkIntroCount() => introDialogBox.length == 0 ? true : false;
}
