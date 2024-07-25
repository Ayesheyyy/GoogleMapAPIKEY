import 'dart:async';
import 'dart:convert';
import 'package:failedtoconnect/Validation_screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../variables/gloabl-var.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPosition;
  GlobalKey<ScaffoldState> akeyy = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    checkPermissionsAndLiveLocation();
  }

  Future<void> checkPermissionsAndLiveLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    LiveLocation();
  }

  void mapTheme(GoogleMapController controller) {
    jsonFile("map/night-style.json").then((value) => mapStyle(value, controller));
  }

  Future<String> jsonFile(String path) async {
    try {
      ByteData byteData = await rootBundle.load(path);
      var list = byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return utf8.decode(list);
    } catch (e) {
      print("Error loading map style JSON: $e");
      return '';
    }
  }

  void mapStyle(String googleMapStyle, GoogleMapController controller) {
    if (googleMapStyle.isNotEmpty) {
      controller.setMapStyle(googleMapStyle);
    } else {
      print("Map style JSON is empty.");
    }
  }

  Future<void> LiveLocation() async {
    Position userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = userPosition;

    LatLng positionConversion = LatLng(currentPosition!.latitude, currentPosition!.longitude);

    CameraPosition cameraPosition = CameraPosition(target: positionConversion, zoom: 20);
    controllerGoogleMap?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: akeyy,

      drawer: Drawer(
        backgroundColor: Colors.black54,
        child: Drawer(
          backgroundColor: Colors.black54,
          child: ListView(
            children: [
              Container(
                color: Colors.black54,
                height: 160,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(width: 14,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            UserName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Divider(
                height: 1,
                color: Colors.white,
                thickness: 0.2,
              ),

              SizedBox(height: 10,),
              ListTile(
                leading: IconButton(
                  onPressed: (){},
                  icon: Icon(Icons.info,color: Colors.grey,) ,
                ),
                title: Text("About", style: TextStyle(color: Colors.grey),),
              ),
              GestureDetector(
                onTap: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>LoginScreen()));
                }
                ,
                child: ListTile(
                  leading: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.logout,color: Colors.grey,) ,
                  ),
                  title: Text("LogOut", style: TextStyle(color: Colors.grey),),
                ),
              )
            ],
          ),

        ),
      ),

      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController mapController) {
              controllerGoogleMap = mapController;
              mapTheme(controllerGoogleMap!);
              googleMapCompleterController.complete(controllerGoogleMap);
              LiveLocation();
            },
          ),

          //button
          Positioned(
            top: 42,
            left: 19,
            child: GestureDetector(
              onTap: (){
                akeyy.currentState!.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 5,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ]
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  child: Icon(
                    Icons.menu,
                    color: Colors.white70,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


