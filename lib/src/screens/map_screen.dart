import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math' as math;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return Future.error('Habilite seu GPS');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return Future.error('NEGOU O BAGUIU NÃO FOI DOIDO??');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return Future.error('NEGOU O BAGUIU NÃO FOI DOIDO??');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa do Maroto'),
        backgroundColor: Color(0xFF00457D),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _currentPosition == null
          ? Center(child: Text('Não foi possível obter sua localização'))
          : FlutterMap(
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'br.dev.yago.climapp_flutter',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentPosition!,
                      height: 80,
                      width: 80,
                      child: StreamBuilder<CompassEvent>(
                        stream: FlutterCompass.events,
                        builder: (context, snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return Icon(
                              Icons.navigation,
                              color: Colors.blueAccent,
                              size: 40,
                            );
                          }
                          final double? direction = snapshot.data?.heading;
                          final double angle =
                              (direction ?? 00) * (math.pi / 180);
                          return Transform.rotate(
                            angle: angle,
                            child: Icon(
                              Icons.navigation,
                              color: Colors.blueAccent,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
