import 'package:flutter/material.dart';
import 'package:flutter_demo/modules/cart/my-cart.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:get/get.dart';

class BankDetails extends StatefulWidget {
  const BankDetails({super.key});

  @override
  BankDetailsState createState() => BankDetailsState();
}

class BankDetailsState extends State<BankDetails> {
  final DashboardController dashboardController =
      Get.find<DashboardController>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController sellerAccountNameController = TextEditingController();
  TextEditingController sellerAccountNumberController = TextEditingController();
  TextEditingController achWireTransferRoutingController =
      TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();
  TextEditingController branchNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController areaCodeController = TextEditingController();
  List<dynamic> bankDetails = [
    {
      'seller_account_name': '',
      'seller_account_number': '',
      'ach_wire_transfer_routing': '',
      'swift_code': '',
      'branch_name': '',
      'city': '',
      'state': '',
      'area_code': '',
    }
  ];
  @override
  void initState() {
    super.initState();
    fetchBankDetails();
  }

  Future<void> fetchBankDetails() async {
    var jsonData = await dashboardController.fetchBankDetails();
    if (jsonData != null && jsonData['data'] != null) {
      setState(() {
        bankDetails = jsonData['data'];
        // updateControllers(bankDetails);

        if (jsonData['data'][0]['seller_account_name'] != null) {
          sellerAccountNameController.text =
              bankDetails[0]['seller_account_name'].toString();
        } else {
          sellerAccountNameController.text = "";
        }
        if (jsonData['data'][0]['seller_account_number'] != null) {
          sellerAccountNumberController.text =
              bankDetails[0]['seller_account_number'].toString();
        } else {
          sellerAccountNumberController.text = "";
        }
        if (jsonData['data'][0]['ach_wire_transfer_routing'] != null) {
          achWireTransferRoutingController.text =
              bankDetails[0]['ach_wire_transfer_routing'].toString();
        } else {
          achWireTransferRoutingController.text = "";
        }
        if (jsonData['data'][0]['swift_code'] != null) {
          swiftCodeController.text = bankDetails[0]['swift_code'].toString();
        } else {
          swiftCodeController.text = "";
        }
        if (jsonData['data'][0]['branch_name'] != null) {
          branchNameController.text = bankDetails[0]['branch_name'].toString();
        } else {
          branchNameController.text = "";
        }
        if (jsonData['data'][0]['city'] != null) {
          cityController.text = bankDetails[0]['city'].toString();
        } else {
          cityController.text = "";
        }
        if (jsonData['data'][0]['state'] != null) {
          stateController.text = bankDetails[0]['state'].toString();
        } else {
          stateController.text = "";
        }
        if (jsonData['data'][0]['area_code'] != null) {
          areaCodeController.text = bankDetails[0]['area_code'].toString();
        } else {
          areaCodeController.text = "";
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Scaffold(
          appBar: appBar(dashboardController, "Bank details", context, true),
          body: SingleChildScrollView(
              child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    dashboardController.isStoreCreated == true
                        ? Column(
                            children: [
                              const SizedBox(height: 20),
                              _buildBankDetailFields(),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                    const Color(0xffAF6CDA),
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    updateBankDetails();
                                  }
                                },
                                child: const Text(
                                  'Update',
                                  style: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          )
                        : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 300,
                                  child: Text(
                                      "Bank Detais needed for Seller only"),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ),
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildBankDetailFields() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Seller Account Name',
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            controller: sellerAccountNameController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter seller account name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: sellerAccountNumberController,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              labelText: 'Seller Account Number',
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter seller account number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: achWireTransferRoutingController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'ACH/Wire Transfer Routing'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter ACH/Wire Transfer Routing number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: swiftCodeController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Swift Code'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Swift Code';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: branchNameController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Branch Name'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Branch Name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: cityController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'City'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter City name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: stateController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'State'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter State';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: areaCodeController,
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 15.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Area Code'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter Area Code';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Future<void> updateBankDetails() async {
    setState(() {
      bankDetails = [
        {
          'seller_account_name': sellerAccountNameController.text,
          'seller_account_number': sellerAccountNumberController.text,
          'ach_wire_transfer_routing': achWireTransferRoutingController.text,
          'swift_code': swiftCodeController.text,
          'branch_name': branchNameController.text,
          'city': cityController.text,
          'state': stateController.text,
          'area_code': areaCodeController.text,
        }
      ];
    });
    var json = await dashboardController.updateBankDetailsAPI(bankDetails);
    if (json != null && json['code'] == 200) {
      Get.snackbar('Success', json['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1500));
      await Future.delayed(const Duration(seconds: 3));
      Get.toNamed('/dashboard');
    }
  }
}
