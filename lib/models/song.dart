import 'package:cloud_firestore/cloud_firestore.dart';

class Song{
  String song;
  String artist;
  DateTime dateAdded;

  Song({required this.song, required this.artist, required this.dateAdded});

  static Song fromDoc(DocumentSnapshot doc){
    var data = doc.data() as Map<String, dynamic>;
    return Song(
      song: data['song'],
      artist: data['artist'],
      dateAdded: data['date_added'] != null ? DateTime.fromMillisecondsSinceEpoch(data['date_added'].millisecondsSinceEpoch) : DateTime.now().toLocal()
    );
  }
}