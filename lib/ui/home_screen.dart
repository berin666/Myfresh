import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myfresh/Controller/homeScreencontroller/HomeScreenController.dart';
import 'package:myfresh/auth/login_sreen.dart';
import 'package:myfresh/ui/cart_screen.dart';

import '../auth/auth_service.dart';
import '../common/imgeurls.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();
    final _storage = GetStorage();
    var controller = Get.put(HomeScreenController());
    final String username = _storage.read('username') ?? "No Name";
    final String useremail = _storage.read('useremail') ?? "No Email";
    return Obx(() {
      if (controller.homedataload.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      } else if (controller.homedata == null) {
        return const Scaffold(
          body: Center(child: Text('No Data Available')),
        );
      } else {
        return DefaultTabController(
          length: controller.homedata!.categories.length,
          child: Scaffold(
            appBar: AppBar(
              forceMaterialTransparency: true,
              bottom: TabBar(
                isScrollable: true,
                tabs: controller.homedata!.categories
                    .map((category) => Tab(text: category.name))
                    .toList(),
                indicatorColor: Colors.red,
                labelColor: Colors.red,
              ),
              actions: [
                Obx(
                      () =>
                      IconButton(
                        onPressed: () {
                          Get.to(() => CartScreen());
                        },
                        icon: Badge(
                            label: Text("${controller.cartItemCount}"),
                            child: const Icon(Icons.shopping_cart)),
                      ),
                )
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                      ),
                      gradient: LinearGradient(colors: [
                        Color(0xFF1C7C00),
                        Color(0xFF9AEF89),
                      ]),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            maxRadius: 40,
                            backgroundColor: Colors.white,
                            child: Icon(
                              Icons.person,
                              size: 40,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            username,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        Center(
                          child: Text(
                            useremail,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                decoration: TextDecoration.none),
                          ),
                        ),
                      ],
                    ),
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * .30,
                  ),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.grey),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () async {
                      await _authService.signout();
                      Get.off(() => LoginScreen());
                    },
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: controller.homedata!.categories.map((category) {
                return ListView.builder(
                  itemCount: category.dishes.length,
                  itemBuilder: (context, index) {
                    final dish = category.dishes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: dish.name
                                                .toString()
                                                .toLowerCase()
                                                .contains('chicken')
                                                ? Colors.red
                                                : Colors.green,
                                          ),
                                        ),
                                        child: Icon(
                                          size: 15,
                                          Icons.circle,
                                          color: dish.name
                                              .toString()
                                              .toLowerCase()
                                              .contains('chicken')
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          dish.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "SAR ${dish.price}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 14),
                                      ),
                                      Text(
                                        " ${dish.calories} calories",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    dish.description,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 8),

                                  Container(
                                    margin:
                                    EdgeInsets.only(right: 80, bottom: 5),
                                    decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius:
                                        BorderRadius.circular(35)),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          color: Colors.white,
                                          onPressed: () =>
                                              controller.decrementItem(dish.id),
                                        ),
                                        Obx(() {
                                          final cartItem = controller.cartItems
                                              .firstWhereOrNull(
                                                (item) => item['id'] == dish.id,
                                          );
                                          final quantity = cartItem != null
                                              ? cartItem['quantity']
                                              : 0;
                                          return Text(
                                            "$quantity",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          color: Colors.white,
                                          onPressed: () =>
                                              controller.incrementItem(
                                                dish.id,
                                                dish.name,
                                                double.parse("${dish.price}"),
                                                dish.calories,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),


                                  if (dish.customizationsAvailable)
                                    const Text(
                                      "Customizations Available",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.network(
                                dish.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    imageurl1,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 80,
                                        color: Colors.grey,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      }
    });
  }
}
