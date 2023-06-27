import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makeyourown_songs/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

class AdminPageProvider with ChangeNotifier{

  bool isLoading = false;
  Room room;
  List<Song>? songsHistory;
  List<Tuple3>? currentSongs;
  List<Tuple3>? currentSongsRanked;
  List<Tuple3>? queuedSongs;
  int? selectedSongIndex;
  // bool? didUserVote;
  DateTime? nextDate;
  List<Song> selectedSongs = [];
  String currentTimeLeftString = "...";
  Map<Song, bool>? songsList;
  Map<Song, bool>? songsListFiltered;
  bool? didAdminVote;

  
  AdminPageProvider(this.room){
    getData();
    Timer.periodic(Duration(milliseconds: 1000), (timer) { 
      currentTimeLeftString = nextDate != null 
      ? getETA(nextDate!, DateTime.now().toLocal())
      : "...";
      notifyListeners();
    });
  }

  Future<void> getData() async{
    _loading();

    /// Get songs list
    await FirebaseFirestore.instance.collection('songs').get()
    .then((query) => songsList = query.docs.asMap().map((int, doc) => MapEntry(Song.fromDoc(doc), false)));
    songsListFiltered = Map.from(songsList!);

    /// Get song history
    // var query = await room.ref.collection('song_history').orderBy('date_added', descending: true).snapshots().listen((query) {
    //   songsHistory = query.docs.map((doc) => Song.fromDoc(doc)).take(10).toList();
    // });

    /// Update current songs, elected song and date when document changes
    room.ref.snapshots().listen((doc) async{
      var data = doc.data() as Map<String, dynamic>;
      currentSongs = [
        Tuple3(data['current_songs'][0]['song'], data['current_songs'][0]['artist'], data['vote_count_0']), 
        Tuple3(data['current_songs'][1]['song'], data['current_songs'][1]['artist'], data['vote_count_1']), 
        Tuple3(data['current_songs'][2]['song'], data['current_songs'][2]['artist'], data['vote_count_2']), 
      ];

      queuedSongs = [

      ];

      currentSongsRanked = List.from(currentSongs as Iterable)
      ..sort((prev, next) => next.item3 - prev.item3);

      nextDate = DateTime.fromMillisecondsSinceEpoch(data['next_date'].millisecondsSinceEpoch);

      var lastAdminVoteDate = (await SharedPreferences.getInstance()).getString("last_admin_vote_date");
      if(lastAdminVoteDate.toString() == data['next_date'].millisecondsSinceEpoch.toString()){
        didAdminVote = true;
      }
      else {
        didAdminVote = false;
      }
      
      notifyListeners();
    });

    _loading();
    notifyListeners();
  }

  void filterSongs(String? keyword){
    songsListFiltered = Map.from(songsList!);
    songsListFiltered!.removeWhere((song, selected){
      bool doesNameContain = song.song.toLowerCase().contains(keyword?.toLowerCase() ?? "");
      bool doesArtistContain = song.artist.toLowerCase().contains(keyword?.toLowerCase() ?? "");
      // print("${doesArtistContain} - ${doesNameContain} - ${song.artist} - ${song.song}");
      if(!doesNameContain && !doesArtistContain)
        return true;
      return false;
    });

    notifyListeners();
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


  Future<void> updateSongOptions() async{
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString("last_admin_vote_date", "${nextDate!.millisecondsSinceEpoch}");

    didAdminVote = true;
    print("$didAdminVote update options");

    await room.ref.update(
      {
        "queued_songs": [
          {
            'song': selectedSongs[0].song,
            'artist': selectedSongs[0].artist,
          },
          {
            'song': selectedSongs[1].song,
            'artist': selectedSongs[1].artist,
          },
          {
            'song': selectedSongs[2].song,
            'artist': selectedSongs[2].artist,
          },
        ]
      }
    );

    notifyListeners();
  }

  /// Called whenever a song is SELECTED or DESELECTED
  void updateSelectedSongs(Song song, bool? selected){

    if(selected != null){
      /// Select a song
      if(selected == true ){
        if(selectedSongs.length < 3){
          selectedSongs.add(song);
          songsList?[song] = selected;
          songsListFiltered?[song] = selected;
        }
      }
      /// Deselect a song
      else{
        selectedSongs.remove(song);
        songsList?[song] = selected;
        songsListFiltered?[song] = selected;
      }

    }

    print(selectedSongs);

    notifyListeners();
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}