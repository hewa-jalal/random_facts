import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:random_facts/constants.dart';

import 'facts.dart';

class FavouriteFacts extends StatefulWidget {
  @override
  _FavouriteFactsState createState() => _FavouriteFactsState();
}

class _FavouriteFactsState extends State<FavouriteFacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite List'),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          final fact = Hive.box(factData).getAt(index) as Fact;
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            child: Card(
              elevation: 10,
              color: Color(fact.factColor),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    fact.factText,
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: Hive.box(factData).length,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
