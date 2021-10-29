import 'package:get/get.dart';

import '../screens/about.dart';
import '../screens/admin/create_policy.dart';
import '../screens/admin/policy_list.dart';
import '../screens/auth/sign_in.dart';
import '../screens/auth/sign_up.dart';
import '../screens/dashboard.dart';
import '../screens/download_pdf.dart';
import '../screens/inquiry_policy.dart';
import '../screens/new_policy.dart';
import '../screens/policy__detail_selection.dart';
import '../screens/select_policy.dart';
import '../screens/splash.dart';
import '../screens/submit_policy.dart';
import '../screens/tax_benefits.dart';

class CustomRouter {
  static List<GetPage> pages = [
    GetPage(name: '/', page: () => Splash()),
    GetPage(name: 'sign-in', page: () => SignIn()),
    GetPage(name: 'sign-up', page: () => SignUp()),
    GetPage(name: 'home', page: () => Dashboard()),
    GetPage(name: 'create-policy', page: () => CreatePolicy()),
    GetPage(name: 'policy-list', page: () => PolicyList()),
    GetPage(name: 'inquiry-policy', page: () => InquiryPolicy()),
    GetPage(name: 'download-pdf', page: () => DownloadPDF()),
    GetPage(name: 'new-policy', page: () => NewPolicy()),
    GetPage(name: 'selected-policy', page: () => SelectPolicy()),
    GetPage(name: 'submit-policy', page: () => SubmitPolicy()),
    GetPage(name: 'tax-benefits', page: () => TaxBenefits()),
    GetPage(name: 'about-us', page: () => AboutUs()),
    GetPage(name: 'policy-detail-selection', page: () => PolicyDetailSelection()),
  ];
}
