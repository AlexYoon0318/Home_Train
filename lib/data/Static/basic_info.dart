class BasicInfo{
  final bool PF;
  final int count;
  final String day;
  final String exercise;
  final String machine;
  final int set;
  final int weight;
  final DateTime c1;
  BasicInfo(this.PF, this.count, this.day, this.exercise, this.machine, this.set, this.weight, this.c1);

  BasicInfo.fromMap(Map<String,dynamic> map)
      :assert(map['PF']!=null),
       assert(map['count']!=null),
       assert(map['day']!=null),
       assert(map['exercise']!=null),
       assert(map['machine']!=null),
       assert(map['set']!=null),
       assert(map['weight']!=null),
       assert(map['c1']!=null),
        PF=map['PF'],
        count=map['count'],
        day=map['day'],
        exercise=map['exercise'],
        machine=map['machine'],
        set=map['set'],
        weight=map['weight'],
        c1=map['c1'];

  @override String toString() => "Record<$count:$day:$exercise:$machine:$set:$weight:$c1>";

}