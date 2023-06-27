import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:makeyourown_songs/models/models.dart';
import 'package:makeyourown_songs/screens/admin/admin_page.dart';
import 'package:makeyourown_songs/screens/admin/admin_provider.dart';
import 'package:makeyourown_songs/screens/room/room_page.dart';
import 'package:makeyourown_songs/screens/room/room_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
export 'package:provider/provider.dart';


class HomePageProvider with ChangeNotifier{
  bool isLoading = false;
  TextEditingController controller = TextEditingController();
  String? adminPageCode;

  HomePageProvider(){
    _loading();

    getData();

    _loading();
  }

  Future<void> getData() async{
    await FirebaseFirestore.instance.collection("config").doc("config").get()
    .then((doc) => adminPageCode = doc.data()?['admin_room_id']);
  }

  // Handles every user input in the text field
  void onTextFieldChanged(BuildContext context, String? value) async{
    if(value != null){
      if(value.length == 4){
        await tryToJoinRoom(context, value);
      }
    }
  }

  /// 
  Future<void> tryToJoinRoom(BuildContext context, String value) async{
    _loading();

    try{

      /// Admin room
      if(value == adminPageCode){
        
        var query = await FirebaseFirestore.instance.collection("rooms").where("active", isEqualTo: true).get();

        /// No room active
        if(query.docs.length == 0){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Text("No room active"),
                  TextButton(
                    onPressed: () => startRoom("1111"),
                    child: Text("Activate"),
                  )
                ],
              )
            )
          )
          ;
        }
        /// One room is active
        else{
          var room = Room.fromDoc(query.docs[0]);
            Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => AdminPageProvider(room),
              child: AdminPage(),
            )
          ));
        }

        
      }
      /// Normal room
      else{

        // Get room
        var doc = await FirebaseFirestore.instance
        .collection('rooms')
        .doc(value)
        .get();

        /// Room exists
        if(doc.exists){
          var room = Room.fromDoc(doc);
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (_) => RoomPageProvider(room),
              child: RoomPage(),
            )
          ));
        }
        /// Room doesn't exist
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Room doesn't exists, try another code",
                textAlign: TextAlign.center,
              )
            )
          );
        }
      }
    }
    catch(e){

    }

    _loading();
  }

  Future startRoom(String roomId) async{
    final url = Uri.parse(
        "https://us-central1-makeyourown-songs.cloudfunctions.net/startRoom"
      );
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            "roomId": roomId
          }
        )
      );
      print(response.body);
  }

  _loading(){
    isLoading = !isLoading;

    notifyListeners();
  }
}