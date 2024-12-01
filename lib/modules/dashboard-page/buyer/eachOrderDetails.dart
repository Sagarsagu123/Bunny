import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/order-management/order-management-controller.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  OrderDetailsScreenState createState() => OrderDetailsScreenState();
}

class OrderDetailsScreenState extends State<OrderDetailsScreen>
    with TickerProviderStateMixin {
  final OrderManagementController orderController = Get.find();
  late TabController _tabController;

  TextEditingController rejectReasonController = TextEditingController();
  bool hasValue = false;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    isLoading = true;
    getOrdetDetails(widget.orderId);
  }

  @override
  void dispose() {
    rejectReasonController.dispose();
    super.dispose();
  }

  Future<void> getOrdetDetails(String orderTransactionId) async {
    setState(() {
      orderController.pendingDetails = [];
      orderController.fulfilledDetails = [];
      orderController.cancelledDetails = [];
    });
    var jsonData = await orderController.getOrdetDetails(orderTransactionId);
    if (jsonData != null &&
        jsonData['code'] == 200 &&
        jsonData['data'] != null) {
      setState(() {
        Map<String, dynamic> data = jsonData['data'];
        orderController.pendingDetails = data['pending_details'] ?? [];
        orderController.fulfilledDetails = data['fulfilled_details'] ?? [];
        orderController.cancelledDetails = data['cancelled_details'] ?? [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffAF6CDA),
        title: const Text('Orders'),
        bottom: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Fulfilled'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: SpinKitCircle(
              color: Color(0xffAF6CDA),
              size: 50,
            ))
          : TabBarView(
              controller: _tabController,
              children: [
                buildOrderList(
                  orderController.pendingDetails,
                  widget.orderId,
                ),
                buildOrderList(
                  orderController.fulfilledDetails,
                  widget.orderId,
                ),
                buildOrderList(
                  orderController.cancelledDetails,
                  widget.orderId,
                ),
              ],
            ),
    );
  }

  Widget buildOrderList(List<dynamic> orders, String orderId) {
    if (orders.isEmpty) {
      return const Center(
        child: Text('No Order Available'),
      );
    }
    TextStyle name = const TextStyle(
        fontFamily: "Poppins",
        color: Color.fromARGB(255, 110, 109, 109),
        fontSize: 22,
        fontWeight: FontWeight.w600);
    TextStyle price = const TextStyle(
        fontFamily: "Poppins",
        fontSize: 18,
        color: Color.fromARGB(255, 128, 127, 127),
        fontWeight: FontWeight.w500);
    TextStyle choice = const TextStyle(
        fontFamily: "Poppins", fontSize: 17, fontWeight: FontWeight.w400);

    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              if (index == 0 && order['order_status'] == "New Order") ...{
                Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 25,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                8.0), // Adjust border radius as needed
                            side: const BorderSide(
                                color: Color.fromARGB(255, 132, 133,
                                    132)), // Define border color and width
                          ),
                        ),
                      ),
                      onPressed: () {
                        cancelOrder(
                            widget.orderId, widget.orderId, "Cancel all", "1");
                      },
                      child: const Text(
                        'Cancel All',
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              },
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8.0),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Colors.white,
                      Color.fromARGB(255, 200, 165, 206)
                    ], // Gradient colors
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.network(
                          order['item_image'],
                          width: 90,
                          fit: BoxFit.cover,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(order['item_name'], style: name),
                            Text(
                                '${order['item_amount']} ${order['item_currency']}',
                                style: price),
                            Text(DateFormat('MM-dd-yyyy hh:mm a')
                                .format(DateTime.parse(order['order_date']))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    '${order['choice_list'][0]['choicename']} x ${order['item_quantity']}',
                                    style: choice),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox()
                      ],
                    ),
                    if (order['order_status'] == "New Order") ...{
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust border radius as needed
                                  side: const BorderSide(
                                      color: Color.fromARGB(255, 132, 133,
                                          132)), // Define border color and width
                                ),
                              ),
                            ),
                            onPressed: () {
                              showCancelReasonDialog(
                                  context, order['order_id'].toString());
                            },
                            child: const Text(
                              'Cancel Order',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                color: Color.fromARGB(255, 177, 74, 163),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showCancelReasonDialog(BuildContext context, String orderTransactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Reason to Cancel All Orders',
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Color.fromARGB(255, 37, 37, 37),
                  fontSize: 15,
                ),
              ),
              content: TextField(
                controller: rejectReasonController,
                onChanged: (val) {
                  if (val.length > 1) {
                    setState(() {
                      hasValue = true;
                    });
                  } else {
                    setState(() {
                      hasValue = false;
                    });
                  }
                },
                decoration:
                    const InputDecoration(hintText: 'Enter Cancel reason'),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      hasValue == true
                          ? const Color.fromARGB(255, 177, 79, 156)
                          : const Color.fromARGB(255, 177, 79, 156)
                              .withOpacity(.3),
                    ),
                  ),
                  onPressed: () {
                    if (hasValue == true) {
                      String rejectionReason = rejectReasonController.text;

                      cancelOrder(orderTransactionId, orderTransactionId,
                          rejectionReason, "0");
                      Navigator.of(context).pop();
                      rejectReasonController.text = '';
                    }
                  },
                  child: Text(
                    'submit',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: hasValue == true ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future cancelOrder(
      String orderTransactionId, String id, String reason, String type) async {
    var jsonData = await Get.find<OrderManagementController>()
        .cancelOrder(id, reason, type);
    if (jsonData == null && jsonData['code'] == 200) {
      Get.snackbar('Success', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
      await getOrdetDetails(orderTransactionId);
      Get.back();

      // Refresh the UI after canceling the order
      // This can be done by calling setState() or similar methods in the parent widget
      // to rebuild the UI with updated data.
    }
  }
}
