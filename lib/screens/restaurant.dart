import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hhotel/provider/restaurant_bloc.dart';
import 'package:hhotel/services/firebase_api.dart';
import 'package:provider/provider.dart';

import 'food_list.dart';

class RestaurantPage extends StatefulWidget {
  const RestaurantPage({Key? key}) : super(key: key);

  @override
  _RestaurantPageState createState() => _RestaurantPageState();
}

class _RestaurantPageState extends State<RestaurantPage> {
  FirebaseApi _firebaseApi = FirebaseApi();

  List foodTypes = [
    {
      "name": "Breakfast",
      "image": "assets/images/breakfast.jpg",
    },
    {
      "name": "Lunch",
      "image": "assets/images/lunch.jpg",
    },
    {
      "name": "Dinner",
      "image": "assets/images/dinner.jpg",
    },
    {
      "name": "Drinks",
      "image": "assets/images/drinks.jpg",
    }
  ];

  @override
  Widget build(BuildContext context) {
    RestaurantBloc _restaurantBloc = Provider.of<RestaurantBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Categories"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              onPressed: () async {},
              icon: Badge(
                  badgeContent: Text(
                    _restaurantBloc.cartCounter.toString(),
                    style: TextStyle(color: Colors.white),
                  ),
                  child: const Icon(Icons.shopping_cart)),
            ),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                crossAxisCount: 1),
            itemCount: foodTypes.length,
            itemBuilder: (BuildContext ctx, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Foodlist(
                                mealType: foodTypes[index]['name']
                                    .toString()
                                    .toLowerCase(),
                              )));
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    foodTypes[index]['name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        letterSpacing: 2,
                        backgroundColor: Colors.black.withOpacity(0.7)),
                  ),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(foodTypes[index]['image']),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15)),
                ),
              );
            }),
      ),
    );
  }
}
