import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  Future<String> login(String roomNumber, String password) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
}
