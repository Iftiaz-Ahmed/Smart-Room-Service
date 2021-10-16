import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseApi {
  Future<String> login(String roomNumber, String password) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String message = "";
    var result = _firestore
        .collection("users")
        .where("room_number", isEqualTo: roomNumber)
        .get();

    return result.then((value) {
      if (value.docs.isEmpty) {
        message = "Invalid room number!";
      } else {
        value.docs.forEach((element) {
          if (password == element['password']) {
            prefs.setStringList("creds", [roomNumber, password]);
            message = "Login Successful!";
          } else {
            message = "Invalid credentials!";
          }
        });
      }
      return message;
    });
  }

  Future getRestaurantImage(String image_name) async {
    final ref = FirebaseStorage.instance.ref("restaurant_images/$image_name");
    final result = await ref.getDownloadURL();

    return result;
  }

  Future<List> getFoodList(String mealType) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    List foodList = [];
    var result = _firestore
        .collection("restaurant")
        .where("meal", isEqualTo: mealType)
        .get();

    return result.then((value) {
      for (var element in value.docs) {
        foodList.add(element);
      }
      return foodList;
    });
  }
}
