import 'package:flutter/material.dart';
import 'package:makeyourown_songs/screens/home/home_provider.dart';
import 'package:makeyourown_songs/screens/room/room_provider.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<RoomPageProvider>();
    var room = provider.room;
    var currentSongsRanked = provider.currentSongsRanked;
    var currentSongs = provider.currentSongs;
    var songsHistory = provider.songsHistory;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("${room.name}", textAlign: TextAlign.center,),
            Text("Room ${room.id}", style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center,)
          ],
        ),
      ),
      body: Builder(
        builder: (context) {
          if(provider.isLoading){
            return SizedBox.expand(
              child: Container(
              alignment: Alignment.bottomCenter,
              height: 5,
              width: MediaQuery.of(context).size.width,
              child: LinearProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.secondary), backgroundColor: Colors.transparent,)
            ), 
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
            child: ListView(
              children: [
                Center(
                  child: Text("${provider.currentTimeLeftString}", style: Theme.of(context).textTheme.headlineMedium,),
                ),
                SizedBox(height: 20),            
                Center(
                  child: Text("Current votes", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary, fontWeight: FontWeight.bold),)
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: currentSongsRanked != null ? currentSongsRanked.length : 1,
                  separatorBuilder: ((context, index) => Container()),
                  itemBuilder: (context, index){
                    print(currentSongsRanked?.length);
                    if(currentSongsRanked != null){
                      return ListTile(
                        title: Text(
                          "${currentSongsRanked[index].item1}",
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold), 
                        ),
                        subtitle: Text(
                          "${currentSongsRanked[index].item2}"
                        ),
                        trailing: Text(
                          "${currentSongsRanked[index].item3}"
                        ),
                      );
                    }
                    else {
                      return Center(child: CircularProgressIndicator());
                    }
                  }
                ),
                SizedBox(height: 15,),
                Center(
                  child: Text("Cast your vote!", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),)
                ),
                SizedBox(height: 15,),
                Row(
                  children: currentSongs != null 
                  ? currentSongs.map((song) => Expanded(
                    child: GestureDetector(
                      onTap: provider.didUserVote != true
                      ? () => provider.selectSong(currentSongs.indexOf(song))
                      : null,
                      child: Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.symmetric(horizontal: 8),
                        height: 80,
                        decoration: BoxDecoration(
                          color: provider.selectedSongIndex == currentSongs.indexOf(song)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).canvasColor,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: provider.selectedSongIndex == currentSongs.indexOf(song)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary
                          )
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              song.item1.length > 14
                              ? song.item1.toString().substring(0,14)
                              : song.item1, 
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: provider.selectedSongIndex == currentSongs.indexOf(song)
                                ? Theme.of(context).canvasColor
                                : Theme.of(context).colorScheme.tertiary
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              song.item2.length > 14
                              ? song.item2.toString().substring(0,14)
                              : song.item2, 
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: provider.selectedSongIndex == currentSongs.indexOf(song)
                                ? Theme.of(context).canvasColor
                                : Theme.of(context).colorScheme.tertiary
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  )).toList()
                  : [Center(child: CircularProgressIndicator())],
                ),
                SizedBox(height: 15,),
                Center(
                  child: provider.didUserVote != true
                  ? TextButton(
                    style: Theme.of(context).textButtonTheme.style!.copyWith(
                      backgroundColor: provider.selectedSongIndex != null
                      ? MaterialStatePropertyAll(Theme.of(context).colorScheme.primary)
                      : MaterialStatePropertyAll(Theme.of(context).colorScheme.secondary)
                    ),
                    onPressed: provider.selectedSongIndex != null
                    ? provider.voteSong
                    : null,
                    child: Text("Vote"),
                  )
                  : Text("You already voted!"),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    borderRadius: BorderRadius.circular(20)
                  ),  
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      Center(child: Text(
                        "Song history",  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)
                      )),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: songsHistory != null ? songsHistory.length : 1,
                        separatorBuilder: (context, index) => SizedBox(),
                        itemBuilder: (context, index) {
                          if(songsHistory == null)
                            return Center(child: CircularProgressIndicator());
                          else {
                            var song = songsHistory[index];
                            return ListTile(
                              title: Text(song.song),
                              subtitle: Text(song.artist),
                            );
                          }
                        }
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}