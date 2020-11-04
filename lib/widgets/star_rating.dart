import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final void Function(int index) onChanged;
  final int value;

  const StarRating({
    Key key,
    this.value = 0,
    this.onChanged,
  })  : assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: onChanged != null
              ? () {
                  onChanged(value == index + 1 ? index : index + 1);
                }
              : null,
          icon: Icon(index < value ? Icons.star : Icons.star_border),
          color: index < value
              ? Theme.of(context).primaryColor
              : Theme.of(context).primaryColorLight,
          padding: EdgeInsets.zero,
          tooltip: "${index + 1} of 5",
        );
      }),
    );
  }
}
