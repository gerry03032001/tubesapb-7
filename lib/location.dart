
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  const Location(this.detail, {Key? key}) : super(key: key);
  final Map detail;

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late GoogleMapController mapController;
  final Set<Marker> _marker = {};
  void _onMapCreated(GoogleMapController controller) {

    
    final location = widget.detail['locatiton'];
    final split = location.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    String? value1 = values[0];
    String? value2 = values[1];
    String value1new = value1 ?? 'default';
    String value2new = value2 ?? 'default';
    double lat = double.parse(value1new);
    double lng = double.parse(value2new);
    setState(() {
      _marker.add(Marker(
          markerId: const MarkerId('id-1'), 
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: widget.detail['name']
          )
        )
      );
    });
        setState(() {
      _marker.add(Marker(
          markerId: const MarkerId('id-2'), 
          position: const LatLng(-6.9733165,107.6281415),
          infoWindow: InfoWindow(
            title: widget.detail['name']
          )
        )
      );
    });
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.detail['locatiton'];
    final split = location.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++) i: split[i]
    };
    String? value1 = values[0];
    String? value2 = values[1];
    String value1new = value1 ?? 'default';
    String value2new = value2 ?? 'default';
    double lat = double.parse(value1new);
    double lng = double.parse(value2new);

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.detail['name']),
        foregroundColor: Colors.black,
        actions: const [
          Icon(Icons.notifications),
          Padding(padding: EdgeInsets.only(right: 10))
        ],
        backgroundColor: Colors.white,
      ),
      body: Center(
          child: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: _marker,
        polylines: {
          Polyline(polylineId: 
            const PolylineId('_kPolyline'), 
            points: [
            LatLng(lat, lng),
            const LatLng(-6.9733165,107.6281415),
            ],
            color: Colors.deepPurpleAccent,
            width: 5
          )
        },
        initialCameraPosition:
            CameraPosition(target: LatLng(lat, lng), zoom: 11.0),
      )),
    ));
  }
}
