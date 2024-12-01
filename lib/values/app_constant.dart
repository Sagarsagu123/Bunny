// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:get/get.dart';
//avoid_web_libraries_in_flutter

double SCREEN_WIDTH = Get.width;
const int PAGE_WIDTH_BREAKPOINT = 800;
bool isScreenLarge = SCREEN_WIDTH <= PAGE_WIDTH_BREAKPOINT;

// const double appBarHeight = 75;
const bool isDevMode = true;
const double appBarHeight = 56;
bool is_prod = true;
// String ROUTE = is_prod == false ? "marjins.local" : "shop-bunny.@com";
String ROUTE = is_prod == false ? "marjins.local" : "buywithbunny.com";

String PRIVACYPOLICY = "https://buywithbunny.com/privacy-policy";
String TERMAANDCONDITIONS = "https://buywithbunny.com/terms-and-conditions";

bool TESTING_MODE = true;
// Store_id == restuarant_id
const String SEND_OTP_SIGN_UP = "/api/send_signup_otp"; // sign up

const String VERIFY_OTP = "/api/verify_signup_otp"; // sign up

const String SEND_OTP_SIGN_IN = "/api/send_signin_otp"; // Sign inP
const String VERIFY_OTP_LOGIN = "/api/verify_signin_otp"; // sign in

const String UPDATE_CUSTOMER_INFO_REG = "/api/customer/update_user_profile_reg";

const String CUSTOMER_LOGIN_TYPE = "/api/customer/customer_login_type";

const String GET_CATEGORY_LIST =
    "/api/customer/get_store_categories"; // Need to delete
const String GET_MAIN_PRODUCT_CATEGORY =
    "/api/customer/get_main_product_categories1";

const String UPDATE_CATEGORY_INTERESTS =
    "/api/customer/update_customer_interested_categories";

const String EMAIL_LOGIN = "/api/user_login";

const String EMAIL_CHECK = "/api/user_email_check";

const String GOOGLE_LOGIN = "/api/google_login";

// Store
const String CREATE_STORE = "/api/customer/create_store";

const String UPDATE_STORE = "/api/customer/update_store";

const String GET_CUSTOMER_STORE_LIST = "/api/customer/get_customer_store_list";

const String DISABLE_STORE = "/api/customer/disable_store";

const String GET_ALL_CHOICES = "/api/customer/get_all_choices";

const String ADD_PRODUCT = "/api/customer/save_item_mobileapp";

const String SUB_CATEGORY_PROD = "/api/customer/get_sub_category";

const String FETCH_INDIVIDUAL_PRODUCT_ITEMS =
    "/api/customer/category_based_items";
const String GET_ALL_PRODUCT_ITEMS = "/api/customer/stock_management";
const String ADD_TO_CART = "/api/customer/add_to_cart";

const String REMOVE_TO_CART = "/api/customer/remove_from_cart";

const String MY_CART = "/api/customer/v1/my-cart";
const String REMOVE_ALL_FROM_CART = "/api/customer/remove_all_from_cart";
const String UPDATE_USER_LOCATION = "/api/customer/save_shipping_address";
const String FORGOT_PASSWORD = "/api/forgot_password";
const String CART_DELIVERY_DETAILS = "/api/customer/v1/delivery-option-details";
const String CUSTOMER_SHIP_ADDRESS = "/api/customer/customer_ship_address";
const String GET_INDIVIDUAL_STORE_DATA = "/api/customer/restaurant_details";
const String UPDATE_CHECKOUT_INFO =
    "/api/customer/pre_order_date_check_shipping_address";

const String GET_CUSTOMER_PROFILE_DETAIL = "/api/customer/customer_my_account";
const String ADDRESS_CUSTOMER = "/api/customer/customer_update_shipadd";

const String PAYMENT = "/api/customer/payment_methods";

const String USE_WALLET = "/api/customer/use_wallet";

const String MY_WALLET = "/api/customer/my_wallet";

const String COD_CHECKOUT = "/api/customer/cod_checkout";

const String WALLET_CHECKOUT = "/api/customer/wallet_checkout";

const String STRIPE_CHECKOUT = "/api/customer/stripe_checkout";

const String LOG_OUT = "/api/customer/customer_logout";

const String CHANGE_PASSWORD = "/api/customer/customer_reset_password";

const String GET_CUST0MER_PROFILE = "/api/customer/customer_my_account";
// user Profile
const String UPDATE_CUST0MER_PROFILE = "/api/customer/update_user_profile";
const String GET_MERCHANT_AUTH_CODE = "/api/customer_mer_login";

const String MERCHANT_DASHBOARD = "/api/merchant/dashboard";

const String NEW_ORDER = "/api/merchant/new-orders";

const String INVOICE_DETAILS = "/api/merchant/invoice-detail";

const String ACCEPT_REJECT_ORDER = "/api/merchant/accept-reject-item";

const String CHANGE_ORDER_STATUS = "/api/merchant/change-status";

const String PROCESSING_ORDER = "/api/merchant/processing-orders";

const String PREPARING_ORDER = "/api/merchant/preparing-orders";

const String ALL_DELIVERY_BOYS = "/api/merchant/delivery-boys";

const String GET_STORE_VEHICLE = "/api/merchant/get-store-vehicle";

const String ASSIGN_DELIVERY_BOY = "/api/merchant/assign-delivery-boy";

const String MY_ORDER_HISTORY = "/api/customer/my_orders";

const String GET_BANK_ACCOUNT_DETAILS =
    "/api/customer/get-bank-account-details";

const String UPDATE_BANK_ACCOUNT_DETAILS =
    "/api/customer/update-bank-account-details";
const String STRIPE_INITIAL_INTENT = "/api/customer/initiate-stripe-payment";
const String STRIPE_TRANSACTION_STATUS =
    "/api/customer/check-stripe-payment-status";
const String GET_INDIVIDUAL_PRODUCT_DETAIL = "/api/customer/item_details";
const String GET_ORDER_DETAIL = "/api/customer/my_order_details";

const String CANCEL_SINGLE_ORDER = "/api/customer/cancel_order";

const String CANCEL_ENTIRE_ORDER = "/api/customer/cancel-entire-order";

const String GET_ALL_PRODUCT_LABELS = "/api/customer/get-labels";

const String SET_FAVORITE = "/api/customer/add_to_wishlist";

const String GET_ALL_FAVORITE = "/api/customer/customer_wishlist";

const String GET_ALL_CUSTOMER_CHATS = "/api/customer/get-chats";

const String GET_MESSAGES_FROM_CHAT_ID = "/api/customer/get-chats-by-id";

const String SEND_MSG_FROM_CUSTOMER = "/api/customer/send-message";
// Merchant
const String GET_ALL_STORE_CHATS = "/api/merchant/get-chats";

const String GET_STORE_MESSAGES_FROM_CHAT_ID = "/api/merchant/get-chats-by-id";

const String SEND_MSG_REPLY_TO_CUSTOMER = "/api/merchant/send-message";

// From cutomer
const String UPDATE_FLAG_FROM_CUSTOMER = "/api/customer/update-chat";

const String UPDATE_FLAG_FROM_SELLER = "/api/merchant/update-chat";
