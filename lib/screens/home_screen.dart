import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import '../utils/theme/theme.dart';
import '../screens/birthday_screen.dart';
//import 'friend_detail_screen.dart';
import '../providers/friends.dart';
import '../widgets/grid_item.dart';
import '../screens/edit_friend_screen.dart';

//////GIVE THE BACKGROOUND A LIGHT SHADE OF BLUE PERHAPS?

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    AwesomeNotifications().actionStream.listen((receivedAction) {
      print('He has tapped on wish friend o');
      final payload = receivedAction.payload; //?? {};
      print(receivedAction.payload);
      if (payload!['navigate'] == 'true') {
        print(
            'I have reveived the payload o. It is the material pageroute thing that is not working');
        // MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
        //   builder: (_) => BirthdayScreen(payload['id']!),
        // ));
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => BirthdayScreen(payload['id']!),
            ),
            (route) => route.isFirst);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var loadedFriends = Provider.of<Friends>(context).friends;
    return Scaffold(
      backgroundColor: MyAppTheme.lightTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Friends',
          style: Theme.of(context).textTheme.headline1,
        ),
        // SizedBox(
        //   height: 50,
        //   child: Image.asset('assets/icons/friends_icon.png'),
        // ),
        toolbarHeight: 70,
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   statusBarColor: Color.fromARGB(199, 126, 5, 29),
        //   statusBarIconBrightness: Brightness.light,
        // ),

        // title: const Text(
        //   'Friends',
        //   //style: TextStyle(fontSize: 23),
        // ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        //shadowColor: Theme.of(context).colorScheme.primary,
        //centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/icons/friends_icon3.png'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (_) => BirthdayScreen('2023-04-14T03:35:40.862843'),
            // )),
            Navigator.of(context).pushNamed(EditFriendScreen.routeName),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          //topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        )),
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
      body: FutureBuilder(
          future:
              Provider.of<Friends>(context, listen: false).loadAndSetFriends(),
          builder: (_, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Consumer<Friends>(
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(
                          child: Text(
                            'You have not added any friend yet. Tap the \'+\' button to add some now.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      builder: (_, friends, ch) => friends.friends.isEmpty
                          ? ch!
                          : GridView.builder(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisExtent: 226,
                                crossAxisCount: 2,
                                childAspectRatio: 0.80,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: friends.friends.length,
                              itemBuilder: ((_, index) =>
                                  ChangeNotifierProvider.value(
                                    value: friends.friends[index],
                                    child: const GridItem(),
                                  ))),
                    )),
    );
  }
}
