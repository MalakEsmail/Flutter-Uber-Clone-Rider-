import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider/dataprovider/app_data.dart';
import 'package:rider/helpers/helpermethod.dart';
import 'package:rider/screens/search_page.dart';
import 'package:rider/widgets/brand_divider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? mapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  double mapButtonPadding = 0;
  // geoLocator
  var geoLocator = Geolocator();
  Position? currentPosition;
  void setupPositionLocator() async {
    if (await Geolocator.checkPermission() != LocationPermission.always) {
      await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPosition = position;
    print("currentPosition : $currentPosition");
    LatLng pos = LatLng(position.latitude, position.longitude);
    CameraPosition cp = CameraPosition(target: pos, zoom: 14);
    mapController!.animateCamera(CameraUpdate.newCameraPosition(cp));
    String address =
        await HelperMethod.findCoordinateAddress(context, position: position);
    print("Position Address: $address");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: globalKey,
        drawer: Container(
          width: 250,
          color: Colors.white,
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.all(10),
              children: [
                Container(
                  color: Colors.white,
                  height: 160,
                  child: DrawerHeader(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Row(
                        children: [
                          Image.asset(
                            "images/user_icon.png",
                            height: 60,
                            width: 60,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "name",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text("view profile")
                            ],
                          )
                        ],
                      )),
                ),
                BrandDivider(),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Icon(Icons.card_giftcard_outlined),
                  title: Text("Free Rides"),
                ),
                ListTile(
                  leading: Icon(Icons.credit_card),
                  title: Text("Payment"),
                ),
                ListTile(
                  leading: Icon(Icons.history),
                  title: Text("Ride History"),
                ),
                ListTile(
                  leading: Icon(Icons.contact_support),
                  title: Text("Support"),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text("About"),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: mapButtonPadding),
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                mapController = controller;
                setState(() {
                  mapButtonPadding = 270;
                });
                setupPositionLocator();
              },
            ),
            Positioned(
              top: 30,
              left: 20,
              child: InkWell(
                onTap: () {
                  globalKey.currentState!.openDrawer();
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(44),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7)),
                      ]),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.menu,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  height: 260,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "nice to see you ",
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        "Where are you going ?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 5,
                                    spreadRadius: 0.5,
                                    offset: Offset(0.7, 0.7)),
                              ]),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.search,
                                  color: Colors.blueAccent,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text("Search Destination ")
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                  /*Provider.of<AppData>(context)
                                          .pickUpAddress!
                                          .placeName !=
                                      null
                                  ? Provider.of<AppData>(context)
                                      .pickUpAddress!
                                      .placeName!
                                  : */
                                  "Add Home"),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Your residential address",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      BrandDivider(),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 4,
                              ),
                              Text("Add Work"),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                "Your office address",
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Future<void> getDirection() async {
    var pickUp = Provider.of<AppData>(context, listen: false).pickUpAddress!;
    var destination =
        Provider.of<AppData>(context, listen: false).destinationAddress!;

    var pickLatLng = LatLng(pickUp.latitude!, pickUp.longitude!);
    var destinationLatLng =
        LatLng(destination.latitude!, destination.longitude!);
    var thisDetails =
        HelperMethod.getDirectionDetails(pickLatLng, destinationLatLng);
  }
}
