import 'package:cloud_firestore/cloud_firestore.dart';

class Room{
  String id;
  String name;
  DocumentReference ref;

  Room({required this.id, required this.name, required this.ref});

  static Room fromDoc(DocumentSnapshot doc){
    var data = doc.data() as Map<String, dynamic>;
    return Room(
      id: doc.id,
      name: data['name'],
      ref: doc.reference
    );
  }
}