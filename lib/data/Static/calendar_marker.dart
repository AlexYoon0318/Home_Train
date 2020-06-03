import 'package:cloud_firestore/cloud_firestore.dart';

class Marker {
  final String exercise;
  final Timestamp C1;
  final DocumentReference reference;
  Marker(this.exercise,this.C1, {this.reference});

  Marker.fromMap(Map<String,dynamic> map, {this.reference})
      : assert(map['exercise']!=null),
        assert(map['C1']!=null),
        exercise=map['exercise'],
        C1=map['C1'];

  Marker.fromSnapshot(DocumentSnapshot snapshot) : this.fromMap(snapshot.data, reference: snapshot.reference);


  @override String toString() => "Record<$exercise>";
}