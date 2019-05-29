import 'package:flutter/material.dart';

class FavMoviesPage extends StatefulWidget {
  @override
  _FavMoviesPageState createState() => _FavMoviesPageState();
}

class _FavMoviesPageState extends State<FavMoviesPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        children: List.generate(100, (index) {
          return Center(
            child: Text(
              'Item $index',
              style: Theme.of(context).textTheme.headline,
            ),
          );
        }),
      ),
    );
  }
}
