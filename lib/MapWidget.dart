// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';

class MapWidget extends StatefulWidget {
  final Function addMarker;
  final List<Marker> markers;
  MapWidget(this.addMarker, this.markers);
  @override
  _MapAppState createState() => _MapAppState();
}

class _MapAppState extends State<MapWidget> {
  double long = 49.5;
  double lat = -0.09;
  LatLng point = LatLng(49.5, -0.09);
  var location = [];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            onTap: (p) async {
              setState(() {
                point = p;
                print(p);
                Marker m = Marker(
                  width: 80.0,
                  height: 80.0,
                  point: point,
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                );
                widget.markers[0] = m;
              });

              /*print(
                  "${location.first.countryName} - ${location.first.featureName}");*/
              widget.addMarker(p);
            },
            center: LatLng(49.5, -0.09),
            zoom: 5.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
                markers: /*[
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: point,
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                  ),
                ),
              ]*/
                    widget.markers),
          ],
        ),
      ],
    );
  }
}
