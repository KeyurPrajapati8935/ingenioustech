import 'package:hive/hive.dart';
part 'airports_model.g.dart';

@HiveType(typeId: 1, adapterName: "AirportAdapter")
class Airport {
  @HiveField(0)
  late String icao;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String city;

  @HiveField(3)
  late String state;

  @HiveField(4)
  late String country;

  @HiveField(5)
  late double lat;

  @HiveField(6)
  late double lon;

  @HiveField(7)
  late String tz;

  Airport(
      {required this.icao,
      required this.name,
      required this.city,
      required this.state,
      required this.country,
      required this.lat,
      required this.lon,
      required this.tz});
}
