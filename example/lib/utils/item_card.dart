import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final int index;
  const ItemCard({super.key,required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      width: 100,
      child: Card(
        color: Colors.primaries[index % Colors.primaries.length],
        child: Center(
          child: Text(
            (index + 1).toString(),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
      ),
    );
  }
}
