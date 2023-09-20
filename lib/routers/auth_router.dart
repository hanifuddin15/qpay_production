import 'package:fluro/fluro.dart';
import 'package:qpay/views/camera/nid_scanner/nid_back_scanner_page.dart';
import 'package:qpay/views/camera/nid_scanner/nid_front_scanner_page.dart';
import 'package:qpay/views/login/device_change_page.dart';
import 'package:qpay/views/login/forget_password_confirm_page.dart';
import 'package:qpay/views/login/forget_password_page.dart';
import 'package:qpay/views/login/login_page.dart';
import 'package:qpay/views/camera/face_verification/face_verification_page.dart';
import 'package:qpay/views/nid/nid_upload_page.dart';
import 'package:qpay/views/registration/register_email_address_page.dart';
import 'package:qpay/views/registration/register_image_verification_page.dart';
import 'package:qpay/views/registration/register_mobile_number_page.dart';
import 'package:qpay/routers/router_init.dart';
import 'package:qpay/views/registration/register_nid_verification_page.dart';
import 'package:qpay/views/registration/register_verification_page.dart';
import 'package:qpay/views/registration/registration_information_show_page.dart';

import '../views/registration/registration_nid_viewer_page.dart';

class AuthRouter implements IRouterProvider {
  static String loginPage = '/login';
  static String forgetPasswordPage = '/login/resetPassword';
  static String forgetPasswordConfirmPage = '/login/resetPasswordConfirm';
  static String changeLanguage = '/changeLanguage';
  static String changeDevice = '/login/changeDevice';
  static String registerPage = '/register';
  static String registerEmailVerificationPage = '/register/emailVerification';
  static String registerImageVerificationPage = '/register/imageVerificationPage';
  static String registerNIDVerificationPage = '/register/nidVerificationPage';
  static String faceVerification = '/register/faceVerification';
  static String nidUpdatePage = '/register/nidUpdate';
  static String nidFrontUpdatePage = '/register/nidFrontUpdatePage';
  static String nidBackUpdatePage = '/register/nidBackUpdatePage';
  static String nidImageViewerPage = '/register/nidImageViewerPage';
  static String userInformationUpdatePage = '/register/userInformationUpdatePage';
  static String registerComplete = '/register/registerComplete';

  @override
  void initRouter(FluroRouter router) {
    router.define(loginPage,
        handler: Handler(handlerFunc: (_, __) => LoginPage()));
    router.define(registerPage,
        handler: Handler(handlerFunc: (_, __) => RegisterMobileNumberPage()));
    router.define(forgetPasswordPage,
        handler: Handler(handlerFunc: (_, __) => ForgetPasswordPage()));
    router.define(forgetPasswordConfirmPage,
        handler: Handler(handlerFunc: (_, __) => ForgetPasswordConfirmPage()));
    router.define(changeDevice,
        handler: Handler(handlerFunc: (_, __) => DeviceChangePage()));
    router.define(faceVerification,
        handler: Handler(handlerFunc: (_, __) => FaceVerificationPage()));
    router.define(registerImageVerificationPage,
        handler: Handler(handlerFunc: (_, __) => RegisterImageVerificationPage()));
    router.define(registerNIDVerificationPage,
        handler: Handler(handlerFunc: (_, __) => RegisterNIDVerificationPage()));
    router.define(registerEmailVerificationPage,
        handler: Handler(handlerFunc: (_, __) => RegistrationEmailAddressPage()));
    router.define(nidFrontUpdatePage,
        handler: Handler(handlerFunc: (_, __) => NationalIdFrontScannerPage()));
    router.define(nidBackUpdatePage,
        handler: Handler(handlerFunc: (_, __) => NidBackScannerPage()));
    router.define(nidImageViewerPage,
        handler: Handler(handlerFunc: (_, __) => RegistrationNIDViewPage()));
    router.define(userInformationUpdatePage,
        handler: Handler(handlerFunc: (_, __) => RegistrationInformationShowPage()));
    router.define(registerComplete,
        handler: Handler(handlerFunc: (_, __) => RegisterVerificationPage()));
    router.define(nidUpdatePage,
        handler: Handler(handlerFunc: (_, __) => NidUploadPage()));
  }
}
