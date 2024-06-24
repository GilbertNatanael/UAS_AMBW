import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part 'note.g.dart'; //run flutter packages pub run build_runner build di terminal untuk generate adapter

@HiveType(typeId: 0)
class Note {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  String createdDate;

  @HiveField(3)
  String lastEditedDate;

  Note({
    required this.title,
    required this.content,
  })  : createdDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        lastEditedDate =
            DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

  @HiveField(4)
  int get id =>
      hashCode; 
}
