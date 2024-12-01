import 'package:flutter_demo/modules/Favourites/favourites.dart';
import 'package:flutter_demo/modules/Favourites/userProfile.dart';
import 'package:flutter_demo/modules/cart/my-cart.dart';
import 'package:flutter_demo/modules/chat/customer-chat/customer-chat.dart';
import 'package:flutter_demo/modules/chat/seller-caht/seller-chat.dart';
import 'package:flutter_demo/modules/checkout/checkout.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/Address.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/buyer-store-front.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/myorderHistory.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/product-display.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/single-product.dart';
import 'package:flutter_demo/modules/dashboard-page/buyer/wallet.dart';
import 'package:flutter_demo/modules/dashboard-page/customer-products-interests.dart';
import 'package:flutter_demo/modules/dashboard-page/dashboard.dart';
import 'package:flutter_demo/modules/home_page/view/home_view.dart';
import 'package:flutter_demo/modules/login/login-choice/login-type.dart';
import 'package:flutter_demo/modules/login/login-new-design/emailLogin.dart';
import 'package:flutter_demo/modules/login/login-new-design/forgotPassword.dart';
import 'package:flutter_demo/modules/login/login-new-design/loginMain.dart';
import 'package:flutter_demo/modules/login/login-new-design/numberLogin.dart';
import 'package:flutter_demo/modules/login/login-new-design/numberloginOtp.dart';
import 'package:flutter_demo/modules/login/login-options-page.dart';
import 'package:flutter_demo/modules/login/login-registration-steps/login-reg-otp.dart';
import 'package:flutter_demo/modules/login/login-registration-steps/login-reg-terms-3.dart';
import 'package:flutter_demo/modules/login/login-registration-steps/login-reg-user-details-2.dart';
import 'package:flutter_demo/modules/login/login-registration-steps/login-reg-verification.dart';
import 'package:flutter_demo/modules/login/login-switch/login-switch-new.dart';
import 'package:flutter_demo/modules/login/social%20media%20accounts/facebook/facebook_main.dart';
import 'package:flutter_demo/modules/order-management/order-management.dart';
import 'package:flutter_demo/modules/payment-methods/payment-methods.dart';
import 'package:flutter_demo/modules/product-page/cardIncrement.dart';
import 'package:flutter_demo/modules/product-page/createProduct.dart';
import 'package:flutter_demo/modules/product-page/view-product.dart';
import 'package:flutter_demo/modules/store/createStore.dart';
import 'package:flutter_demo/modules/store/individual-store-page.dart';
import 'package:flutter_demo/modules/store/store-dashboard-all-store.dart';
import 'package:flutter_demo/modules/terms-privacy-policy/aboutBunny.dart';
import 'package:flutter_demo/modules/terms-privacy-policy/bankDetails.dart';
import 'package:flutter_demo/modules/terms-privacy-policy/help.dart';
import 'package:flutter_demo/modules/terms-privacy-policy/privacy-policy.dart';
import 'package:flutter_demo/modules/terms-privacy-policy/termsService.dart';
import 'package:flutter_demo/modules/underContruction.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

class AppRoutes {
  static const String initialRoute = '/splashScreen';

  static const String loginOptions = '/loginOptions';

  static const String loginRegOTP = '/loginReg-otp';

  static const String loginRegVerification = '/loginReg-verification';

  static const String loginRegUserDetails = '/loginReg-userDetails';

  static const String loginRegTerms = '/loginReg-terms';

  static const String loginType = '/loginType';

  static const String privacyPolicy = '/privacy-policy';

  static const String termsServices = '/terms-services';

  static const String customerProductInterests = '/customerProductInterests';

  static const String login = '/login2';

  static const String dashboard = '/dashboard';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String facebookLogin = '/facebook-login';

  static const String storeRegistrationPage = '/storeRegistrationPage';

  static const String storeDashboardIndividual = '/storeDashboardIndividual';

  static const String storeDashboardAll = '/storeDashboardAll';

  static const String addProduct = '/addProduct';

  static const String addProduct222 = '/addProduct222';

  static const String displayMoreProducts = '/displayMoreProducts';

  static const String viewProducts = '/viewProducts';

  static const String productDetail = '/productDetail';

  static const String myCart = '/myCart';

  static const String imagePicker = '/imagePicker';

  // static const String userLocation = '/userLocation';

  static const String loginPage = '/loginPage';

  static const String emailLogin = '/emailLogin';

  static const String numberLogin = '/numberLogin';

  static const String numberLoginOtp = '/numberLoginOtp';

  static const String forgotPassword = '/forgotPassword';

  static const String checkout = '/checkout';

  static const String buyerstore = '/Buyerstore';
  static const String payment = '/payment';

  static const String wallet = '/wallet';

  static const String yourAddress = '/YourAddress';

  static const String stripePayment = '/stripePayment';

  static const String favourites = '/favourites';

  static const String userProfile = '/userProfile';

  static const String orderManagement = '/orderManagement';

  static const String underConstructionPage = '/underConstructionPage';

  static const String orderHistory = '/orderHistory';

  static const String bankDetails = '/bankDetails';

  static const String help = '/help';

  static const String aboutBunny = '/aboutBunny';

  static const String customerAllChat = '/customerAllChat';

  static const String sellerChat = '/sellerChat';

  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => HomePage(),
    ),
    GetPage(name: loginOptions, page: () => const LoginOptionsScreen()),
    GetPage(name: loginRegOTP, page: () => const LoginRegOTP()),
    GetPage(
        name: loginRegVerification, page: () => const LoginRegVerification()),
    GetPage(
        name: loginRegUserDetails, page: () => const LoginRegUserDetailsPage()),
    GetPage(name: loginRegTerms, page: () => LoginRegTermsPage()),
    GetPage(name: loginType, page: () => const LoginChooseType()),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicy()),
    GetPage(name: termsServices, page: () => const TermsAndServices()),
    GetPage(
        name: customerProductInterests,
        page: () => const CustomerProductInterests()),
    GetPage(name: login, page: () => const LoginSwitch()),
    GetPage(name: dashboard, page: () => const Dashboard()),
    GetPage(name: facebookLogin, page: () => const FaceBookMain()),
    GetPage(name: storeRegistrationPage, page: () => const CreateStorePage()),
    GetPage(
        name: storeDashboardIndividual,
        page: () => const IndividualStorePage()),
    GetPage(name: storeDashboardAll, page: () => const StoreDashboardAll()),
    GetPage(name: addProduct, page: () => const ProductCreationPage()),
    // GetPage(
    //     name: addProduct222,
    //     page: () => UpdateProductPage(
    //         isEditProduct: false,
    //         storeId: '',
    //         individualproductitem: Individualproductitem(
    //           itemImg: '',
    //           itemName: '',
    //           itemQuantity: '',
    //           itemDescription: '',
    //           itemCategoryName: '',
    //           itemSubCategoryName: '',
    //         ))),
    GetPage(
        name: displayMoreProducts, page: () => const ProductSubcategoryList()),
    GetPage(name: viewProducts, page: () => const ViewAllProducts()),
    GetPage(name: productDetail, page: () => const ProductDetailPage()),
    GetPage(name: imagePicker, page: () => const MyApp()),
    GetPage(name: myCart, page: () => const MyCart()),
    // GetPage(name: userLocation, page: () => const UserLocation()),
    GetPage(name: loginPage, page: () => const LoginMain()),
    GetPage(name: emailLogin, page: () => const EmailLogin()),
    GetPage(name: numberLogin, page: () => const NumberLogin()),
    GetPage(name: numberLoginOtp, page: () => const NumberLoginOtp()),
    GetPage(name: forgotPassword, page: () => const ForgotPassword()),
    GetPage(name: checkout, page: () => const Checkout()),
    GetPage(name: buyerstore, page: () => const Buyerstore()),
    GetPage(name: payment, page: () => const Payment()),
    GetPage(name: wallet, page: () => const Wallet()),
    GetPage(name: yourAddress, page: () => const Address()),
    GetPage(
        name: stripePayment,
        page: () => StripePayment(
              amount: '',
              onPaymentResult: (String v) {},
              currency: '',
            )),
    GetPage(name: favourites, page: () => const Favorites()),
    GetPage(name: userProfile, page: () => const Profile()),
    GetPage(name: orderManagement, page: () => const OrderManagement()),
    GetPage(
        name: underConstructionPage,
        page: () => const UnderConstructionPage(
              pageTitle: '',
            )),
    GetPage(name: orderHistory, page: () => const OrderHistory()),
    GetPage(name: bankDetails, page: () => const BankDetails()),
    GetPage(name: help, page: () => const Help()),
    GetPage(name: aboutBunny, page: () => const AboutBunny()),
    GetPage(name: customerAllChat, page: () => const CustomerAllChat()),
    GetPage(name: sellerChat, page: () => const SellerChat()),
  ];
}
