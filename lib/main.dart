import 'dart:core';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:random_facts/constants.dart';
import 'package:random_facts/facts.dart';

import 'facts.dart';
import 'facts_bank.dart';
import 'favourite_facts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Facts',
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

class _RandomFactsPageState extends State<RandomFactsPage> {
  Box factsBox;
  Box introDialogBox;
  Box displayBox;

  Fact savedFact;

  double opacityForText = 0.0;
  String topText = '';
  @override
  Widget build(BuildContext context) {
    CardController controller;
    if (displayBox == null) {
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
      );
    } else {
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
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 160),
              child: TinderSwapCard(
                orientation: AmassOrientation.BOTTOM,
                totalNum: displayBox.length ?? 0,
                stackNum: 3,
                swipeEdge: 4.0,
                maxWidth: MediaQuery.of(context).size.width * 0.9,
                maxHeight: MediaQuery.of(context).size.width * 0.9,
                minWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: MediaQuery.of(context).size.width * 0.8,
                cardBuilder: (context, index) {
                  return Center(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(34),
                        ),
                        color: Color(displayBox.getAt(index).factColor),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              '${displayBox.getAt(index).factText}',
                              maxLines: 3,
                              style: factTextStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                cardController: controller = CardController(),
                swipeUpdateCallback:
                    (DragUpdateDetails details, Alignment align) {
                  var alignFix = align.x.abs() / 10;
                  // Get swiping card's alignment
                  if (align.x < 0) {
                    setState(() {
                      topText = 'dismiss';
                    });
                    //Card is LEFT swiping
                  } else if (align.x > 0) {
                    //Card is RIGHT swiping
                    setState(() {
                      topText = 'add to favourites';
                    });
                  }
                  setState(() {
                    if (alignFix > 1) alignFix = 1;
                    opacityForText = alignFix;
                  });
                },
                swipeCompleteCallback:
                    (CardSwipeOrientation orientation, int index) async {
                  // Get orientation & index of swiped card!
                  savedFact = displayBox.getAt(index);
                  if (orientation == CardSwipeOrientation.RIGHT) {
                    setState(() {
                      factsBox.add(savedFact);
                      topText = ' ';
                    });
                  } else if (orientation == CardSwipeOrientation.LEFT) {
                    setState(() {
                      displayBox.deleteAt(index);
                      topText = ' ';
                    });
                  } else if (orientation == CardSwipeOrientation.RECOVER) {
                    setState(() {
                      topText = '';
                      opacityForText = 0.0;
                    });
                  }
                },
              ),
            ),
            Positioned(
              left: 90,
              width: 300,
              top: 60,
              child: Opacity(
                opacity: opacityForText,
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    topText,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  void initState() {
    initializeHive();
    super.initState();
//    displayBox.shuffle();
  }

  void initializeHive() async {
    final appDocumentary =
        await path_provider.getApplicationDocumentsDirectory();
    Hive.init(appDocumentary.path);
    Hive.registerAdapter(FactAdapter());
    introDialogBox = await Hive.openBox(introDialog);
    factsBox = await Hive.openBox(factData);
    displayBox = await Hive.openBox(displayBoxName);
    setState(() {
      if (displayBox.length == 0) {
        FactsBank.addBox();
        print('stuff added');
      }
    });
    if (checkIntroCount()) startUpDialogs();
  }

  void startUpDialogs() {
    SchedulerBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => AssetGiffyDialog(
          title: Text(
            'Swipe right to add card to favourites',
            style: TextStyle(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          image: Image.asset('images/right.gif'),
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
                  image: Image.asset('images/left.gif'),
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
