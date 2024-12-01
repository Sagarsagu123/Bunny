import 'package:flutter_demo/services/api_services.dart';
import 'package:get/get.dart';

class OrderManagementController extends GetxController {
  List<dynamic> newOrderArray = [];
  List<dynamic> processingOrderArray = [];
  List<dynamic> prearingOrderArray = [];
  List<dynamic> listOfDeliveryPersons = [];
  List<dynamic> listOfVehicles = [];
  List<dynamic> orderDetailArray = [];
  List<dynamic> pendingDetails = [];
  List<dynamic> fulfilledDetails = [];
  List<dynamic> cancelledDetails = [];

  String? selectedDeliveryBoy;
  int? selectedDeliveryBoyID;
  int? selectedDeliveryManagerID;

  String? selectedVehicle;
  int? selectedVehicleID;
  newOrder() async {
    var jsonData = await ApiService.newOrder();
    if (jsonData != null && jsonData['code'] == 400) {
    } else {
      if (jsonData['data'] != null) {
        return jsonData;
      }
    }
  }

  getOrderInvoice(String orderId) async {
    var jsonData = await ApiService.getOrderInvoice(orderId);
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
    } else {
      return jsonData;
    }
  }

  Future acceptAndRejectOrdersApi(String transactionId, List<int> ordId,
      String status, String rejectReason) async {
    final order = OrderOperation(
      transactionId: transactionId,
      ordId: ordId,
      status: status,
      rejectReason: rejectReason,
    );
    var jsonData = await ApiService.acceptRejectOrder(order);
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
    } else {
      if (jsonData['code'] == 500) {
        Get.snackbar('Failure', jsonData['message'],
            snackPosition: SnackPosition.bottom,
            duration: const Duration(milliseconds: 2000));
      } else {
        return true;
      }
    }
  }

  Future processingOrder() async {
    var jsonData = await ApiService.processingOrder();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
    } else {
      if (jsonData['data'] != null) {
        return jsonData;
      }
    }
  }

  Future preparingForDelivery1(
      String transactionId, List<int> ordId, String status) async {
    var jsonData =
        await ApiService.preparingForDelivery(transactionId, ordId, status);
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 2000));
    } else {
      if (jsonData != null && jsonData['code'] == 500) {
        Get.snackbar('Failure', jsonData['message'],
            snackPosition: SnackPosition.bottom,
            duration: const Duration(milliseconds: 2000));
      } else {
        if (jsonData != null && jsonData['code'] == 200) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  Future preparingOrder() async {
    var jsonData = await ApiService.preparingOrder();
    if (jsonData != null && jsonData['code'] == 400) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
    } else {
      if (jsonData['data'] != null) {
        return jsonData;
      }
    }
  }

  Future getDeliveryBoys() async {
    var jsonData = await ApiService.getDeliveryBoys();
    return jsonData;
  }

  Future getStoreVehicle(String orderTransactionId) async {
    var jsonData = await ApiService.getStoreVehicle(orderTransactionId);
    return jsonData;
  }

  Future assignDeliveryBoy(String delboyId, String orderId, String delManagerId,
      String vehicleId) async {
    var jsonData = await ApiService.assignDeliveryBoy(
        delboyId, orderId, delManagerId, vehicleId);
    return jsonData;
  }

  Future getOrdetDetails(String orderId) async {
    var jsonData = await ApiService.getOrdetDetails(orderId);
    return jsonData;
  }

  Future cancelOrder(String id, String rejectReason, String type) async {
    var jsonData = await ApiService.cancelOrder(id, rejectReason, type);
    if (jsonData == null && jsonData['code'] == 400 ||
        jsonData['code'] == 500) {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
    } else {
      Get.snackbar('Failure', jsonData['message'],
          snackPosition: SnackPosition.bottom,
          duration: const Duration(milliseconds: 1200));
      return jsonData;
    }
  }
}

class OrderOperation {
  final String transactionId;
  final List<int> ordId;
  final String status;
  final String rejectReason;

  OrderOperation(
      {required this.transactionId,
      required this.ordId,
      required this.status,
      required this.rejectReason});
}
