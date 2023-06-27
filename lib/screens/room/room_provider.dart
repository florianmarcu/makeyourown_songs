import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makeyourown_songs/models/models.dart';
import 'package:makeyourown_songs/models/song.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class RoomPageProvider with ChangeNotifier{
  bool isLoading = false;
  Room room;
  List<Song>? songsHistory;
  List<Tuple3>? currentSongs;
  List<Tuple3>? currentSongsRanked;
  int? selectedSongIndex;
  bool? didUserVote;
  DateTime? nextDate;
  DateTime? lastElectedDate;
  String currentTimeLeftString = "...";

  RoomPageProvider(this.room){
    getData();
    Timer.periodic(Duration(milliseconds: 1000), (timer) {
      currentTimeLeftString = nextDate != null 
      ? getETA(nextDate!, DateTime.now().toLocal())
      : "...";
      notifyListeners();
    });
  }

  String getETA(DateTime nextTime, DateTime now){
    return nextTime.difference(now).inMinutes / 60 > 1
    ? ( // hours
      (nextTime.difference(now).inMinutes / 60).round() > 9 
        ? "${(nextTime.difference(now).inMinutes / 60).round()} :" 
        : "0${(nextTime.difference(now).inMinutes / 60).round()} :"
      ) + 
      ( // minutes
      (nextTime.difference(now).inMinutes % 60).round() > 9 
        ? "${(nextTime.difference(now).inMinutes % 60).round()} :" 
        : "0${(nextTime.difference(now).inMinutes % 60).round()} :"
      ) + 
      ( // seconds
        nextTime.difference(now).inSeconds % 60 > 9 
        ? "${nextTime.difference(now).inSeconds % 60 }" 
        : "0${nextTime.difference(now).inSeconds % 60 }"
      )
    : ( // minutes
      (nextTime.difference(now).inMinutes % 60).round() > 9 
        ? "${(nextTime.difference(now).inMinutes % 60).round()} :" 
        : "0${(nextTime.difference(now).inMinutes % 60).round()} :"
      ) + 
      ( // seconds
        nextTime.difference(now).inSeconds % 60 > 9 
        ? "${nextTime.difference(now).inSeconds % 60 }" 
        : "0${nextTime.difference(now).inSeconds % 60 }"
      );
  }

  Future<void> getData() async{
    _loading();

    /// Get song history
    var query = await room.ref.collection('song_history').orderBy('date_added', descending: true).snapshots().listen((query) {
      songsHistory = query.docs.map((doc) => Song.fromDoc(doc)).take(10).toList();
    });

    /// Update current songs, elected song and date when document changes
    room.ref.snapshots().listen((doc) async{
      var data = doc.data() as Map<String, dynamic>;
      currentSongs = [
        Tuple3(data['current_songs'][0]['song'], data['current_songs'][0]['artist'], data['vote_count_0']), 
        Tuple3(data['current_songs'][1]['song'], data['current_songs'][1]['artist'], data['vote_count_1']), 
        Tuple3(data['current_songs'][2]['song'], data['current_songs'][2]['artist'], data['vote_count_2']), 
      ];

      currentSongsRanked = List.from(currentSongs as Iterable)
      ..sort((prev, next) => next.item3 - prev.item3);

      nextDate = DateTime.fromMillisecondsSinceEpoch(data['next_date'].millisecondsSinceEpoch);
      lastElectedDate = DateTime.fromMillisecondsSinceEpoch(data['next_date'].millisecondsSinceEpoch);

      var lastUserVoteDate = (await SharedPreferences.getInstance()).getString("last_user_vote_date");
      if(lastUserVoteDate == lastElectedDate?.millisecondsSinceEpoch.toString())
        didUserVote = true;
      else didUserVote = false;

      notifyListeners();
    });
    // await room.ref..get().then((doc) {
    //   var data = doc.data() as Map<String, dynamic>;
    //   currentSongs = Tuple3(
    //     Tuple3(data['current_songs'][0]['song'], data['current_songs'][0]['artist'], data['current_songs'][0]['vote_count']), 
    //     Tuple3(data['current_songs'][1]['song'], data['current_songs'][1]['artist'], data['current_songs'][1]['vote_count']), 
    //     Tuple3(data['current_songs'][2]['song'], data['current_songs'][2]['artist'], data['current_songs'][2]['vote_count']), 
    //   );
    // });
    _loading();
    notifyListeners();
  }

  void selectSong(int index){
    selectedSongIndex = index;
    
    notifyListeners();
  }

  void voteSong() async{
    try{
      await room.ref.set(
        {
          "vote_count_$selectedSongIndex": FieldValue.increment(1)
        },
        SetOptions(merge: true)
      ).then((value) => updateUserVotingStatus());
    }
    catch(e){
      print(e);
    }
  }
  
  void updateUserVotingStatus() async{
    if(nextDate != null){
      var sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("last_user_vote_date", "${lastElectedDate!.millisecondsSinceEpoch}");
      didUserVote = true;
    }
    
    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}