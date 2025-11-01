import 'package:hive/hive.dart';

part 'hive_db.g.dart';

@HiveType(typeId: 0)
class Data extends HiveObject {

  @HiveField(0)
  String? title;

  @HiveField(1)
  String? description;

  @HiveField(2)
  String? priority;


  Data({this.title, this.description, this.priority});
}
