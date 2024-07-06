import 'package:flutter/material.dart';
// import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationService {
  Future<void> requestLocationService(Location locController) async {
    PermissionStatus? permissionGranted;
    bool? serviceEnabled;

    // request location service
    serviceEnabled ??= await locController.serviceEnabled().then((value) {
      return value;
    });
    if (serviceEnabled!) {
      serviceEnabled = await locController.requestService();
    } else {
      return;
    }

    // request location permission
    permissionGranted ??= await locController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locController.requestPermission();
      debugPrint("requested permission");
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  // get location and store data
  Future<LocationData> getLiveLocation() async {
    // geo location
    final Location locationController = Location();
    // LatLng? livePostion;
    await requestLocationService(locationController);

    // get location
    LocationData currentLocation = await locationController.getLocation();
    // if (currentLocation.latitude != null && currentLocation.longitude != null) {
    //   livePostion = LatLng(currentLocation.latitude!, currentLocation.longitude!);
    // }

    return currentLocation;
  }
}
