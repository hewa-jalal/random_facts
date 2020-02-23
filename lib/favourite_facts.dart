import 'package:flutter/material.dart';
import 'package:random_facts/SharedPref.dart';
import 'package:random_facts/facts_bank.dart';

class FavouriteFacts extends StatefulWidget {
  @override
  _FavouriteFactsState createState() => _FavouriteFactsState();
}

class _FavouriteFactsState extends State<FavouriteFacts> {
  SharedPref sharedPref = SharedPref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite List'),
      ),
      body: ListView.builder(
        itemBuilder: (_, index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            child: Card(
              elevation: 10,
              color: FactsBank.favouriteFacts[index].factColor,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    FactsBank.favouriteFacts[index].factText,
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
        itemCount: FactsBank.favouriteFacts.length,
      ),
    );
  }
}
