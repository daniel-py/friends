import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/friends.dart';

class BirthdayScreen extends StatelessWidget {
  //const MyWidget({super.key});
  String friendId;

  List wishes = [
    "Birthday gifts are always fun to get. But I hope this year brings you a wealth of opportunities: opportunities to laugh, smile, and be happy. Happy Birthday!",
    "For your birthday I'm going to share the secret with you. My secret to staying young is... lie about your age. You're welcome and Happy Birthday.",
    "Happy Birthday to someone who's good-looking, incredibly smart, generous beyond belief, and charming. Oh, wait - I meant from someone.",
    "I tried to come up with something profound and wonderful to say. But, I then realized that all I needed to say was how much I love and care about you. So, I'm wishing you the happiest birthday!",
    "Don't worry about the past. You can't change it. Don't worry about the future. You can't predict it. Try not to worry about the present because I didn't get you one. Love you, Happy Birthday.",
    "Great friends are hard to find, so I feel really lucky to have found you. Happy birthday!",
    "If your birthday ends up being at least half as amazing as you are, it's going to be one fantastic birthday. Happy birthday.",
    "Wishing you a most wonderful birthday. May it be filled with love and presents!",
    "In this world, where everything seems uncertain, only one thing is definite. You'll always be my friend, beyond words, beyond time and beyond distance.",
    "We know we're getting old when the only thing we want for our birthday is not to be reminded of it.",
    "May this year be the best of your life, until the next one. Happy birthday!",
    "Happy birthday to a person who is smart, good looking, and funny and reminds me a lot of myself.",
    "Whatever your dreams, whether big or small, may this year be the year in which you have them all fulfilled.",
    "You're a friend who I can trust to always be loyal and true and there is no greater friendship than the one I share with you. Wishing my special friend the best birthday ever.",
    "You're weird. Don't change. Happy birthday.",
    "Wishing you many more candles to come. Happy birthday.",
    "I am a better person by knowing you. Thank you for sharing your wisdom with me and I just want to say happy birthday to a wonderful person.",
    "It is a fact that too many birthdays will kill you.",
    "Thank you for always just being you. Happy birthday.",
    "Want to know how to keep an old guy in suspense on his birthday? I'll tell you later.",
    "Happy birthday, and may all the wishes and dreams you dream today turn to reality.",
    "I hope that your birthday is as wonderful as you are.",
    "Hope your birthday blossoms into lots of dreams come true.",
    "Wishing you many bright and happy days throughout this upcoming new year. Happy birthday.",
    "A lot of things get better with the years... and you are one of them.",
    "It takes only a few seconds to say I love you but it will take me an entire lifetime to show you how much.",
    "May the best of your wishes be the least of what you get.",
    "Remember, you'll be this age for only one year but you'll be awesome forever.",
    "May the best of your past be the worst of your future. Wishing that this is your best birthday yet.",
    "Another year is added, but also another opportunity for growth and experience.",
    "Happy birthday\nYou are very special\nAnd you deserve the best\nI wish you a wonderful life\nFilled with love and happiness",
    "Many things have changed over the years but you're still the same great person you always have been.",
    "I hope that you're my friend forever because that's how long I'm going to need you.",
    "Now you're one year older. A bit of a grump. I just want you to know that I still care for you the same.",
    "On your birthday lots of people are thinking of you. I just wanted to let you know that I am one of them.",
    "Next to you is one of my favorite places to be. Happy birthday.",
    "Not just a year older, but a year better.",
  ];

  BirthdayScreen(this.friendId);

  @override
  Widget build(BuildContext context) {
    final loadedFriend = Provider.of<Friends>(context).searchById(friendId);
    return Scaffold(
      appBar: AppBar(title: Text('${loadedFriend.name}\'s Birthday!')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 115,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: CircleAvatar(
              radius: 110,
              backgroundImage: FileImage(loadedFriend.image!),
              // child: Image.file(
              //   loadedFriend.image!,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Center(
                child: Text(
              'Tap the button below to send ${loadedFriend.name} a random birthday wish on Whatsapp!',
              textAlign: TextAlign.center,
            )),
          ),
          Link(
            uri: Uri.parse(
                'https://wa.me/${loadedFriend.wNumber}?text=${wishes[Random().nextInt(wishes.length)].replaceAll(' ', '%20').replaceAll('. ', '%0A')}'),
            target: LinkTarget.blank,
            builder: (context, followLink) => Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton.icon(
                  onPressed: followLink,
                  icon: FaIcon(FontAwesomeIcons.whatsapp),
                  label: Text('Send Random Wish')),
            ),
          ),
        ],
      ),
    );
  }
}
