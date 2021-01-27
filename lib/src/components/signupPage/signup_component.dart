import 'dart:convert';
import 'dart:html';

import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:http/http.dart' as http;
import 'package:FwrWeb/src/components/consolePage/consolePageService.dart';
import 'package:intl/intl.dart';

const String APIKEY = 'AIzaSyBxWRMri4x1GmSmAIEQwCEuALz8MXDPVdo';
const List<String> _powers = [
  'Really Smart',
  'Super Flexible',
  'Super Hot',
  'Weather Changer'
];

@Component(
  selector: 'signup-form',
  templateUrl: './signup_component.html',
  styleUrls: ['./signup_component.css'],
  directives: [routerDirectives,coreDirectives, formDirectives,],
  exports: [RoutePaths, Routes],
)
class signupComponent {
  static RegDetails regDetails = RegDetails('','','');
  static ErrorMessage errorMessage = ErrorMessage('');
  static outGoingJson outgo1ngJson = outGoingJson('');
  bool submitted = false;

  List<String> get powers => _powers;

  final Router _router;

  signupComponent(this._router);

  void onSubmit() async {
    submitted = true;
    if (regDetails.username!='' &&regDetails.email!=''&&regDetails.password!='') {
      // print('submitting ${regDetails.toString()}');
      await _sendHTTP(regDetails.username, regDetails.email, regDetails.password);
    }
  }
  Future<NavigationResult> _gotoConsole(String url) =>
      _router.navigate(url);
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
      // print(e);
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
  Future<void> _sendHTTP(String username, String email, String password) async {
    querySelector('#spinnerSignIn').style.visibility = "visible";
    // Await the http get response, then decode the json-formatted response.
//    var response = await http.get(url);
    try {
      var response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$APIKEY',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      ).then((value) async {
        // querySelector('#buttonSignUP').style.visibility = "hidden";

        var now = new DateTime.now().toUtc();
        var oneDayFromNow = now.add(new Duration(days: 0));
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        // ignore: omit_local_variable_types
        final String formattedDate = formatter.format(oneDayFromNow);
        // print('response code ${value.statusCode}');
        // print('response body ${value.body}');
        Map<String, dynamic> usrDetails = json.decode(value.body);
        if (value.statusCode == 200) {
          print('email ver');
          var ipMeta = await getIpMeta();
          var publicIP = await getPublicIP();
          print('ip meta$ipMeta');
          var jsonBody = {};
          jsonBody['idToken'] = usrDetails['idToken'];
          jsonBody['username'] = regDetails.username;
          jsonBody['password'] = regDetails.password;
          jsonBody['api key'] = usrDetails['localId'];
          jsonBody['apikeyStatus'] = 'not active';
          jsonBody['apikeyExpiry'] = '$formattedDate';
          jsonBody['userEmail'] = regDetails.email;
          jsonBody['isVerified'] = false;
          //--json body 2

          var jsonBody2 = {};
          jsonBody2['dateTime'] = '${now.toIso8601String()}';
          jsonBody2['TimeZoneName'] = now.timeZoneName.toString();
          jsonBody2['TimeZoneOffset'] = now.timeZoneOffset.toString();
          print('IN STAGE THREE');

          var urlJson = {};
          urlJson['0'] = 'https://jwrapi-default-rtdb.firebaseio.com/';
          urlJson['1'] = 'https://jwrapi-88078-default-rtdb.firebaseio.com/';
          var UrlJString = json.encode(urlJson);
          var vDbPathChildren = {};
          vDbPathChildren['0'] = 'users';
          vDbPathChildren['1'] = '${usrDetails['localId']}';
          var vDbPathChildrenFinal = {};
          vDbPathChildrenFinal['0'] = json.encode(vDbPathChildren);
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
          vDbPathChildren3['2'] = 'dateCreationDetails';
          var vDbPathChildrenFinal3 = {};
          vDbPathChildrenFinal3['0'] = json.encode(vDbPathChildren3);
          print('IN STAGE 4');

          var lastInstances = {};
          lastInstances['secondaryUrls'] = UrlJString;
          lastInstances['dbPathChildren'] = json.encode(vDbPathChildrenFinal);
          lastInstances['jsonBody'] = jsonBody;
          //--2nd last instances
          var lastInstances2 = {};
          lastInstances2['secondaryUrls'] = UrlJString;
          lastInstances2['dbPathChildren'] = json.encode(vDbPathChildrenFinal2);
          var ipJbody = json.decode(ipMeta);
          lastInstances2['jsonBody'] = ipJbody;
          //--3rd last instances
          var lastInstances3 = {};
          lastInstances3['secondaryUrls'] = UrlJString;
          lastInstances3['dbPathChildren'] = json.encode(vDbPathChildrenFinal3);
          lastInstances3['jsonBody'] = jsonBody2;
          print('IN STAGE 5');
          var oInstances = {};
          oInstances['0'] = lastInstances;
          oInstances['1'] = lastInstances2;
          oInstances['2'] = lastInstances3;
          print('IN STAGE 6');

          var outgoingJson = {};


          var ep = '135493';
          outgoingJson['instances'] = jsonEncode(oInstances);
          outgoingJson['isDatabaseDestined'] = true;
          outgoingJson['httpMethod'] = 'SET';
          outgoingJson['isPortal'] = true;
          var jApiKey = {};
          jApiKey['0'] ='https://jwrapi-88078-default-rtdb.firebaseio.com/';
          jApiKey['1'] ='https://jwrapi-default-rtdb.firebaseio.com/';
          jApiKey['apiKeyStr'] = '${usrDetails['localId']}';
          jApiKey['alreadyVerified'] = true;
          outgoingJson['apiKey'] = json.encode(jApiKey);
          outgoingJson['Hx0zLikKKCgsKiMoIw'] = ep;

          print('outgoing ${jsonEncode(outgoingJson)}');
          outgo1ngJson.jsonOutgoing = jsonEncode(outgoingJson);
          var customHeaders = {
            'Content-Type': 'application/json; charset=UTF-8',
          };
          try {
            var responseReg = await http.post(
              'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
              headers: customHeaders,
              body: outgo1ngJson.jsonOutgoing,
            );
            print('final response code: ${responseReg.statusCode}');
            if (responseReg.statusCode == 200) {


              var responseVer = await http.post(
                'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$APIKEY',
                headers: <String, String>{
                  'Content-Type': 'application/json; charset=utf-8',
                },
                body: jsonEncode(<String, dynamic>{
                  'requestType': 'VERIFY_EMAIL',
                  'idToken': usrDetails['idToken'],
                }),
              ).then((valueMail) async {
                if (valueMail.statusCode == 200) {
                  consolePageService.finalApiKey = usrDetails['localId'];
                  consolePageService.finalidToken = usrDetails['idToken'];
                  await _gotoConsole(RoutePaths.console.toUrl());
                }
              });
            }
          } catch (e) {
            // print('final send exception\n$e');
          }

        }
        else {
          var error = value.body.toString();
          // print('Request failed with status: $error.');
          var errorDetails = json.decode(error);
          // var errorBody = ErrorBody.fromJson(jsonDecode(error));
          print('${errorDetails['error']}');
          var message = (errorDetails['error']);

          querySelector('#feedbackSignIn').text = message['message'];
          // print(message['message']);
        }
      });
    } catch(e) {
      querySelector('#feedbackSignIn').text = 'Something went wrong with your submission. Try later';
    }


  }
}
class RegDetails {
  int id;
  String username, email, password;
  RegDetails(this.username, this.email, [this.password]);
  String toString() => '$username $email $password';
}
class ErrorMessage {
  String message;
  ErrorMessage(this.message);
  factory ErrorMessage.fromJson(dynamic json) {
    return ErrorMessage(json['message'] as String);
  }
}
class ErrorBody {
  String error;
  ErrorMessage _errorMessage;
  ErrorBody(this.error,this._errorMessage);
  factory ErrorBody.fromJson(dynamic json) {
    return ErrorBody(json['error'] as String, ErrorMessage.fromJson(json['message']));
  }
}
class outGoingJson {
  String jsonOutgoing;
  outGoingJson(this.jsonOutgoing);
}