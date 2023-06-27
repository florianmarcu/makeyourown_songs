import 'package:flutter/material.dart';
import 'package:makeyourown_songs/screens/admin/admin_provider.dart';
import 'package:makeyourown_songs/screens/home/home_provider.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<AdminPageProvider>();
    var room = provider.room;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: provider.selectedSongs.length == 3 && provider.didAdminVote != true
        ? Theme.of(context).primaryColor
        : Colors.grey[500],
        onPressed: provider.selectedSongs.length == 3 && provider.didAdminVote != true
        ? () async{ 
          await provider.updateSongOptions();
        }
        : null,
        label: provider.didAdminVote == true
        ? Text("Already updated", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).highlightColor))
        : ( provider.selectedSongs.length < 3
          ? Text("Select 3 songs", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).highlightColor))
          : Text("Update songs", style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).highlightColor),)
          ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          children: [
            Text("Admin"),
            SizedBox(height: 10),
            Text("${room.id} : ${room.name}")
          ],
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 40,),
          Center(
            child: Text("${provider.currentTimeLeftString}", style: Theme.of(context).textTheme.headlineMedium,),
          ),          
          SizedBox(height: 40,),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Last elected song", style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 20),
                provider.songsHistory != null && provider.songsHistory!.length != 0
                ? Column(
                  children: [
                    Text(
                      "${provider.songsHistory![0].song}",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "${provider.songsHistory![0].artist}",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                : Text("-"),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Songs"),
                Form(
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width*0.5 ,
                    child: TextFormField(
                      cursorColor: Theme.of(context).colorScheme.tertiary,
                      decoration: InputDecoration(
                        hintText: "Search",
                        
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        fillColor: Theme.of(context).colorScheme.secondary,
                        
                      ),
                      onChanged: (keyword) => provider.filterSongs(keyword),
                    ),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: provider.songsListFiltered != null ? provider.songsListFiltered!.length : 1,
            itemBuilder: (context, index){
              if(provider.songsListFiltered == null)
                return Center(child: CircularProgressIndicator(),);
              var song = provider.songsListFiltered!.keys.toList()[index];
              return ListTile(
                title: Text(
                  "${song.song}",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold), 
                ),
                subtitle: Text(
                  "${song.artist}"
                ),
                trailing: Checkbox(
                  value: provider.songsList![song],
                  onChanged: (selected) => provider.updateSelectedSongs(song, selected),
                )
              );
            }
          )
        ],
      ),
    );
  }
}