import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:geolocator/geolocator.dart';

import '../utils/color.dart';
import '../utils/flutter_toast.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key, key}) : super(key: key);

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  Position? currentPosition;

  Future _checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      Utils.errorToast("to access the location you need to get permission");
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    _checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _checkPermission(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }  if (snapshot.hasError) {
              Utils.errorToast("Failed to get current position");
              return const Center(child: Text("Failed to get current position"));
            }
            return OpenStreetMapSearchAndPick(
                buttonTextColor: AppColor.whiteColor,
                center: LatLong(
                  snapshot.data.latitude,
                  snapshot.data.longitude,
                ),
                buttonColor: Colors.blue,
                buttonText: 'Select Location',
                onPicked: (pickedData) {
                  Navigator.of(context).pop(pickedData);
                  setState(() {});
                })
           ;

        },)

    );
  }
}
