import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_reader/models/scan_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: use_key_in_widget_constructors
class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  MapType mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    final ScanModel scan =
        ModalRoute.of(context)?.settings.arguments as ScanModel;

    CameraPosition puntoInicial = CameraPosition(
      tilt: 50,
      target: scan.getLatLng(),
      zoom: 17,
    );

    //Marcadores
    Set<Marker> markers = Set<Marker>();
    markers.add(Marker(
      markerId: MarkerId('geo-location'),
      position: scan.getLatLng(),
    ));

    return Scaffold(
      appBar: AppBar(title: Text('Mapa'), actions: [
        IconButton(
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller
                  .animateCamera(CameraUpdate.newCameraPosition(puntoInicial));
            },
            icon: const Icon(Icons.location_searching_rounded))
      ]),
      body: GoogleMap(
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        mapType: mapType,
        initialCameraPosition: puntoInicial,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            mapType == MapType.normal
                ? mapType = MapType.satellite
                : mapType = MapType.normal;
            setState(() {});
          },
          child: const Icon(Icons.layers)),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
