import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:washflash/widget/reusable_text.dart';

class MapScreen extends StatefulWidget {
  final double lat;
  final double long;
  final String address;
  const MapScreen({Key? key, required this.lat, required this.long, required this.address}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  Set<Marker> myMarker = {};
  @override
  void initState() {
    super.initState();
    myMarker.add(
      Marker(
        markerId: MarkerId(widget.address),
        position: LatLng(widget.lat, widget.long),
        infoWindow: InfoWindow(
          title: widget.address,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: Scaffold(
        appBar: AppBar(title: ReusableText(title: "Map Screen",),),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.long),
            zoom: 8,
          ),
          mapType: MapType.normal,
          markers:myMarker,
          compassEnabled: true
        ),
      ),
    );
  }
}
