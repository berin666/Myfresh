import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/homeScreencontroller/HomeScreenController.dart';
import 'home_screen.dart';

class CartScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());

  CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Order Summary'),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Material(
                  color: Colors.white,
                  elevation: 5,
                  borderRadius: BorderRadius.circular(5),
                  child: Column(
                    children: [
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green[800],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            child: Center(
                              child: Text(
                                "${controller.cartItems.length} Dishes - ${controller.cartItemCount} Items",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Obx(() => ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: controller.cartItems.length,
                            itemBuilder: (context, index) {
                              final item = controller.cartItems[index];
                              return Container(
                                margin: const EdgeInsets.all(10.0),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey, width: 1),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.circle,
                                            color: item['name']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains('chicken')
                                                ? Colors.red
                                                : Colors.green,
                                            size: 15,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: item['name']
                                                      .toString()
                                                      .toLowerCase()
                                                      .contains('chicken')
                                                  ? Colors.red
                                                  : Colors.green,
                                            ),
                                          ),
                                          margin: EdgeInsets.all(5),
                                        )
                                      ],
                                    ),
                                    Expanded(

                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          Text("INR ${item['price']}"),
                                          Text("${item['calories']} calories"),
                                        ],
                                      ),
                                    ),

                                    Column(
                                      children: [
                                        Container(
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  controller.decrementItem(
                                                      item['id']);
                                                },
                                              ),
                                              Text(
                                                "${item['quantity']}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  controller.incrementItem(
                                                      item['id'],
                                                      item['name'],
                                                      item['price'],
                                                      item['calories']);
                                                },
                                              ),
                                            ],
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(45),
                                              color: Colors.green),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          )),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Obx(
                          () {
                            double totalAmount = controller.cartItems.fold(
                                0, (sum, item) => sum + item['totalAmount']);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Total Amount",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.black),
                                ),
                                Text(
                                  "INR ${totalAmount.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.green),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                onPressed: () {
                  controller.clearCart();
                  Get.off(() => HomeScreen());
                  Get.snackbar(
                    "Order Placed",
                    "Your order has been placed!",
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                ),
                child: const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ));
  }
}
