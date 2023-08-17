import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const LatLng SOURCE_LOCATION = LatLng(42.747786, -71.1699);
const LatLng DESTINATION_LOCATION = LatLng(42.747786, -71.1699);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 18;
const double CAMERA_BEARING = 30;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Completer<GoogleMapController> googleMapController = Completer();
  BitmapDescriptor? sourseIcon;
  BitmapDescriptor? destinationIcon;
  Set<Marker> marker = <Marker>{};

  LatLng? currentLoaction;
  LatLng? destinationLocation;

  @override
  void initState() {
    super.initState();

    // set up the initial location
    setIntialLocation();

    // set up the marker icon
    setSourceAndDestinationMarker();
  }

  void setIntialLocation() {
    currentLoaction = LatLng(
      SOURCE_LOCATION.latitude,
      SOURCE_LOCATION.longitude,
    );

    destinationLocation = LatLng(
      DESTINATION_LOCATION.latitude,
      DESTINATION_LOCATION.longitude,
    );
  }

  void setSourceAndDestinationMarker() async {
    sourseIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.0),
      'assets/image/icon.png',
    );

    destinationIcon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.0),
      'assets/image/icon.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = const CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: SOURCE_LOCATION,
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              markers: marker,
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: (GoogleMapController controller) {
                googleMapController.complete(controller);

                showPinOnMap();
              },
            ),
          ),
        ],
      ),
    );
  }

  void showPinOnMap() {
    marker.add(
      Marker(
        markerId: const MarkerId('sourcePin'),
        position: currentLoaction!,
        icon: sourseIcon!,
      ),
    );

    marker.add(
      Marker(
        markerId: const MarkerId('destinationPin'),
        position: destinationLocation!,
        icon: destinationIcon!,
      ),
    );
  }
}
