import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:makeyourown_songs/screens/home/home_page.dart';
import 'package:makeyourown_songs/screens/home/home_provider.dart';

import 'config/config.dart';

void main() async{
  await config();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Craft Party',
      theme: theme(context),
      home: ChangeNotifierProvider(
        create: (_) => HomePageProvider(),
        child: HomePage()
      ),
    );
  }
}

Future<void> config() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // await createRoom();

//   try {
//     try {
//       String fileContents = await rootBundle.loadString('assets/playlist2.txt');
    
//       List<String> songs = fileContents.split('\n');

//       // print('File contents:\n$songs');

//       songs.forEach((song) {
//         var name = song.substring(0, song.indexOf('(') == -1 ? song.indexOf(' -') : song.indexOf('('));
//         var artist = song.substring(song.indexOf('- ') + 2, song.length);
//         print(name);
// print(artist);
//         FirebaseFirestore.instance.collection('songs').add(
//           {
//             "artist" : artist,
//             "song": name
//           }
//         );
        
//       });
    
    
//     } catch (e) {
//       print('Error reading file: $e');
//     }
//     } catch (e) {
//       print('Error reading file: $e');
//   }




}

createRoom() async{

  FirebaseFirestore.instance.collection('rooms')
  .doc('1111')
  .set(
    {
      "active": true,
      "queued_songs": [
        {
          "song": "a",
          "artist": "b"
        },
        {
          "song": "a",
          "artist": "b"
        },
        {
          "song": "a",
          "artist": "b"
        },
      ],
      "current_songs": [
        {
          "song": "a",
          "artist": "b"
        },
        {
          "song": "a",
          "artist": "b"
        },
        {
          "song": "a",
          "artist": "b"
        },
      ],
      "vote_count_0": 0,
      "vote_count_1": 0,
      "vote_count_2": 0,
      "name": "TikTok Party",
      "last_elected_song": {
        "song": "a",
        "artist": "b"
      }
    },
    SetOptions(merge: true)
  );

}