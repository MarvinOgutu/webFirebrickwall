import 'dart:convert';
import 'dart:html';

import 'package:FwrWeb/src/components/consolePage/consolePageService.dart';
import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:http/http.dart' as http;

const String APIKEY = 'AIzaSyBxWRMri4x1GmSmAIEQwCEuALz8MXDPVdo';
const List<String> _powers = [
  'Really Smart',
  'Super Flexible',
  'Super Hot',
  'Weather Changer'
];

@Component(
  selector: 'hero-form',
  templateUrl: './loggin_component.html',
  styleUrls: ['./loggin_component.css'],
  directives: [routerDirectives,coreDirectives, formDirectives],
  exports: [RoutePaths, Routes],
)
class loginFormComponent {
  static LogDetails logDetails = LogDetails('','');
  bool submitted = false;
  final Router _router;

  loginFormComponent(this._router);

  List<String> get powers => _powers;

  void onSubmit() async {
    submitted = true;
    if (logDetails.email!=''&&logDetails.password!='') {
      // print('submitting ${logDetails.toString()}');
      await _sendHTTP(logDetails.email, logDetails.password);
    }
  }
  void onForgotPwd() async {
    if (logDetails.email!='') {
      await _gotoConsole(RoutePaths.pwdreset.toUrl());
    } else {
      querySelector('#feedbackLogin').text = 'Email field required';
    }

  }
  Future<String> getPublicIP() async {
    try {
      const url = 'https://api.ipify.org';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        return response.body;
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
        // print(response.statusCode);
        // print(response.body);
        return null;
      }
    } catch (e) {
      // Request failed due to an error, most likely because
      // the phone isn't connected to the internet.
      print(e);
      return null;
    }
  }
  Future<String> getIpMeta() async {
    try {
      var ip = await getPublicIP();
      var url = 'http://ip-api.com/json/$ip';
      var response = await http.get(url);
      if (response.statusCode == 200) {
        // The response body is the IP in plain text, so just
        // return it as-is.
        return response.body;
      } else {
        // The request failed with a non-200 code
        // The ipify.org API has a lot of guaranteed uptime
        // promises, so this shouldn't ever actually happen.
        // print(response.statusCode);
        // print(response.body);
        return null;
      }
    } catch(e) {}
  }

  Future<NavigationResult> _gotoConsole(String url) =>
      _router.navigate(url);
  Future<void> _sendHTTP(String email, String password) async {
    querySelector('#spinner').style.visibility = "visible";
    // Await the http get response, then decode the json-formatted response.
//    var response = await http.get(url);
    var response = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$APIKEY',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email':email,
        'password':password,
        'returnSecureToken':true,
      }),
    );
    if (response.statusCode == 200) {

      // print('response.body ${response.body}');
      Map<String, dynamic> usrDetails = json.decode(response.body);

      // print('usr id ${usrDetails['localId']}');
      var ipMeta = await getIpMeta();
      var publicIP = await getPublicIP();
      var now = new DateTime.now().toUtc();
      //url
      var urlJson = {};
      urlJson['0'] = 'https://jwrapi-default-rtdb.firebaseio.com/';
      urlJson['1'] = 'https://jwrapi-88078-default-rtdb.firebaseio.com/';
      var UrlJString = json.encode(urlJson);

      var jsonBody2 = {};
      jsonBody2['dateTime'] = '${now.toIso8601String()}';
      jsonBody2['TimeZoneName'] = now.timeZoneName.toString();
      jsonBody2['TimeZoneOffset'] = now.timeZoneOffset.toString();

      //--2nd vdb path children
      var vDbPathChildren2 = {};
      vDbPathChildren2['0'] = 'users';
      vDbPathChildren2['1'] = '${usrDetails['localId']}';
      vDbPathChildren2['2'] = 'ipAddresses';
      vDbPathChildren2['3'] = '$publicIP';
      var vDbPathChildrenFinal2 = {};
      vDbPathChildrenFinal2['0'] = json.encode(vDbPathChildren2);
      //--3rd vdb path children
      var vDbPathChildren3 = {};
      vDbPathChildren3['0'] = 'users';
      vDbPathChildren3['1'] = '${usrDetails['localId']}';
      vDbPathChildren3['2'] = 'loginDetails';
      vDbPathChildren3['3'] = '${now.toIso8601String()}';
      var vDbPathChildrenFinal3 = {};
      vDbPathChildrenFinal3['0'] = json.encode(vDbPathChildren3);

      var lastInstances = {};
      lastInstances['secondaryUrls'] = UrlJString;
      lastInstances['dbPathChildren'] = json.encode(vDbPathChildrenFinal3);
      lastInstances['jsonBody'] = jsonBody2;
      //--2nd last instances
      var lastInstances2 = {};
      lastInstances2['secondaryUrls'] = UrlJString;
      lastInstances2['dbPathChildren'] = json.encode(vDbPathChildrenFinal2);
      var ipJbody = json.decode(ipMeta);
      lastInstances2['jsonBody'] = ipJbody;
      var oInstances = {};
      oInstances['0'] = lastInstances;
      oInstances['1'] = lastInstances2;

      var outgoingJson = {};
      var ep = '135493';
      outgoingJson['instances'] = jsonEncode(oInstances);
      outgoingJson['isDatabaseDestined'] = true;
      outgoingJson['isPortal'] = true;
      outgoingJson['httpMethod'] = 'SET';
      outgoingJson['Hx0zLikKKCgsKiMoIw'] = ep;
      var jApiKey = {};
      jApiKey['0'] ='https://jwrapi-88078-default-rtdb.firebaseio.com/';
      jApiKey['1'] ='https://jwrapi-default-rtdb.firebaseio.com/';
      jApiKey['apiKeyStr'] = '${usrDetails['localId']}';
      jApiKey['alreadyVerified'] = true;
      outgoingJson['apiKey'] = json.encode(jApiKey);
      var customHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var responseLog = await http.post(
        'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
        headers: customHeaders,
        body: jsonEncode(outgoingJson),
      );
      if (responseLog.statusCode==200) {
        consolePageService.finalApiKey = usrDetails['localId'];
        consolePageService.finalidToken = usrDetails['idToken'];
        await _gotoConsole(RoutePaths.console.toUrl());
      }

    } else {
      // print('Request failed with status: ${response.body}.');
      var error = response.body.toString();
      // print('Request failed with status: $error.');
      var errorDetails = json.decode(error);
      // var errorBody = ErrorBody.fromJson(jsonDecode(error));
      // print('${errorDetails['error']}');
      var message = (errorDetails['error']);

      // print('error ${message['message']}');
      querySelector('#feedbackLogin').text = message['message'];

    }

  }
}

class LogDetails {
  String email, password;
  LogDetails(this.email, this.password);
  String toString() => '$email Super power: $password';
}