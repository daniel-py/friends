//import 'dart:io';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../screens/home_screen.dart';
import '../providers/friends.dart';
import '../utils/theme/theme.dart';
import '../screens/edit_friend_screen.dart';

import '../widgets/star_rating.dart';

class FriendDetailScreen extends StatelessWidget {
  const FriendDetailScreen({super.key});

  static const routeName = '/item-detail';

//////////MAYBE USE LIST TILES FOR THE BODY?
  ///
  ///
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)?.settings.arguments;
    final loadedFriend = Provider.of<Friends>(context).searchById(itemId);
    Future<PaletteGenerator> getImagePalette(
        ImageProvider imageProvider) async {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(imageProvider);
      return paletteGenerator;
    }

    // Color lighten(Color color, [double amount = .1]) {
    //   assert(amount >= 0 && amount <= 1);

    //   final hsl = HSLColor.fromColor(color);
    //   final hslLight =
    //       hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    //   return hslLight.toColor();
    // }

    return Scaffold(
      backgroundColor: MyAppTheme.lightTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditFriendScreen.routeName,
                        arguments: loadedFriend.id);
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () async {
                    bool result = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) {
                        return AlertDialog(
                          title: const Text('Delete this friend?'),
                          content: const Text('This action cannot be undone.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                                child: const Text('No')),
                            ElevatedButton(
                                onPressed: () async {
                                  Navigator.of(context).pop(true);
                                  await Provider.of<Friends>(context,
                                          listen: false)
                                      .deleteFriend(loadedFriend.id);
                                  // Navigator.of(context).pushReplacement(
                                  //     MaterialPageRoute(
                                  //         builder: (context) => HomeScreen()));
                                },
                                child: const Text('Yes'))
                          ],
                        );
                      },
                    );
                    if (result == true) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.delete)),
            ],
            //floating: true,
            //title: Text(loadedFriend.name),
            flexibleSpace: LayoutBuilder(
              builder: (ctx, cons) => FlexibleSpaceBar(
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: cons.biggest.height <= 130 ? 1.0 : 0.0,
                  child: Text(
                    loadedFriend.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                background: Hero(
                  tag: loadedFriend.id,
                  child: Image.file(
                    loadedFriend.image ?? File(''),
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text(
                        'Image not found',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                loadedFriend.name,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.leaderboard),
              title: StarRating(loadedFriend.rating, Colors.black
                  // snapshot.data?.dominantColor?.color ??
                  //     Theme.of(context).colorScheme.primary,
                  ),
            ),
            // Link(
            //   uri: Uri.parse('https://wa.me/${loadedFriend.wNumber}'),
            //   target: LinkTarget.blank,
            //   builder: (context, followLink) => ListTile(
            //     leading: InkWell(
            //       child: const FaIcon(FontAwesomeIcons.whatsapp),
            //       onTap: followLink,
            //     ),
            //     title: InkWell(
            //         child: Text(
            //           '+${loadedFriend.wNumber}',
            //           style: Theme.of(context).textTheme.bodyText2,
            //         ),
            //         onTap: followLink),
            //   ),
            // ),
            ListTile(
              leading: InkWell(
                child: const FaIcon(FontAwesomeIcons.whatsapp),
                onTap: () async {
                  final whatsappUrl =
                      Uri.parse('https://wa.me/${loadedFriend.wNumber}');

                  if (await canLaunchUrl(whatsappUrl)) {
                    launchUrl(whatsappUrl,
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
              title: InkWell(
                child: Text(
                  '+${loadedFriend.wNumber}',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                onTap: () async {
                  final whatsappUrl =
                      Uri.parse('https://wa.me/${loadedFriend.wNumber}');

                  if (await canLaunchUrl(whatsappUrl)) {
                    launchUrl(whatsappUrl,
                        mode: LaunchMode.externalApplication);
                  }
                },
              ),
            ),

            ListTile(
              leading: const Icon(Icons.cake),
              title: Text(
                loadedFriend.birthDay,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: Text(
                loadedFriend.about,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ]))
        ],
      ),
    );
  }
}



// FutureBuilder(
//       future: getImagePalette(FileImage(loadedFriend.image!.path)),
//       builder: (ctx, snapshot) => snapshot.connectionState ==
//               ConnectionState.waiting
//           ? const Scaffold(
//               body: Center(child: CircularProgressIndicator()),
//             )
//           : Scaffold(
//               backgroundColor:
//                   snapshot.data?.lightMutedColor?.color ?? Colors.white,
//               body: CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     expandedHeight: 400,
//                     pinned: true,
//                     backgroundColor: snapshot.data?.dominantColor?.color ??
//                         Theme.of(context).colorScheme.primary,
//                     foregroundColor:
//                         snapshot.data?.lightMutedColor?.color ?? Colors.white,
//                     actions: [
//                       IconButton(
//                           onPressed: () {
//                             Navigator.of(context).pushNamed(
//                                 EditFriendScreen.routeName,
//                                 arguments: loadedFriend.id);
//                           },
//                           icon: Icon(Icons.edit)),
//                       IconButton(
//                           onPressed: () async {
//                             bool result = await showDialog(
//                               context: context,
//                               barrierDismissible: false,
//                               builder: (_) {
//                                 return AlertDialog(
//                                   title: Text('Delete this friend?'),
//                                   content:
//                                       Text('This action cannot be undone.'),
//                                   actions: [
//                                     TextButton(
//                                         onPressed: () {
//                                           Navigator.of(context).pop(false);
//                                         },
//                                         child: Text('No')),
//                                     ElevatedButton(
//                                         onPressed: () {
//                                           Provider.of<Friends>(context,
//                                                   listen: false)
//                                               .deleteFriend(loadedFriend.id);
//                                           Navigator.of(context).pop(true);
//                                         },
//                                         child: Text('Yes'))
//                                   ],
//                                 );
//                               },
//                             );
//                             if (result == true) {
//                               Navigator.of(context).pop();
//                             }
//                           },
//                           icon: Icon(Icons.delete)),
//                     ],
//                     //floating: true,
//                     //title: Text(loadedFriend.name),
//                     flexibleSpace: LayoutBuilder(
//                       builder: (ctx, cons) => FlexibleSpaceBar(
//                         title: AnimatedOpacity(
//                           duration: Duration(milliseconds: 200),
//                           opacity: cons.biggest.height <= 130 ? 1.0 : 0.0,
//                           child: Text(
//                             loadedFriend.name,
//                             style: TextStyle(
//                                 color: snapshot.data?.lightMutedColor?.color ??
//                                     Colors.white),
//                           ),
//                         ),
//                         background: Hero(
//                           tag: loadedFriend.id,
//                           child: Image.file(
//                             loadedFriend.image!,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SliverList(
//                       delegate: SliverChildListDelegate([
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           vertical: 0, horizontal: 0), //15, 12
//                       child: ListTile(
//                         leading: Icon(Icons.person),
//                         title: Text(
//                           loadedFriend.name,
//                           style: Theme.of(context).textTheme.headline2,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(0), //12
//                       child: ListTile(
//                         leading: Icon(Icons.leaderboard),
//                         title: StarRating(loadedFriend.rating, Colors.black
//                             // snapshot.data?.dominantColor?.color ??
//                             //     Theme.of(context).colorScheme.primary,
//                             ),
//                       ),
//                     ),
//                     Padding(
//                       padding: EdgeInsets.all(0),
//                       child: ListTile(
//                         leading: Icon(Icons.rate_review_outlined),
//                         title: Text(
//                           loadedFriend.about,
//                           style: Theme.of(context).textTheme.bodyText2,
//                           textAlign: TextAlign.justify,
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 10,
//                     )
//                   ]))
//                 ],
//               ),
//             ),
//     );