import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/order-management/order-management-controller.dart';
import 'package:flutter_demo/utils.dart';
import 'package:flutter_demo/widgets/static-grid.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => NewOrderState();
}

class NewOrderState extends State<NewOrder> {
  final OrderManagementController orderController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    newOrder();
  }

  Future newOrder() async {
    var jsonData = await orderController.newOrder();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      if (jsonData != null && jsonData['data'] != null) {
        setState(() {
          orderController.newOrderArray = jsonData['data']["order_details"];
        });
      } else {
        setState(() {
          orderController.newOrderArray = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: orderController.newOrderArray.isNotEmpty
          ? RefreshIndicator(
              color: Colors.white,
              edgeOffset: 10.0,
              displacement: 40.0,
              backgroundColor: const Color(0xffAF6CDA),
              strokeWidth: 3.0,
              onRefresh: () async {
                await newOrder();
                return Future<void>.delayed(const Duration(seconds: 1));
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    StaticGrid(
                      columnCount: 1,
                      children:
                          orderController.newOrderArray.reversed.map((order) {
                        final List<String> itemImages =
                            List<String>.from(order['item_images']);
                        return GestureDetector(
                          onTap: () =>
                              showOrderDetails(order["order_transaction_id"]),
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color.fromARGB(
                                        255, 241, 239, 239)),
                                borderRadius: BorderRadius.circular(8.0),
                                color:
                                    const Color(0xfff3f3f3).withOpacity(.76)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${order["customer_name"] ?? "N/A"}',
                                      style: SafeGoogleFont(
                                        "Poppins",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xff868889),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          order["self_pickup"] == "No"
                                              ? "Door Delivery"
                                              : "Self Pickup",
                                          style: SafeGoogleFont(
                                            "Poppins",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: const Color(0xff868889),
                                          ),
                                        ),
                                        Text(
                                          order["customer_type"] != null
                                              ? order["customer_type"]
                                                  .toString()
                                              : "N/A",
                                          style: SafeGoogleFont("Poppins",
                                              color: const Color(0xff868889),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: itemImages
                                          .map((imageUrl) => Image.network(
                                              imageUrl,
                                              width: 60,
                                              height: 60))
                                          .toList(),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Order ID',
                                          style: SafeGoogleFont("Poppins",
                                              color: const Color(0xff868889),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                        Text(
                                          order["order_transaction_id"] != null
                                              ? order["order_transaction_id"]
                                                  .toString()
                                              : "N/A",
                                          style: SafeGoogleFont("Poppins",
                                              color: const Color(0xff868889),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              'ORDERED ON',
                                              style: SafeGoogleFont("Poppins",
                                                  fontSize: 15,
                                                  color:
                                                      const Color(0xff8891A5),
                                                  fontWeight: FontWeight.w500),
                                            )),
                                        Text(
                                          order["order_date"] != null
                                              ? DateFormat('MM-dd-yyyy hh:mm a')
                                                  .format(DateTime.parse(
                                                      order["order_date"]))
                                              : "N/A",
                                          style: SafeGoogleFont("Poppins",
                                              color: const Color(0xff1E222B),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'PRE ORDERED ON',
                                          style: SafeGoogleFont("Poppins",
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          order["pre_order_date"] != null
                                              ? DateFormat('MM-dd-yyyy hh:mm a')
                                                  .format(DateTime.parse(
                                                      order["pre_order_date"]))
                                              : "N/A",
                                          style: SafeGoogleFont("Poppins",
                                              color: const Color(0xff1E222B),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "${orderController.newOrderArray.length}",
                          style: SafeGoogleFont("Poppins",
                              color: const Color.fromARGB(255, 219, 213, 213)),
                        ))
                  ],
                ),
              ),
            )
          : const Center(child: Text("No record found")),
    );
  }

  void showOrderDetails(String orderId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailsPage(orderId: orderId),
      ),
    );
  }
}

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  OrderDetailsPageState createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController rejectReasonController = TextEditingController();
  final OrderManagementController orderController =
      Get.find<OrderManagementController>();
  List<dynamic> invoiceArray = [];
  bool isLoading = true;
  bool hasValue = false;
  @override
  void initState() {
    super.initState();
    getOrderInvoice(widget.orderId);
  }

  Future getOrderInvoice(String orderId) async {
    var jsonData = await orderController.getOrderInvoice(orderId);
    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        isLoading = false;
        invoiceArray = jsonData['data'];
      });
    } else {
      Future.delayed(const Duration(seconds: 4), () {
        setState(() {
          isLoading = false;
          invoiceArray = [];
        });
      });
    }
  }

  @override
  void dispose() {
    rejectReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text(
                'Order Details',
                style: SafeGoogleFont("Poppins",
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                    color: const Color(0xff808089)),
              ),
              centerTitle: true,
            ),
            body: isLoading == false
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: invoiceArray.isNotEmpty
                        ? ListView.builder(
                            itemCount: invoiceArray.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildOrderDetails(
                                  invoiceArray[index], isLoading);
                            },
                          )
                        : const Text("No data found"),
                  )
                : const SpinKitCircle(
                    color: Color(0xffAF6CDA),
                    size: 50,
                  )),
      ),
    );
  }

  Widget buildOrderDetails(Map<String, dynamic> orderDetails, bool isLoading) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Order ID: ${orderDetails["order_id"]}',
          style: SafeGoogleFont("Poppins",
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: const Color(0xff808089)),
        ),
        buildCustomerDetails(orderDetails["customerDetailArray"]),
        const SizedBox(
          height: 5,
        ),
        buildOrderSummary(orderDetails),
        const SizedBox(
          height: 5,
        ),
        buildItemsDisplay(
            orderDetails["order_detailArray"], orderDetails["order_id"]),
        const SizedBox(
          height: 5,
        ),
        buildPaymentDetails(orderDetails),
      ],
      // ),
    );
  }

  Widget buildCustomerDetails(Map<String, dynamic> customerDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
              color: Color.fromARGB(255, 224, 225, 226), width: 2.0),
        ),
        collapsedBackgroundColor: Colors.grey[300],
        initiallyExpanded: true,
        title: Text(
          'Customer Details',
          style: SafeGoogleFont("Poppins",
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: const Color(0xff808089)),
        ),
        children: [
          ListTile(
            title: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.person),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(child: Text('${customerDetails["customeName"]}')),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.home),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        child: Text('${customerDetails["customerAddress1"]}')),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Icon(Icons.phone),
                    const SizedBox(
                      width: 5,
                    ),
                    Text('${customerDetails["customerMobile"]}'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderSummary(Map<String, dynamic> orderDetails) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: const BorderSide(
              color: Color.fromARGB(255, 224, 225, 226), width: 2.0),
        ),
        collapsedBackgroundColor: Colors.grey[300],
        title: Text('Order Summary',
            style: SafeGoogleFont("Poppins",
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: const Color(0xff808089))),
        children: [
          ListTile(
            title: Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('ORDERED ON'),
                  Text('${orderDetails["order_date"]}'),
                ],
              ),
            ),
          ),
          ListTile(
            title: Row(
              children: [
                const Text('Delivery Type: '),
                Text(
                    ' ${orderDetails["self_pickup"] == "Yes" ? "Store pickUp" : "Door Delivery"}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool enableButton(List<dynamic> orderItems) {
    for (var item in orderItems) {
      if (item['order_status'] != 'New Order') {
        return false;
      }
    }
    return true;
  }

  Widget buildItemsDisplay(
      List<dynamic> orderItems, String orderTransactionid) {
    List<int> allOrdersIds = [];
    bool enableAllButtons = enableButton(orderItems);
    return Column(
      children: [
        SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Items List:",
                  style: SafeGoogleFont("Poppins",
                      color: const Color(0xff959595),
                      fontSize: 17,
                      fontWeight: FontWeight.w500)),
              enableAllButtons == true
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFF2FC321)),
                      ),
                      onPressed: () {
                        allOrdersIds.clear();
                        for (var item in orderItems) {
                          allOrdersIds.add(item['ord_id']);
                        }
                        acceptAndReject(
                            orderTransactionid, allOrdersIds, "2", "");
                      },
                      child: Text(
                        'Accept All',
                        style: SafeGoogleFont("Poppins",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container(),
              enableAllButtons == true
                  ? ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFD12E2F)),
                      ),
                      onPressed: () {
                        allOrdersIds.clear();
                        for (var item in orderItems) {
                          allOrdersIds.add(item['ord_id']);
                        }
                        showRejectReasonDialog(context, orderItems,
                            orderTransactionid, allOrdersIds);
                      },
                      child: Text(
                        'Reject All',
                        style: SafeGoogleFont("Poppins",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        const SizedBox(height: 15),
        StaticGrid(
          columnMainAxisAlignment: MainAxisAlignment.center,
          columnCrossAxisAlignment: CrossAxisAlignment.center,
          rowMainAxisAlignment: MainAxisAlignment.start,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          gap: 10,
          columnCount: 1,
          children: orderItems.map((item) {
            final imageUrl = item['pdt_image'];
            final itemName = item['item_name'];
            final ordId = item['ord_id'];
            final status = item['order_status'];
            final mrp = item['mrp'];
            final sellingPrice = item['ord_item_amount'];
            final totalAmount = item['sub_total'];
            final ordCurrency = item['ord_currency'];
            final orderStatusCode = item['order_status_code'];
            final orderQuantity = item['ord_quantity'].toString();
            final choiceDetails =
                buildChoiceDetails(item['choice'], ordCurrency, orderQuantity);

            return Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffECECEC)),
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white10,
                      blurRadius: 4,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Image.network(
                        imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        itemName,
                        style: SafeGoogleFont("Poppins",
                            color: const Color(0xff868889),
                            fontWeight: FontWeight.w500,
                            fontSize: 22),
                      ),
                      subtitle: getStatusColor(status),
                    ),
                    const Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'MRP: $mrp',
                            style: SafeGoogleFont("Poppins",
                                color: const Color(0xff959595),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          ),
                          Text(
                            'Selling Price: $sellingPrice',
                            style: SafeGoogleFont("Poppins",
                                color: const Color(0xff959595),
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                    const Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    ListTile(
                      title: Text(
                        'Choice:    $choiceDetails',
                        style: SafeGoogleFont("Poppins",
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff959595),
                            fontSize: 16),
                      ),
                    ),
                    const Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Total Amount: ${item['ord_currency']}$totalAmount',
                          style: SafeGoogleFont("Poppins",
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff959595),
                              fontSize: 16),
                        ),
                      ),
                    ),
                    if (orderStatusCode == 1 || orderStatusCode == "1") ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust border radius as needed
                                  side: const BorderSide(
                                      color: Color(
                                          0xFF2FC321)), // Define border color and width
                                ),
                              ),
                            ),
                            onPressed: () {
                              allOrdersIds.clear();
                              allOrdersIds.add(ordId);
                              acceptAndReject(
                                  orderTransactionid, allOrdersIds, "2", "");
                            },
                            child: Text(
                              'Accept',
                              style: SafeGoogleFont("Poppins",
                                  color: const Color(0xFF2FC321),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: const BorderSide(
                                      color: Color(0xFFD12E2F)),
                                ),
                              ),
                            ),
                            onPressed: () {
                              allOrdersIds.clear();
                              allOrdersIds.add(ordId);
                              showRejectReasonDialog(context, orderItems,
                                  orderTransactionid, allOrdersIds);
                            },
                            child: Text(
                              'Reject',
                              style: SafeGoogleFont("Poppins",
                                  color: const Color(0xFFD12E2F),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    },
                    if (orderStatusCode == 2 || orderStatusCode == "2") ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Adjust border radius as needed
                                  side: const BorderSide(
                                      color: Color(
                                          0xFF2FC321)), // Define border color and width
                                ),
                              ),
                            ),
                            onPressed: () {
                              allOrdersIds.clear();
                              allOrdersIds.add(ordId);
                              preparingForDelivery(
                                  orderTransactionid, allOrdersIds, "4", "");
                            },
                            child: Text(
                              'Preparing for Delivery',
                              style: SafeGoogleFont("Poppins",
                                  color: const Color(0xFF2FC321),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    },
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget getStatusColor(String status) {
    Color statusColor;
    FontWeight fontWeight = FontWeight.w600;

    switch (status) {
      case "New Order":
        statusColor = Colors.grey;
        break;
      case "Accepted":
        statusColor = Colors.green;
        break;
      case "Rejected":
        statusColor = Colors.red;
        break;
      case "Preparing for deliver":
        statusColor = Colors.orange;
        break;
      default:
        statusColor = const Color(0xff868889);
    }

    return Row(
      children: [
        Text(
          "Status: ",
          style: SafeGoogleFont("Poppins",
              color: const Color(0xff868889),
              fontWeight: FontWeight.w600,
              fontSize: 15),
        ),
        Expanded(
          child: Text(
            status,
            style: SafeGoogleFont("Poppins",
                color: statusColor, fontWeight: fontWeight, fontSize: 15),
          ),
        ),
      ],
    );
  }

  void showRejectReasonDialog(BuildContext context, List<dynamic> orderItems,
      String orderTransactionid, List<dynamic> allOrdersIds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Reason to reject All Orders',
            style: SafeGoogleFont("Poppins",
                color: const Color.fromARGB(255, 37, 37, 37), fontSize: 15),
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
                const InputDecoration(hintText: 'Enter rejection reason'),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(hasValue ==
                        true
                    ? const Color.fromARGB(255, 177, 79, 156)
                    : const Color.fromARGB(255, 177, 79, 156).withOpacity(.3)),
              ),
              onPressed: () {
                if (hasValue == true) {
                  String rejectionReason = rejectReasonController.text;

                  acceptAndReject(
                      orderTransactionid, allOrdersIds, "3", rejectionReason);
                  Navigator.of(context).pop();
                  rejectReasonController.text = '';
                }
              },
              child: Text(
                'submit',
                style: SafeGoogleFont("Poppins",
                    color: hasValue == true ? Colors.white : Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  String buildChoiceDetails(
      List<dynamic> choices, String ordCurrency, String orderQuantity) {
    String details = '';
    for (var choice in choices) {
      details += '${choice["choicename"]} X $orderQuantity\n';
    }
    return details.trim();
  }

  Widget buildPaymentDetails(Map<String, dynamic> paymentDetails) {
    final TextStyle textStyle = GoogleFonts.poppins(
      color: const Color(0xff959595),
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );
    final TextStyle textStyle1 = GoogleFonts.poppins(
      color: const Color(0xff868889),
      fontWeight: FontWeight.w600,
      fontSize: 18,
    );
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 247, 239, 239)),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order Amount:',
                    style: textStyle,
                  ),
                  Text(
                    '${paymentDetails["currency"]}${paymentDetails["grand_sub_total"]}',
                    style: textStyle,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Taxes:',
                    style: textStyle,
                  ),
                  Text('${paymentDetails["grand_tax"]}', style: textStyle),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipment Charges:', style: textStyle),
                  Text(
                      '${paymentDetails["currency"]}${paymentDetails["delivery_fee"]}',
                      style: textStyle),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Amount to Pay:', style: textStyle1),
                  Text(
                      '${paymentDetails["currency"]}${paymentDetails["grand_total"]}',
                      style: textStyle1),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 2, 10, 20),
                child: ElevatedButton(
                  onPressed: null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFFAF3BB)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/invoiceIcon.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "View Invoice",
                            style: SafeGoogleFont("Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: const Color(0xff1A2128)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future acceptAndReject(transactionId, ordId, status, rejectReason) async {
    bool val = await orderController.acceptAndRejectOrdersApi(
        transactionId, ordId, status, rejectReason);
    if (val == true) {
      setState(() {
        isLoading = true;
      });
      getOrderInvoice(widget.orderId);
    }
  }

  Future preparingForDelivery(
      transactionId, ordId, status, rejectReason) async {
    bool val = await orderController.preparingForDelivery1(
        transactionId, ordId, status);
    if (val == true) {
      setState(() {
        isLoading = true;
      });
      getOrderInvoice(widget.orderId);
    }
  }
}
