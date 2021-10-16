import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hhotel/provider/auth_bloc.dart';
import 'package:hhotel/screens/login_page.dart';
import 'package:hhotel/screens/restaurant.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  List menu = [
    {"name": "Restaurant", "icon": "assets/images/restaurant.jpg"},
    {"name": "Laundry", "icon": "assets/images/laundry.jpg"},
    {"name": "TV Remote", "icon": "assets/images/tv.jpg"},
    {"name": "AC Control", "icon": "assets/images/ac.jpg"},
    {"name": "Curtains", "icon": "assets/images/curtains.jpg"},
    {"name": "Door Control", "icon": "assets/images/door.jpg"},
    {"name": "Light Control", "icon": "assets/images/light.jpg"},
    {"name": "Windows", "icon": "assets/images/windows.jpg"},
  ];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var item;
  String roomNumber = "";

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? values = prefs.getStringList("creds");
    setState(() {
      roomNumber = values![0];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUsername();
    firestore.collection("restaurant").get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        item = element.data();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc _auth = Provider.of<AuthBloc>(context);

    var menuTextStyle = TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
        letterSpacing: 1,
        backgroundColor: Colors.black.withOpacity(0.5));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Room Service',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove("creds");
                _auth.isLogged = false;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                "assets/images/hotel.jpg",
                height: 150,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
              Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                color: Colors.black.withOpacity(0.5),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Room Number - $roomNumber",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'cursive',
                        letterSpacing: 3),
                  ),
                ),
              )
            ],
          ),
          Flexible(
            child: Container(
              color: Theme.of(context).backgroundColor,
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15),
                  itemCount: menu.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        if (index == 0) {
                          print("Restaurant tapped");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RestaurantPage()));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Service not available!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Align(
                          heightFactor: 3,
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            menu[index]['name'],
                            style: menuTextStyle,
                          ),
                        ),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(menu[index]['icon']),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15)),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
