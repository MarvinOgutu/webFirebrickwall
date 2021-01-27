import 'dart:convert';
import 'package:http/http.dart' as http;

class consolePageService {
  final ConsolePageObject consolePageObject = ConsolePageObject('','','','','','','','','');
  static String finalApiKey;
  static String finalidToken;

  void sendGetHttpRequest() async {
    consolePageObject.apiKey = finalApiKey;
    consolePageObject.idToken = finalidToken;
    //url
    var urlJson = {};
    urlJson['0'] = 'https://jwrapi-default-rtdb.firebaseio.com/';
    urlJson['1'] = 'https://jwrapi-88078-default-rtdb.firebaseio.com/';
    var UrlJString = json.encode(urlJson);

    //--2nd vdb path children
    var vDbPathChildren2 = {};
    vDbPathChildren2['0'] = 'users';
    vDbPathChildren2['1'] = '$finalApiKey';
    var vDbPathChildrenFinal2 = {};
    vDbPathChildrenFinal2['0'] = json.encode(vDbPathChildren2);
    //--3rd vdb path children
    var vDbPathChildren3 = {};
    vDbPathChildren3['0'] = 'users';
    vDbPathChildren3['1'] = '$finalApiKey';
    vDbPathChildren3['2'] = 'encryptions';
    var vDbPathChildrenFinal3 = {};
    vDbPathChildrenFinal3['0'] = json.encode(vDbPathChildren3);
    //--3rd vdb path children
    var vDbPathChildren4 = {};
    vDbPathChildren4['0'] = 'users';
    vDbPathChildren4['1'] = '$finalApiKey';
    vDbPathChildren4['2'] = 'decryptions';
    var vDbPathChildrenFinal4 = {};
    vDbPathChildrenFinal4['0'] = json.encode(vDbPathChildren4);
    var lastInstances = {};
    lastInstances['secondaryUrls'] = UrlJString;
    lastInstances['dbPathChildren'] = json.encode(vDbPathChildrenFinal2);
    var lastInstances2 = {};
    lastInstances2['secondaryUrls'] = UrlJString;
    lastInstances2['dbPathChildren'] = json.encode(vDbPathChildrenFinal3);
    var lastInstances3 = {};
    lastInstances3['secondaryUrls'] = UrlJString;
    lastInstances3['dbPathChildren'] = json.encode(vDbPathChildrenFinal4);
    var oInstances = {};
    oInstances['0'] = lastInstances;
    var oInstances2 = {};
    oInstances2['0'] = lastInstances2;
    var oInstances3 = {};
    oInstances3['0'] = lastInstances3;
    var outgoingJson = {};
    var ep = '135493';
    outgoingJson['instances'] = jsonEncode(oInstances);
    outgoingJson['isDatabaseDestined'] = true;
    outgoingJson['isPortal'] = true;
    outgoingJson['httpMethod'] = 'GET';
    outgoingJson['Hx0zLikKKCgsKiMoIw'] = ep;
    var jApiKey = {};
    jApiKey['0'] ='https://jwrapi-88078-default-rtdb.firebaseio.com/';
    jApiKey['1'] ='https://jwrapi-default-rtdb.firebaseio.com/';
    jApiKey['apiKeyStr'] = '$finalApiKey';
    jApiKey['alreadyVerified'] = true;
    outgoingJson['apiKey'] = json.encode(jApiKey);

    var outgoingJson2 = {};
    // var ep = '135493';
    outgoingJson2['instances'] = jsonEncode(oInstances2);
    outgoingJson2['isDatabaseDestined'] = true;
    outgoingJson2['isPortal'] = true;
    outgoingJson2['httpMethod'] = 'GET';
    outgoingJson2['Hx0zLikKKCgsKiMoIw'] = ep;
    outgoingJson2['apiKey'] = json.encode(jApiKey);

    var outgoingJson3 = {};
    // var ep = '135493';
    outgoingJson3['instances'] = jsonEncode(oInstances3);
    outgoingJson3['isDatabaseDestined'] = true;
    outgoingJson3['isPortal'] = true;
    outgoingJson3['httpMethod'] = 'GET';
    outgoingJson3['Hx0zLikKKCgsKiMoIw'] = ep;

    outgoingJson3['apiKey'] = json.encode(jApiKey);
    var customHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    try {
      var responseConsole = await http.post(
        'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
        headers: customHeaders,
        body: jsonEncode(outgoingJson),
      );
      if (responseConsole.statusCode == 200) {
        // print('body\n${responseConsole.body}');
        var body = responseConsole.body.toString();
        var consoleDetails = json.decode(body);
        var overview = json.decode(consoleDetails['getResponseString']);
        // print('name ${overview['username']}');

        consolePageObject.userName = overview['username'];
        consolePageObject.expiryDate = overview['apikeyExpiry'];
        consolePageObject.isVerified = overview['isVerified'];

        // print('final name ${consolePageObject.userName}');
        try {
          consolePageObject.payMeVerificationSent = overview['payMeVerificationSent'];
        } catch(r) {
          consolePageObject.payMeVerificationSent = 'false';
        }
        var responseConsole2 = await http.post(
          'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
          headers: customHeaders,
          body: jsonEncode(outgoingJson2),
        );
        if (responseConsole2.statusCode==200) {
          try {
            var consoleDetails2 = json.decode(responseConsole2.body);
            // print('consoleDetails2 $consoleDetails2');
            var overview2 = json.decode(consoleDetails2['getResponseString']);
            // print('overview2.length ${overview2.length}');
            consolePageObject.encryptions = '${overview2.length}';
            // if (consolePageObject.encryptions==null) {
            //   consolePageObject.encryptions = '0';
            // }
          } catch(t) {
            consolePageObject.encryptions = '0';
          }
        }
        var responseConsole3 = await http.post(
          'https://europe-west2-encryptionio.cloudfunctions.net/function-2',
          headers: customHeaders,
          body: jsonEncode(outgoingJson3),
        );
        if (responseConsole3.statusCode==200) {
          try {
            var consoleDetails3 = json.decode(responseConsole3.body);
            // print('consoleDetails3 $consoleDetails3');
            var overview3 = json.decode(consoleDetails3['getResponseString']);
            // print('overview3 ${overview3}');
            consolePageObject.decryptions = '${overview3.length}';

            // if (consolePageObject.decryptions==null) {
            //   consolePageObject.decryptions = '0';
            // }
          } catch(t) {
            consolePageObject.decryptions = '0';
            // print('catching stage');
          }
        }

        // print('Parse stage');
        int en =0;
        try {
          en = int.parse('${consolePageObject.encryptions}');
        } catch(d) {
          en = 0;
        }
        int de = 0;
        try {
          de = int.parse('${consolePageObject.decryptions}');
        } catch(d) {
          de = 0;
        }
        int tot = en + de;
        consolePageObject.total = '$tot';
        double quotient = tot / 40000;
        double cost = quotient * 2.5;
        String finalCost = cost.toStringAsFixed(2);
        consolePageObject.cost = '${finalCost}';

      }
    } catch(e) {
      // print('error $e');
    }




  }
}
class ConsolePageObject {
  String idToken;
  String userName;
  String apiKey;
  String expiryDate;
  String encryptions;
  String decryptions;
  String total;
  String cost;
  String isVerified;
  String payMeVerificationSent;
  ConsolePageObject(this.userName,this.apiKey,this.expiryDate,this.encryptions,this.decryptions,this.total,this.cost,this.isVerified, this.payMeVerificationSent);
}