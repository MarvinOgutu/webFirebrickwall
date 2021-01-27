import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';



// AngularDart info: https://angulardart.dev
// Components info: https://angulardart.dev/components

@Component(
  selector: 'my-app',
  styleUrls: ['app_component.css'],
  templateUrl: 'app_component.html',
  // directives: [TodoListComponent,AppHeader],
  directives: [routerDirectives],
  exports: [RoutePaths, Routes],
)
class AppComponent {
  // Nothing here yet. All logic is in TodoListComponent.
}
