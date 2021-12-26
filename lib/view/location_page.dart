import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingenioustechlab/base/consatnt/constant.dart';
import 'package:ingenioustechlab/bloc/post_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ingenioustechlab/view/location_list.dart';

class LocationApp extends StatefulWidget {
  const LocationApp({Key? key}) : super(key: key);

  @override
  _LocationAppState createState() => _LocationAppState();
}

class _LocationAppState extends State<LocationApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: Scaffold(
          appBar: AppBar(title: const Text(Constant.kFlightDemo)),
          body: BlocProvider(
            create: (_) =>
                PostBloc(httpClient: http.Client())..add(PostFetched()),
            child: const LocationListPage(),
          ),
        ));
  }
}
