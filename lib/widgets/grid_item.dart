import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/star_rating.dart';
import '../screens/friend_detail_screen.dart';
import '../models/friend.dart';

class GridItem extends StatelessWidget {
  const GridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final item = Provider.of<Friend>(context);
    return GestureDetector(
      onTap: () => Navigator.of(context)
          .pushNamed(FriendDetailScreen.routeName, arguments: item.id),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: item.id,
              child: Image.file(
                item.image!,
                fit: BoxFit.cover,
                height: 170,
                width: 160,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              item.name,
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(1),
            child: StarRating(item.rating, Colors.amber),
          )
        ],
      ),
    );
  }
}

// class listtile extends StatelessWidget {
//   const listtile({
//     Key? key,
//     required this.item,
//   }) : super(key: key);

//   final Friend item;

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       onTap: () => Navigator.of(context)
//           .pushNamed(ItemDetailScreen.routeName, arguments: item.id),
//       leading: Hero(
//         tag: item.id,
//         child: CircleAvatar(
//             radius: 22.0,
//             backgroundImage: NetworkImage(
//               item.imageUrl,
//             )),
//       ),
//       title: Text(
//         item.name,
//         style: Theme.of(context).textTheme.subtitle1,
//       ),
//     );
//   }
// }
