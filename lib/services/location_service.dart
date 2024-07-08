// Flutter imports
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// Third-party package imports
import 'package:location/location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({super.key});

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  LatLng? _pickedLocation;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _getMap();
  }

  Future<void> _getMap() async {
    LocationData location = await LocationService().getLiveLocation();
    if (!mounted) return;
    setState(() {
      _pickedLocation = LatLng(location.latitude!, location.longitude!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location Picker"),
        actions: [
          if (_pickedLocation != null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            )
        ],
      ),
      body: _pickedLocation == null
          ? Center(
              child: LoadingAnimationWidget.beat(
                size: 60,
                color: Colors.amber,
              ),
            )
          : FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _pickedLocation!,
                initialZoom: 15.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _pickedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  retinaMode: true,
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 50.0,
                      height: 50.0,
                      point: _pickedLocation!,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}

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

  Widget currerntLocationandOrientation() {
    return CurrentLocationLayer(
      alignPositionOnUpdate: AlignOnUpdate.always,
      alignDirectionOnUpdate: AlignOnUpdate.never,
      style: const LocationMarkerStyle(
        marker: DefaultLocationMarker(
          child: Icon(
            Icons.navigation,
            color: Colors.white,
          ),
        ),
        markerSize: Size(30, 30),
        markerDirection: MarkerDirection.heading,
      ),
    );
  }
}
