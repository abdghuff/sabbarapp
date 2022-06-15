import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapView extends StatefulWidget {
  // final void changeAddress;
  final Function changeAddress;
  const MapView({Key? key, required this.changeAddress, }) : super(key: key);


  @override 
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final Completer<GoogleMapController> _controller = Completer();
  final LatLng defaultLocation = const LatLng(36.10466402024031, 32.35293058894082);
  LatLng currentLocation = const LatLng(36.10466402024031, 32.35293058894082);
  


  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(36.10466402024031, 32.35293058894082),
    zoom: 14.4746,
  );

  
  void selectLocation(LatLng location) {
    setState(() {
      currentLocation = location;
    });

    widget.changeAddress(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(5.0),
    child: GoogleMap(
        markers: {
          Marker(
            markerId: const MarkerId("Selected"),
            position: currentLocation,
            icon: BitmapDescriptor.defaultMarker,
            consumeTapEvents: true,
          )
        },
        mapType: MapType.hybrid,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        onTap: (LatLng location){
          selectLocation(location);
         },

    )
  );
  }