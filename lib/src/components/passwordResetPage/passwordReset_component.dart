import 'dart:convert';
import 'dart:html';

import 'package:angular_forms/angular_forms.dart';
import 'package:http/http.dart' as http;

import 'package:FwrWeb/src/components/passwordResetPage/passwordResetService.dart';
import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:FwrWeb/src/components/loginpage/loggin_component.dart';

@Component(
  selector: 'my-pwdreset',
  templateUrl: './passwordReset_component.html',
  styleUrls: ['./passwordReset_component.css'],
  directives: [coreDirectives,routerDirectives,formDirectives],
  providers: [ClassProvider(pwdResetService)],

)
class passwordResetComponent implements OnInit {
  final pwdResetService _resetService;
  String email;
  final Router _router;

  passwordResetComponent(this._resetService, this._router);

  void _getEmail() {
    email = _resetService.email;
    print('email: $email');
  }
  void ngOnInit() => _getEmail();
  void onSubmit() {

    print('sending link');
    sendResetHttp();
  }
  Future<NavigationResult> _gotoForgetPwd(String url) =>
      _router.navigate(url);
  void sendResetHttp() async {
    var response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$APIKEY',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email':email,
        'requestType':'PASSWORD_RESET',
      }),
    );
    // print(response.body);
    if (response.statusCode==200) {
      querySelector('#feedbackLogin').text = 'Verification link sent. Check mail.';
    } else {
      // print('Request failed with status: ${response.body}.');
      var error = response.body.toString();
      // print('Request failed with status: $error.');
      var errorDetails = json.decode(error);
      // var errorBody = ErrorBody.fromJson(jsonDecode(error));
      print('${errorDetails['error']}');
      var message = (errorDetails['error']);

      // print('error ${message['message']}');
      querySelector('#feedbackLogin').text = message['message'];
    }
  }

}