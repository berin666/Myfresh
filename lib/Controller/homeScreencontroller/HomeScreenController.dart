import 'dart:developer';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:myfresh/common/baseurl.dart';
import 'package:myfresh/model/homemodel.dart';

class HomeScreenController extends GetxController {
  Homedata? homedata;
  var homedataload = false.obs;
  var cartItems = <Map<String, dynamic>>[].obs;

  final box = GetStorage();

  loadhomedata() async {
    homedataload.value = true;
    try {
      var homedataval = await http.get(Uri.parse(Baseurl));
      if (homedataval.statusCode == 200) {
        log("${homedataval.body}");
        homedata = homedataFromJson(homedataval.body);
      } else {
        log("error in api call : ${homedataval.body}");
      }
    } catch (e) {
      log("error in home data : $e");
    } finally {
      homedataload.value = false;
    }
  }

  void incrementItem(int id, String name, double price, int calories) {
    int index = cartItems.indexWhere((item) => item['id'] == id);

    if (index != -1) {
      cartItems[index]['quantity'] += 1;
      cartItems[index]['totalAmount'] =
          cartItems[index]['quantity'] * cartItems[index]['price'];
      cartItems.refresh(); // Refresh the list to notify UI
    } else {
      cartItems.add({
        'id': id,
        'name': name,
        'price': price,
        'calories': calories,
        'quantity': 1,
        'totalAmount': price,
      });
      cartItems.refresh();
    }
    saveCartData();
  }

  void decrementItem(int id) {
    int index = cartItems.indexWhere((item) => item['id'] == id);

    if (index != -1) {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity'] -= 1;
        cartItems[index]['totalAmount'] =
            cartItems[index]['quantity'] * cartItems[index]['price'];
        cartItems.refresh();
      } else {
        cartItems.removeAt(index);
        cartItems.refresh();
      }
      saveCartData();
    }
  }

  void clearCart() {
    cartItems.clear();
    saveCartData();
    log("Cart Cleared");
  }

  void saveCartData() {
    box.write('cart', cartItems);
    log("Cart Saved: $cartItems");
  }

  void loadCartData() {
    var storedData = box.read<List>('cart');
    if (storedData != null) {
      cartItems.assignAll(
          storedData.map((item) => Map<String, dynamic>.from(item)).toList());
    }
  }

  int get cartItemCount {
    return cartItems.map((item) => item['id']).toSet().length;
  }

  @override
  void onInit() {
    loadhomedata();
    loadCartData();
    super.onInit();
  }
}
