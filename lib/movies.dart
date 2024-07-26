import 'package:hive/hive.dart';

part 'movies.g.dart';
@HiveType(typeId: 0)
class Movies {
  @HiveField(0)
  String imageUrl;
  @HiveField(1)
  String name;
  @HiveField(2)
  String director;

  Movies({required this.imageUrl,required this.name,required this.director});
}
