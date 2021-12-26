import 'package:flutter/material.dart';
import 'package:ingenioustechlab/models/airports_model.dart';
import 'package:ingenioustechlab/view/details_page.dart';

class PostListItem extends StatelessWidget {

  final Airport model;
  const PostListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: _listInfo(context),
    );
  }

  Widget _listInfo(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13, left: 10, right: 10, top: 13),
      child: Column(
        children: [
          Row(
            children: [Text(model.name), const Spacer(), Text(model.icao)],
          ),
          Row(
            children: [
              Text('${model.city} , ${model.state}',),
              const Spacer(),
              Text(model.country)
            ],
          )
        ],
      ),
    );
  }
}