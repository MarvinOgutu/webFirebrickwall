import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

@Component(
  selector: 'my-dashboard',
  templateUrl: './dashboard_component.html',
  styleUrls: ['./dashboard_component.css'],
  directives: [coreDirectives,routerDirectives],
  exports: [RoutePaths, Routes],

)
class DashboardComponent {}