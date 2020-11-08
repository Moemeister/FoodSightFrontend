import 'package:flutter/material.dart';

class StarRate extends StatelessWidget {
  final int value;

  const StarRate({
    Key key,
    this.value = 0,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Container(
            padding: EdgeInsets.all(10),
            child: Icon(
              index < value ? Icons.star : Icons.star_border,
              color: index < value
                  ? Theme.of(context).accentColor
                  : Theme.of(context).primaryColorLight,
            ));
      }),
    );
  }
}
