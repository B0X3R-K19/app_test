import 'package:hive/hive.dart';

part 'training.g.dart';

@HiveType(typeId: 1)
class Training {
  @HiveField(0)
  String day; // Wochentag

  @HiveField(1)
  String date; // Datum

  @HiveField(2)
  String trainingType; // Trainingsart

  Training(this.day, this.date, this.trainingType);
}
