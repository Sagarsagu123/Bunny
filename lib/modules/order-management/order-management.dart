import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/order-management/new-order.dart';
import 'package:flutter_demo/modules/order-management/preparing.dart';
import 'package:flutter_demo/modules/order-management/processing.dart';
import 'package:get/get.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  OrderManagementState createState() => OrderManagementState();
}

class OrderManagementState extends State<OrderManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  final List<Map<String, dynamic>> tabs = [
    {'name': 'New', 'id': 0},
    {'name': 'Accepting', 'id': 1},
    {'name': 'Preparing', 'id': 2}
  ];

  int? orderType;
  @override
  void initState() {
    super.initState();
    final Map<String, dynamic>? parameters =
        Get.arguments as Map<String, dynamic>?;
    if (parameters != null && parameters.containsKey('type')) {
      if (parameters['type'] == "new_order") {
        orderType = 0;
      } else if (parameters['type'] == "process_order") {
        orderType = 1;
      }
    }
    _tabController = TabController(
        length: tabs.length, vsync: this, initialIndex: orderType ?? 0);
    _tabController.addListener(_handleTabSelection);
    _selectedTabIndex = _tabController.index;
  }

  void _handleTabSelection() {
    setState(() {
      _selectedTabIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Orders',
              style: TextStyle(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: Color(0xff808089),
                fontSize: 24,
              ),
            ),
            centerTitle: true,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xffECECEC)),
                    borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                    color: const Color(0xffAF6CDA),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    onTap: (index) {
                      setState(() {
                        _tabController.index = index;
                      });
                    },
                    tabs: tabs
                        .map((tab) => Padding(
                              padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: _selectedTabIndex == tab['id']
                                      ? Colors.white
                                      : const Color.fromARGB(0, 214, 28, 28),
                                ),
                                child: Tab(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: SizedBox(
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          tab['name'],
                                          style: TextStyle(
                                            fontFamily: "Poppins",
                                            fontSize:
                                                _selectedTabIndex == tab['id']
                                                    ? 12
                                                    : 12,
                                            color:
                                                _selectedTabIndex == tab['id']
                                                    ? const Color(0xffAF6CDA)
                                                    : Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                    labelStyle: const TextStyle(
                      color: Color.fromARGB(255, 82, 184, 78),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: const [
              NewOrder(),
              Processing(),
              Preparing(),
            ],
          ),
        ),
      ),
    );
  }
}
