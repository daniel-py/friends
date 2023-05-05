import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int rating;
  final Color color;
  const StarRating(this.rating, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
          5,
          (index) => Icon(
                index < rating ? Icons.star : Icons.star_border,
                color: color,
              )),
    );
  }
}

// class StarDisplay extends StatelessWidget {
//   final int value;
//   const StarDisplay({Key key, this.value = 0})
//       : assert(value != null),
//         super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: List.generate(5, (index) {
//         return Icon(
//           index < value ? Icons.star : Icons.star_border,
//         );
//       }),
//     );
//   }
// }
