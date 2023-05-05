import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/friend.dart';
import '../helpers/db_helper.dart';
import '../services/notification_service.dart';

class Friends with ChangeNotifier {
  List<Friend> _friends = [
    // Friend(
    //   id: 'i1',
    //   name: 'Friend 1',
    //   rating: 3,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/237/500/400',
    // ),
    // Friend(
    //   id: 'i2',
    //   name: 'Friend 2',
    //   rating: 4,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/238/500/400',
    // ),
    // Friend(
    //   id: 'i3',
    //   name: 'Friend 3',
    //   rating: 5,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/239/500/400',
    // ),
    // Friend(
    //   id: 'i4',
    //   name: 'Friend 4',
    //   rating: 2,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/240/500/400',
    // ),
    // Friend(
    //   id: 'i5',
    //   name: 'Friend 5',
    //   rating: 5,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/241/500/400',
    // ),
    // Friend(
    //   id: 'i6',
    //   name: 'Friend 6',
    //   rating: 4,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/242/500/400',
    // ),
    // Friend(
    //   id: 'i7',
    //   name: 'Friend 7',
    //   rating: 1,
    //   about:
    //       'Nulla facilisi. Maecenas consectetur dapibus enim, quis semper metus vehicula ac. Donec eu nibh dignissim, faucibus lectus vitae, mattis risus. Pellentesque et pulvinar mauris. Suspendisse placerat dui vitae semper porttitor. Duis tempus diam sed euismod mattis. Nam tincidunt sapien quam, eget condimentum mauris dignissim eget. Curabitur ornare convallis nunc, vitae convallis felis vulputate nec. Duis ut aliquam sapien. Morbi consectetur congue eros ac suscipit. Vivamus euismod, ante in aliquet interdum.',
    //   imageUrl: 'https://picsum.photos/id/243/500/400',
    // )
  ];

  List<Friend> get friends {
    var friend = _friends;
    friend.sort((a, b) => b.rating.compareTo(a.rating));
    return friend;
  }

  Friend searchById(id) {
    return _friends.firstWhere(
      (friend) => friend.id == id,
      orElse: () => Friend(
          id: '',
          name: '',
          about: '',
          image: null,
          rating: 0,
          wNumber: '',
          birthDay: ''),
    );
  }

  Future<void> loadAndSetFriends() async {
    final friendList = await DBHelper.getData('friends_table');

    _friends = friendList
        .map((friend) => Friend(
              id: friend['id'],
              name: friend['name'],
              about: friend['about'],
              image: File(friend['image']),
              rating: friend['rating'],
              wNumber: friend['wNumber'],
              birthDay: friend['birthDay'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addFriend(Friend friend, File image) async {
    String formattedNumber = '234${friend.wNumber}';

    final newFriend = Friend(
      id: Random().nextInt(9999).toString(),
      //DateTime.now().toIso8601String(),
      // _friends.isEmpty
      //     ? 'i1'
      //     : 'i${int.parse(_friends[_friends.length - 1].id.substring(1)) + 1}',
      name: friend.name,
      about: friend.about,
      image: image,
      rating: friend.rating,
      wNumber: formattedNumber,
      birthDay: friend.birthDay,
    );

    _friends.add(newFriend);
    notifyListeners();

    print(newFriend.id);

    DBHelper.insert('friends_table', {
      'id': newFriend.id,
      'name': newFriend.name,
      'about': newFriend.about,
      'rating': newFriend.rating,
      'image': newFriend.image!.path,
      'wNumber': newFriend.wNumber,
      'birthDay': newFriend.birthDay,
    });

    NotificationService.createScheduledNotification(
      friendName: newFriend.name,
      friendId: newFriend.id,
      friendBirthday: newFriend.birthDay,
      title: 'It\'s ${newFriend.name}\'s Birthday!',
      body: 'Today is ${newFriend.name}\'s Birthday! Wish them now!',
      imagePath: newFriend.image!.path,
    );
    print(_friends);
  }

  void editFriend(Friend editedFriend, File image) {
    final existingFriendIndex =
        _friends.indexWhere((friend) => friend.id == editedFriend.id);

    String formattedNumber = '234${editedFriend.wNumber}';

    _friends[existingFriendIndex] = Friend(
      id: editedFriend.id,
      name: editedFriend.name,
      about: editedFriend.about,
      image: image,
      rating: editedFriend.rating,
      wNumber: formattedNumber,
      birthDay: editedFriend.birthDay,
    );
    notifyListeners();

    DBHelper.update('friends_table', {
      'id': _friends[existingFriendIndex].id,
      'name': _friends[existingFriendIndex].name,
      'about': _friends[existingFriendIndex].about,
      'rating': _friends[existingFriendIndex].rating,
      'image': _friends[existingFriendIndex].image!.path,
      'wNumber': _friends[existingFriendIndex].wNumber,
      'birthDay': _friends[existingFriendIndex].birthDay,
    });

    NotificationService.updateScheduledNotification(
      friendName: _friends[existingFriendIndex].name,
      friendId: _friends[existingFriendIndex].id,
      friendBirthday: _friends[existingFriendIndex].birthDay,
      title: 'It\'s ${_friends[existingFriendIndex].name}\'s Birthday!',
      body:
          'Today is ${_friends[existingFriendIndex].name}\'s Birthday! Wish them now!',
      imagePath: _friends[existingFriendIndex].image!.path,
    );
  }

  Future<void> deleteFriend(String id) async {
    final existingFriendIndex =
        _friends.indexWhere((friend) => friend.id == id);
    _friends.removeAt(existingFriendIndex);
    notifyListeners();

    DBHelper.delete('friends_table', id);
    NotificationService.cancelScheduledNotification(id);
  }
}
