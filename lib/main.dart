import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard-controller.dart';
import 'package:flutter_demo/modules/login/login-controller.dart';
import 'package:flutter_demo/modules/order-management/order-management-controller.dart';
import 'package:flutter_demo/routes/app_routes.dart';
import 'package:flutter_demo/utils.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // assert(() {
  //   debugPaintSizeEnabled = false;
  //   return true;
  // }());
  WidgetsFlutterBinding.ensureInitialized();
  allDependencies();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  runApp(MyApp(isLoggedIn: isLoggedIn));
  debugDumpRenderTree();
}

void allDependencies() {
  Get.put(LoginController());
  Get.put(DashboardController());
  Get.put(OrderManagementController());
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});
  @override
  Widget build(BuildContext context) {
    const String initialRoute = '/splashScreen';
    const String dashboard = '/dashboard';
    return SizedBox(
      width: Get.width > 600 ? 600 : 500,
      child: GetMaterialApp(
        title: 'Bunny',
        initialRoute: isLoggedIn == false ? initialRoute : dashboard,
        debugShowCheckedModeBanner: false,
        scrollBehavior: MyCustomScrollBehavior(),
        getPages: AppRoutes.pages,
        theme: ThemeData(
          useMaterial3: true,
          visualDensity: VisualDensity.standard,
        ),
        themeMode: ThemeMode.light,
      ),
    );
  }
}
