import 'package:favorite_palces/screens/faultScreen.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:favorite_palces/models/place.dart';

class LocationInput extends StatefulWidget {
  LocationInput({super.key, required this.onselectedLocation});
  final void Function(PlaceLocation location) onselectedLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? pickedLocation;
  var isGettinglocation = false;

  void getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isGettinglocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    setState(() {
      pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
      isGettinglocation = false;
    });

    widget.onselectedLocation(pickedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = pickedLocation == null
        ? Text('No Data')
        : Text(
            'Location: Latitude = ${pickedLocation!.latitude} and Longitude = ${pickedLocation!.longitude}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          );

    if (isGettinglocation) {
      previewContent = CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              ),
            ),
            height: 170,
            width: double.infinity,
            child: previewContent),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              icon: Icon(Icons.location_on),
              label: Text('get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => FaultScreen(),
                  ),
                );
              },
              icon: Icon(Icons.map),
              label: Text('Select On Maps'),
            ),
          ],
        )
      ],
    );
  }
}
