import 'package:cloud_firestore/cloud_firestore.dart';


class ExerciseInfo{
  String machine;
  String exercise;
  Timestamp C1;
  int RMweight;
  int Volume;

  ExerciseInfo(this.C1, this.exercise, this.machine, this.RMweight, this.Volume);

  ExerciseInfo.fromMap(Map<String,dynamic> map):
        assert(map['C1']!=null),
        //assert(map['exercise']!=null),
        //assert(map['machine']!=null),
        assert(map['RMweight']!=null),
        assert(map['Volume']!=null),
        C1=map['C1'],
        exercise=map['exercise'],
        machine=map['machine'],
        RMweight=map['RMweight'],
        Volume=map['Volume'];

  @override String toString() => "Record<$C1>";
}