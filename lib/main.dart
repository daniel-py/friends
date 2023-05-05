import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_friend_screen.dart';
import './screens/home_screen.dart';
import './screens/friend_detail_screen.dart';
import './utils/theme/theme.dart';
import './providers/friends.dart';
import './services/notification_service.dart';
import './screens/birthday_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Friends(),
      child: MaterialApp(
        title: 'My Friends',
        theme: MyAppTheme.lightTheme,
        darkTheme: MyAppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: HomeScreen(),
        routes: {
          FriendDetailScreen.routeName: (_) => FriendDetailScreen(),
          EditFriendScreen.routeName: (_) => EditFriendScreen(),
        },
      ),
    );
  }
}

// class AppHome extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       //backgroundColor: Theme.of(context).backgroundColor,
//       appBar: AppBar(
//         title: Text('./appable'),
//         leading: Icon(Icons.ondemand_video),
//       ),
//       floatingActionButton: FloatingActionButton(
//           onPressed: (() {}), child: Icon(Icons.add_shopping_cart)),
//       body: Padding(
//           padding: EdgeInsets.all(20),
//           child: ListView(
//             children: [
//               Text(
//                 'Heading',
//                 style: Theme.of(context).textTheme.headline2,
//               ),
//               Text(
//                 'Sub-Heading',
//                 style: Theme.of(context).textTheme.subtitle1,
//               ),
//               Text(
//                 'Paragraph',
//                 style: Theme.of(context).textTheme.bodyText1,
//               ),
//               ElevatedButton(onPressed: () {}, child: Text('Elevated Button')),
//               OutlinedButton(onPressed: () {}, child: Text('Outlined Button')),
//               Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Image(
//                   image: AssetImage('assets/images/img3.jpg'),
//                 ),
//               )
//             ],
//           )),
//     );
//   }
// }
