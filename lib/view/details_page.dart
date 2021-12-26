import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ingenioustechlab/models/airports_model.dart';
import 'package:ingenioustechlab/models/model.dart';
import '../base/consatnt/constant.dart';

class DetailsPage extends StatefulWidget {

  final Airport model;

  const DetailsPage({Key? key, required this.model}) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  final Completer<GoogleMapController> _controller = Completer();
  LatLng _center = const LatLng(59.94919968, -151.695999146);
  late LatLng _lastMapPosition;
  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    setState(() {

      // Add dynamic Lat Long
      _center = LatLng(widget.model.lat,widget.model.lon);
      _lastMapPosition = _center;

      // Add Marker
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: widget.model.city,
          snippet: widget.model.name,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Constant.kDetailLocationPage),
      ),
      body: _mapViewWithDetails(),
    );
  }

  Widget _mapViewWithDetails() {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 12.0,
            ),
            onCameraMove: _onCameraMove,
            markers: _markers,
          ),
        ),
        Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${Constant.kName} : ${widget.model.name}'), // Name
                      sizeBox7(),
                      Text('${Constant.kCityState} : ${widget.model.state}'), //City,State
                      sizeBox7(),
                      Text('${Constant.kCountry} : ${widget.model.country}'), // Country
                      sizeBox7(),
                      Text('${Constant.kTz} : ${widget.model.tz}') // tz
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [Text('${Constant.kIcao} : ${widget.model.icao}')], // icao
                  )
                ],
              ),
            ))
      ],
    );
  }

  //For Fix height(7)
  Widget sizeBox7(){
    return const SizedBox(
      height: 7,
    );
  }

  // For Map Created
  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  // For Move Camera
  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }
}
