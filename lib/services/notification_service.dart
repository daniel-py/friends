import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

import '../main.dart';
import '../screens/birthday_screen.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notification',
          channelDescription: 'Birthday notification for friends',
          defaultColor: Color(0xE69C1111),
          importance: NotificationImportance.Max,
          playSound: true,
        )
      ],
      //debug: true,
    );

    await AwesomeNotifications()
        .isNotificationAllowed()
        .then((isAllowed) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    //await
    AwesomeNotifications().createdStream.listen((receivedNotification) {
      print('NotificationCreatedMethod');
    });

    // AwesomeNotifications().actionStream.listen((receivedAction) {
    //   print('He has tapped on wish friend o');
    //   final payload = receivedAction.payload; //?? {};
    //   print(receivedAction.payload);
    //   if (payload!['navigate'] == 'true') {
    //     print(
    //         'I have reveived the payload o. It is the material pageroute thing that is not working');
    //     MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
    //       builder: (_) => BirthdayScreen(payload['id']!),
    //       //ACCEPT THE FRIEND ID SOMEWAY OR CREATE THIS IN THE INIT STATE OF THE ADD FRIEND FUNCTION
    //     )); //////////////////////// MAYBE SEND THE FRIEND ID IN THE PAYLOAD OF THE NOTIFICATION
    //     //   Navigator.pushAndRemoveUntil(
    //     //       MyApp.navigatorKey.currentContext!,
    //     //       MaterialPageRoute(
    //     //         builder: (_) => BirthdayScreen(payload['id']!),
    //     //       ),
    //     //       (route) => route.isFirst);
    //   }
    // });
  }

  static Map<String, int> monthMap = {
    'Jan': 1,
    'Feb': 2,
    'Mar': 3,
    'Apr': 4,
    'May': 5,
    'Jun': 6,
    'Jul': 7,
    'Aug': 8,
    'Sep': 9,
    'Oct': 10,
    'Nov': 11,
    'Dec': 12,
  };

  static Future<void> createScheduledNotification({
    required final String friendName,
    required final String friendId,
    required final String friendBirthday,
    required final String title,
    required final String body,
    required final String imagePath,
    //final Map<String, String>? payload, //{'navigate': 'true'}
  }) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: int.parse(friendId),
          channelKey: 'scheduled_channel',
          title: title,
          body: body,
          notificationLayout: NotificationLayout.BigPicture,
          payload: {
            'navigate': 'true',
            'id': friendId,
          },
          bigPicture: 'file://$imagePath',
        ),
        actionButtons: [
          NotificationActionButton(
              key: 'Wish $friendName', label: 'Wish $friendName'),
        ],
        schedule: NotificationCalendar(
          month: NotificationService.monthMap[friendBirthday.split(' ')[0]],
          day: int.parse(friendBirthday.split(' ')[1]),
          //COLLECT THE BIRTH DAY OF THE FRIEND AND MAKE A MAP SETTING EACH month OF THE year TO 1 - 12 or just edit the dateformat method
          hour: 0,
          minute: 05,
          second: 00,
          millisecond: 0,
          allowWhileIdle: true,
          repeats: true,
        ));
  }

  static Future<void> cancelScheduledNotification(String friendId) async {
    await AwesomeNotifications().cancelSchedule(int.parse(friendId));
  }

  static Future<void> updateScheduledNotification({
    required final String friendName,
    required final String friendId,
    required final String friendBirthday,
    required final String title,
    required final String body,
    required final String imagePath,
  }) async {
    await NotificationService.cancelScheduledNotification(friendId);
    await NotificationService.createScheduledNotification(
      friendName: friendName,
      friendId: friendId,
      friendBirthday: friendBirthday,
      title: title,
      body: body,
      imagePath: imagePath,
    );
  }
}
