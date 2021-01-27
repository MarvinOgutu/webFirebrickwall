import 'package:FwrWeb/src/components/renewal/renewal_components.template.dart' as renewal_template;
import 'package:FwrWeb/src/components/signupPage/signup_component.template.dart' as signup_template;
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:FwrWeb/src/components/dashboard.template.dart' as dashboard_template;

import 'package:FwrWeb/src/components/loginpage/loggin_component.template.dart' as login_template;
import 'package:FwrWeb/src/components/consolePage/console_page_component.template.dart' as console_template;
import 'package:FwrWeb/src/components/paymentPage/paymentpage_components.template.dart' as payment_template;
import 'package:FwrWeb/src/components/passwordResetPage/passwordReset_component.template.dart' as pwdreset_template;




class Routes {
  static final dashboard = RouteDefinition(
    routePath: RoutePaths.dashboard,
    component: dashboard_template.DashboardComponentNgFactory,
  );
  static final login = RouteDefinition(
    routePath: RoutePaths.login,
    component: login_template.loginFormComponentNgFactory,
  );
  static final console = RouteDefinition(
    routePath: RoutePaths.console,
    component: console_template.ConsoleNgFactory,
  );
  static final signup = RouteDefinition(
    routePath: RoutePaths.signup,
    component: signup_template.signupComponentNgFactory,
  );
  static final checkout = RouteDefinition(
    routePath: RoutePaths.checkout,
    component: payment_template.paymentFormComponentNgFactory,
  );
  static final pwdreset = RouteDefinition(
    routePath: RoutePaths.pwdreset,
    component: pwdreset_template.passwordResetComponentNgFactory,
  );
  static final renewal = RouteDefinition(
    routePath: RoutePaths.renewal,
    component: renewal_template.RenewalComponentNgFactory,
  );


  static final all = <RouteDefinition>[
    dashboard,
    login,
    console,
    signup,
    checkout,
    pwdreset,
    renewal,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.dashboard.toUrl(),
    ),
  ];

}