import 'dart:convert';

import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:http/http.dart' as http;

@Component(
  selector: 'hero-form',
  templateUrl: './paymentpage_component.html',
  styleUrls: ['./paymentpage_component.css'],
  directives: [routerDirectives,coreDirectives, formDirectives],
  exports: [RoutePaths, Routes],
)
class paymentFormComponent {

}
