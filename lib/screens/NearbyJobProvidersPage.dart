import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NearbyJobProvidersPage extends StatefulWidget {
  const NearbyJobProvidersPage({super.key});

  @override
  State<NearbyJobProvidersPage> createState() => _NearbyJobProvidersPageState();
}

class _NearbyJobProvidersPageState extends State<NearbyJobProvidersPage> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  final Location location = Location();

  final List<Map<String, dynamic>> jobMarkers = [
    {
      'position': LatLng(40.731, -74.003),
      'type': 'health',
      'iconColor': BitmapDescriptor.hueGreen,
    },
    {
      'position': LatLng(40.732, -74.001),
      'type': 'construction',
      'iconColor': BitmapDescriptor.hueRed,
    },
    {
      'position': LatLng(40.734, -74.005),
      'type': 'teaching',
      'iconColor': BitmapDescriptor.hueBlue,
    },
  ];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future<void> getLocation() async {
    final loc = await location.getLocation();
    setState(() {
      currentLocation = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
                    zoom: 14,
                  ),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  markers: {
                    ...jobMarkers.map((job) {
                      return Marker(
                        markerId: MarkerId(job['type']),
                        position: job['position'],
                        icon: BitmapDescriptor.defaultMarkerWithHue(job['iconColor']),
                        infoWindow: InfoWindow(title: job['type'].toString().toUpperCase()),
                      );
                    }),
                  },
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Colors.grey),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Location',
                              border: InputBorder.none,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(icon: Icon(Icons.apartment_rounded), onPressed: () {}),
                      IconButton(icon: Icon(Icons.badge_rounded), onPressed: () {}),
                      IconButton(icon: Icon(Icons.luggage_rounded), onPressed: () {}),
                      IconButton(icon: Icon(Icons.business_center), onPressed: () {}),
                      IconButton(icon: Icon(Icons.account_circle_rounded), onPressed: () {}),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
