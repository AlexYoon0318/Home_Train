import 'package:cloud_firestore/cloud_firestore.dart';

class RM{
  final Timestamp C1;
  final String weight;
  RM(this.C1, this.weight);

  RM.fromMap(Map<String,dynamic> map)
        :
        //assert(map['PF']!=null),
        //assert(map['C1']!=null),
        //assert(map['ExerciseList']!=null),
        C1=map['C1'],
        weight=map['weight'];

  @override String toString() => "Record<$weight>";
  //DateTime toDate() => "Record<$c1>";

}