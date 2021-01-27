import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:FwrWeb/src/routes/route.dart';
import 'package:FwrWeb/src/routes/route_path.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import 'package:FwrWeb/src/components/consolePage/consolePageService.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';


@Component(
  selector: 'console_page',
  templateUrl: './console_page_components.html',
  styleUrls: ['./console_page_components.css'],
  directives: [routerDirectives,coreDirectives, formDirectives],
  exports: [RoutePaths, Routes],
  providers: [ClassProvider(consolePageService)],
)
class Console implements OnInit {
  consolePageService pageService;
  Console(this.pageService);
  String trackingNumber;
  String senderCountry;
  String accountApi = 'AIzaSyBxWRMri4x1GmSmAIEQwCEuALz8MXDPVdo';
  bool showk = false;
  String userName = '';
  String apiKey = '';
  String apiKeyExpiry = '';
  String encryptions = '';
  String decryptions = '';
  String total = '';
  String cost = '';
  String isVerified = '';

  String activeStatus = '';
  String callToAction = '';

  String verificationStatus = '';

  String idToken = '';
  String payMeVerificationSent = '';
  void ngOnInit() => _getData();
  void _getData() async {
    // print('tentative api key: ${consolePageService.finalApiKey}');
    await pageService.sendGetHttpRequest();
    idToken = pageService.consolePageObject.idToken;
    userName = pageService.consolePageObject.userName;
    // print('Console username ${userName}');
    apiKey = pageService.consolePageObject.apiKey;
    apiKeyExpiry = pageService.consolePageObject.expiryDate;
    encryptions = pageService.consolePageObject.encryptions;
    decryptions = pageService.consolePageObject.decryptions;
    total = pageService.consolePageObject.total;
    cost = pageService.consolePageObject.cost;
    isVerified = pageService.consolePageObject.isVerified;
    payMeVerificationSent = pageService.consolePageObject.payMeVerificationSent;

    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    // print(apiKeyExpiry);
    final expiry = formatter.parse(apiKeyExpiry);
    final today = DateTime.now();
    final difference = expiry.difference(today).inDays;
    // final birthday = DateTime(2021, 01, 12);
    // final difference2 = birthday.difference(expiry).inDays;
    // print("date difference $difference $difference2");
    if (isVerified=='true') {
      querySelector('#resend').style.visibility = "hidden";
      verificationStatus ='Verified';
      var vTotal = int.parse(total);
      if (difference>=0 && vTotal<5000) {
        activeStatus = 'Account active. it will be deactivated on$apiKeyExpiry';
        if (difference<=0) {
          activeStatus = 'Account active. it will be deactivated today. Pay 25 dollars using western union to the account with these details. \nBank name: Kenya commercial bank ltd.\nAccount no: 1259261670';
          callToAction = 'verify payment';
        }
        else if (difference>0) {
          callToAction = '';
        }
      }
      else if (difference>=0 && vTotal>=5000) {
        activeStatus = 'Account active. it will be deactivated on $apiKeyExpiry. You have reached your monthly quota limit of 5k request. your coming bill will be inclusive of quota fees';
        if (difference<=1) {
          var feesCharge = int.parse(total);
          int totalf = 25+feesCharge;
          activeStatus = 'Account active. it will be deactivated on $apiKeyExpiry.. your coming bill will be inclusive of quota fees. Pay $totalf dollars using western union to the account with these details. \nBank name: Kenya commercial bank ltd.\nAccount no: 1259261670';
          callToAction = 'verify payment';
        }
      }
      else if (difference<=0 && vTotal>=5000) {
        activeStatus = 'Account deactivated. Api key expired. You have reached your monthly quota limit of 5k request. your coming bill will be inclusive of quota fees.   \nPay 25 dollars using western union to the account with these details. \nBank name: Kenya commercial bank ltd.\nAccount no: 1259261670';
        callToAction = 'verify payment';
      }
      else if (difference<0&& vTotal<5000) {
        print('terminating contract');
        activeStatus = 'Account deactivated. Api key expired. \nPay 25 dollars using western union to the account with these details. \nBank name: Kenya commercial bank ltd.\nAccount no: 1259261670';
        callToAction = 'verify payment';
      }
      //the birthday's date

    } else {
      verificationStatus = 'not verified';
      activeStatus = 'Account deactivated. Verify email and ';
      callToAction = 'click here to activate';
    }
    if (payMeVerificationSent == 'true') {
      activeStatus = 'Verification sent awaiting approval. It may take few hours. Thank you.';
      callToAction = '';
    }
    // print('CONSOLE STEP ONE');
    // email = _resetService.email;
    // print('email: $email');
  }
  Future<void> callToActionClick() async {
    print('call to action');
    if (callToAction == 'click here to activate') {
      var response = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:lookup?key=$accountApi',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'idToken':consolePageService.finalidToken,
        }),
      );
      if (response.statusCode==200) {
        print('verification status\n${response.body}');
        var verDetails = json.decode(response.body);
        var trueVerDetails = verDetails['users'];
        // print('tentative \n${trueVerDetails}');
        var finalVer = trueVerDetails[0];
        bool bIsVerified = finalVer['emailVerified'];;
        if (bIsVerified) {
          // print('Email Verified');
          //send true and active
          var jsonBody = {};
          jsonBody['apikeyStatus'] = 'active';
          jsonBody['isVerified'] = true;
          var vDbPathChildren = {};
          vDbPathChildren['0'] = 'users';
          vDbPathChildren['1'] = '$apiKey';
          var vDbPathChildrenFinal = {};
          vDbPathChildrenFinal['0'] = json.encode(vDbPathChildren);
          var lastInstances = {};
          var urlJson = {};
          urlJson['0'] = 'https://jwrapi-default-rtdb.firebaseio.com/';
          urlJson['1'] = 'https://jwrapi-88078-default-rtdb.firebaseio.com/';
          var UrlJString = json.encode(urlJson);
          lastInstances['secondaryUrls'] = UrlJString;
          lastInstances['dbPathChildren'] = json.encode(vDbPathChildrenFinal);
          lastInstances['jsonBody'] = jsonBody;
          var oInstances = {};
          oInstances['0'] = lastInstances;
          var outgoingJson = {};
          var ep = '135493';
          outgoingJson['instances'] = jsonEncode(oInstances);
          outgoingJson['isDatabaseDestined'] = true;
          outgoingJson['isPortal'] = true;
          outgoingJson['httpMethod'] = 'SET';
          outgoingJson['Hx0zLikKKCgsKiMoIw'] = ep;
          // print('outgoing ${json.encode(outgoingJson)}');
          var customHeaders = {
            'Content-Type': 'application/json; charset=UTF-8',
          };
          var responseUpdate = await http.post(
            'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
            headers: customHeaders,
            body: json.encode(outgoingJson)
          );
          // print('update response code: ${responseUpdate.statusCode}');
          if (responseUpdate.statusCode==200) {
            activeStatus = 'Account active. it will be deactivated on $apiKeyExpiry.';
            verificationStatus = 'verified';
            querySelector('#resend').style.visibility = "hidden";
          }
        } else {
          print('not verified');
        }
      }
    }
    else if (callToAction == 'verify payment') {
      querySelector('#verifyForm').style.visibility = "visible";
    }
  }
  Future<void> onSubmit() async {
    if (trackingNumber != '' && senderCountry!='') {
      querySelector('#spinner').style.visibility = "visible";
      var jsonBody = {};
      jsonBody['trackingNumber'] = '$trackingNumber';
      jsonBody['senderCountry'] = '$senderCountry';
      jsonBody['api key'] = '$apiKey';
      jsonBody['amount'] = '$total';

      var jsonBody2 = {};
      jsonBody2['payMeVerificationSent'] = true;


      var urlJson = {};
      urlJson['0'] = 'https://jwrapi-default-rtdb.firebaseio.com/';
      urlJson['1'] = 'https://jwrapi-88078-default-rtdb.firebaseio.com/';
      var UrlJString = json.encode(urlJson);

      var vDbPathChildren = {};
      vDbPathChildren['0'] = 'orders';
      vDbPathChildren['1'] = '$apiKey';
      var vDbPathChildrenFinal = {};
      vDbPathChildrenFinal['0'] = json.encode(vDbPathChildren);

      var vDbPathChildren2 = {};
      vDbPathChildren2['0'] = 'users';
      vDbPathChildren2['1'] = '$apiKey';
      var vDbPathChildrenFinal2 = {};
      vDbPathChildrenFinal2['0'] = json.encode(vDbPathChildren2);

      var lastInstances = {};
      lastInstances['secondaryUrls'] = UrlJString;
      lastInstances['dbPathChildren'] = json.encode(vDbPathChildrenFinal);
      lastInstances['jsonBody'] = jsonBody;

      var lastInstances2 = {};
      lastInstances2['secondaryUrls'] = UrlJString;
      lastInstances2['dbPathChildren'] = json.encode(vDbPathChildrenFinal2);
      lastInstances2['jsonBody'] = jsonBody2;

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
      jApiKey['apiKeyStr'] = '$apiKey';
      jApiKey['alreadyVerified'] = true;
      outgoingJson['apiKey'] = json.encode(jApiKey);
      // print('outgoing ${jsonEncode(outgoingJson)}');
      var customHeaders = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
      var responseReg = await http.post(
        'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
        headers: customHeaders,
        body: json.encode(outgoingJson),
      );
      print('final response code: ${responseReg.statusCode}');
      if (responseReg.statusCode == 200) {
        activeStatus =
        'Verification sent awaiting approval. It may take few hours. Thank you.';
        querySelector('#verifyForm').style.visibility = "hidden";
        callToAction = '';
      }
    }
  }
  Future<void> callToActionAgain() async {
    print("id token $idToken");
    try {
      var responseVer = await http.post(
        'https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$accountApi',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode(<String, dynamic>{
          'requestType': 'VERIFY_EMAIL',
          'idToken': idToken,
        }),
      );
      // print('response ${responseVer.statusCode}');
      if (responseVer.statusCode==200) {
        activeStatus = 'Email verification link sent. Check mail';
      }
    } catch(e) {
      print('error $e');
    }
  }
  void copyString() {
    final textarea = new TextAreaElement();
    document.body.append(textarea);
    textarea.style.border = '0';
    textarea.style.margin = '0';
    textarea.style.padding = '0';
    textarea.style.opacity = '0';
    textarea.style.position = 'absolute';
    textarea.readOnly = true;
    textarea.value = '$apiKey';
    textarea.select();
    final result = document.execCommand('copy');
    textarea.remove();
    // print('String copied');
  }
  void onRefresh() async {
    querySelector('#spinnerLoading').style.visibility = "visible";
    querySelector('#refreshbutton').style.visibility = "hidden";
    await pageService.sendGetHttpRequest();
    querySelector('#spinnerLoading').style.visibility = "hidden";
    querySelector('#refreshbutton').style.visibility = "visible";
    encryptions = pageService.consolePageObject.encryptions;
    decryptions = pageService.consolePageObject.decryptions;
    total = pageService.consolePageObject.total;
    cost = pageService.consolePageObject.cost;
  }
}
