var errorThisFieldRequired = 'This field is required';
// const currencySymbol = '₹';
const currencySymbol = 'da';

const mBaseUrl = 'http://127.0.0.1:8000/api/';

const CLIENT = 'client';
const DELIVERYMAN = 'delivery_man';

const passwordLengthGlobal = 6;
const defaultRadius = 8.0;
const defaultSmallRadius = 6.0;

const textPrimarySizeGlobal = 16.00;
const textBoldSizeGlobal = 16.00;
const textSecondarySizeGlobal = 14.00;
const borderRadius = 16.00;

double tabletBreakpointGlobal = 600.0;
double desktopBreakpointGlobal = 720.0;
double statisticsItemWidth = 230.0;

const RESTORE = 'restore';
const FORCE_DELETE = 'forcedelete';

const CHARGE_TYPE_FIXED = 'fixed';
const CHARGE_TYPE_PERCENTAGE = 'percentage';

const PAYMENT_GATEWAY_STRIPE = 'stripe';
const PAYMENT_GATEWAY_RAZORPAY = 'razorpay';
const PAYMENT_GATEWAY_PAYSTACK = 'paystack';
const PAYMENT_GATEWAY_FLUTTERWAVE = 'flutterwave';
const PAYMENT_GATEWAY_PAYPAL = 'paypal';
const PAYMENT_GATEWAY_PAYTABS = 'paytabs';
const PAYMENT_GATEWAY_MERCADOPAGO = 'mercadopago';
const PAYMENT_GATEWAY_PAYTM = 'paytm';
const PAYMENT_GATEWAY_MYFATOORAH = 'myfatoorah';
const PAYMENT_TYPE_CASH = 'cash';

const ORDER_DRAFT = 'draft';
const ORDER_DEPARTED = 'courier_departed';
const ORDER_ACTIVE = 'active';
const ORDER_CREATED = 'create';
const ORDER_CANCELLED = 'cancelled';
const ORDER_DELAYED = 'delayed';
const ORDER_ASSIGNED = 'courier_assigned';
const ORDER_ARRIVED = 'courier_arrived';
const ORDER_PICKED_UP = 'courier_picked_up';
const ORDER_COMPLETED = 'completed';
const ORDER_CREATE = 'create';
const ORDER_TRANSFER = 'courier_transfer';
const ORDER_PAYMENT = 'payment_status_message';
const ORDER_FAIL = 'failed';

const DIALOG_TYPE_DELETE = 'Delete';
const DIALOG_TYPE_RESTORE = 'Restore';
const DIALOG_TYPE_ENABLE = 'Enable';
const DIALOG_TYPE_DISABLE = 'Disable';

const TOKEN = 'TOKEN';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const USER_TYPE = 'USER_TYPE';
const USER_EMAIL = 'USER_EMAIL';
const USER_PASSWORD = 'USER_PASSWORD';

const PAYMENT_ON_PICKUP = 'on_pickup';
const PAYMENT_ON_DELIVERY = 'on_delivery';
const DEMO_ADMIN = 'demo_admin';

/* Theme Mode Type */
const ThemeModeLight = 0;
const ThemeModeDark = 1;
const THEME_MODE_INDEX = 'theme_mode_index';
const SELECTED_LANGUAGE_CODE = 'selected_language_code';

const default_Language = 'en';

//region LiveStream Keys
const streamLanguage = 'streamLanguage';
const streamDarkMode = 'streamDarkMode';

const FIXED_CHARGES = "fixed_charges";
const MIN_DISTANCE = "min_distance";
const MIN_WEIGHT = "min_weight";
const PER_DISTANCE_CHARGE = "per_distance_charges";
const PER_WEIGHT_CHARGE = "per_weight_charges";

// Menu Index
const DASHBOARD_INDEX = 0;
const COUNTRY_INDEX = 1;
const CITY_INDEX = 2;
const EXTRA_CHARGES_INDEX = 3;
const PARCEL_TYPE_INDEX = 4;
const PAYMENT_GATEWAY_INDEX = 5;
const ORDER_INDEX = 6;
const DOCUMENT_INDEX = 7;
const DELIVERY_PERSON_DOCUMENT_INDEX = 8;
const USER_INDEX = 9;
const DELIVERY_PERSON_INDEX = 10;
const NOTIFICATION_SETTING_INDEX = 11;
