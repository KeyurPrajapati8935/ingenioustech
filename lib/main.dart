import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:ingenioustechlab/models/airports_model.dart';
import 'package:ingenioustechlab/view/location_page.dart';
import 'bloc/simple_bloc_observer.dart';
import 'package:path_provider/path_provider.dart' as pathProvide;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvide.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(AirportAdapter());
  BlocOverrides.runZoned(
    () => runApp(const LocationApp()),
    blocObserver: SimpleBlocObserver(),
  );
}
