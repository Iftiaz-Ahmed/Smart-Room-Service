import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hhotel/provider/restaurant_bloc.dart';
import 'package:hhotel/services/firebase_api.dart';
import 'package:masonry_grid/masonry_grid.dart';
import 'package:provider/provider.dart';

class Foodlist extends StatefulWidget {
  String? mealType;
  Foodlist({Key? key, required this.mealType}) : super(key: key);

  @override
  _FoodlistState createState() => _FoodlistState();
}

class _FoodlistState extends State<Foodlist> {
  FirebaseApi _firebaseApi = FirebaseApi();

  @override
  Widget build(BuildContext context) {
    RestaurantBloc _restaurantBloc = Provider.of<RestaurantBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealType!.toUpperCase(),
        ),
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
        padding: EdgeInsets.all(10),
        child: FutureBuilder(
          future: _firebaseApi.getFoodList(widget.mealType.toString()),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return MasonryGrid(
                  column: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: List.generate(snapshot.data.length, (index) {
                    return Card(
                      margin: EdgeInsets.all(0),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FutureBuilder(
                            future: _firebaseApi.getRestaurantImage(
                                snapshot.data[index]['image']),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> imageSnapshot) {
                              if (imageSnapshot.hasData) {
                                return Image.network(imageSnapshot.data);
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                          ListTile(
                            title: Text(
                              snapshot.data[index]['name'],
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              "\$ " + snapshot.data[index]['price'].toString(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red[600]),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: () {
                                _restaurantBloc
                                    .addCartItem(snapshot.data[index]);
                              },
                              child: const Text("Add to Cart"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.green),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          )
                        ],
                      ),
                    );
                  }));
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
