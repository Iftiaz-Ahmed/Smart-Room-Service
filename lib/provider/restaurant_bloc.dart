import 'package:flutter/cupertino.dart';

class RestaurantBloc extends ChangeNotifier {
  List _restaurantCart = [];
  List get restaurantCart => _restaurantCart;
  set restaurantCart(List value) {
    _restaurantCart = value;
    notifyListeners();
  }

  int _cartCounter = 0;
  int get cartCounter => _cartCounter;
  set cartCounter(int value) {
    _cartCounter = value;
    notifyListeners();
  }

  addCartItem(var item) {
    restaurantCart.add(item);
    cartCounter = restaurantCart.length;
  }
}
