
import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:ticket_resell/models/notification.dart';

class PushNotificationService{

  static Future<String> getAccessToken() async{

    final serviceAcountJson = {
      "type": "service_account",
      "project_id": "ticket-resell-app-33551",
      "private_key_id": "ecf1322413b99796fc99c7ee448fd8472a9d290d",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDL0+e3lsswxICl\nYe+i6Qj+D3pjxkAyyGFD537zi1xr78TvjkRwZEEMsDqds3AXEruFM0XL/K67yc3I\nBf6PfgmoMUhkei5PozLvXPiIgufra3M/HGO/BfzestZ1Ig6sVrpxyfgqC+0KLW+w\nvlhaMqoCAWIdmJ2Jcp1+D7rMBabXyOAxisn2kmHsLmXgUswHr3P9XI54S0AISSDs\nFPYUWPzmkg0W97CZ98MfpXfR2dWaOhOh9rD+NssMynyVzl++udRhMhQ4R8SiI3ST\nEMjy2FbhGEaP16c1nEii6IRlIlMKe740NxRT3h5rtYdA1Hq/hDT2ZS78luyz43mH\n+gnkCmy1AgMBAAECggEAKKrIF+tccYe3QigC465alrQYX3lR3D/6Fg4FWIq03y04\nzfIE6ia6itFLdKT1R4k7hEU5Vwx8gWevaMn3YwJK43Wnw7JT9JwzYKocRUJXCvPG\ni/A6X4XOkNE+NCMeKdjo/KSHIL595hKwLuOfZamnnVxQyuZlAiQt05XIV4YGJpWo\nUuECsCCUxWz8Laz+kHJKpeudxHiTjuPTvDcDbB8CUYjbBwQNVYQvFlhLsI0/JqJR\nizRSxZhyBq/9eQ6wF68hn036aLqcJMae4oRR5vWT8fE09AUBra3BWdpDkk15G368\nvtDm4wyoglUg9Br+yCRc6NZlSdw/0BbYuwofPorkAQKBgQD5WANCnbmwIXO3xJrn\nBtZUqdWKvrsNDaPmhdpEzKhKtG2HN02UDYUMXX8WCxlpYonwM/B1Xh36g+3u2xum\nW5n4n79C1+r7Nf2D3r+F5E3XNm8j837zv5aEnk9teCFKhm/tVNK6cVvtQjM75a6f\nzOaNIxNzzdDl2lLqfe599knMAQKBgQDRRNdGPytTjo9whtZUP3oQNm8SVBjnThSN\nZ8GjPCPxyjzT/ksHJLUmjKyej1n2BC2mo0FYTd54Fl4kx36H09J27xaZqZquVBOV\nH+BOk/jPJ2K9JGL3RsCPnB3WGJlWxUYowhwgwakJ+zzu0eLMEgp8Kr/o+yAc0d4I\nh32Wz50wtQKBgQCEowro7toOFV1nDhCQgJSW6NkNOzRpVy4uvFlFa9DCHIR+/y4n\naaGy2DF4WmMkKiTSP+7ToEM2NePlwWxN7EBVfzTQq+b1xtyav20GHlJB/1TTvP11\nUB8TYNtDkjmzWRxFFXAbeZ268hIq9J0VqHuj7Fq2qW9MNf0Re/fXzaGoAQKBgARn\nQWxd+ehpMIV6oNnm+AeNTasCEAAV+YK8MyvfIRZ+XedMC4Ib+J/WB+/SLl9p2RgP\niVl1UgAO4G4/sF7lSyFriHs1QWb3p+3UXODqZirdtksqj9aKK5UaANq3a8qSnhZP\nd04NJSRrn+2ahv4qRwQz1hPt7NAObnCZgUACIFmdAoGBAOZRDmIGOtxmoRI4XHFA\n21vzJfszH0+LaokLi/hfR4+IHSyyltcPzKIHSUjHTH4ElT41wi55zWaQahgLP+O/\nQ8anxL61uMFIKBQ9ZfGHtsJYiLRwypbNDmdQYOM1wuQnPmAesOWOdPNigJ2EMwGT\nGxNmqREEX7IpAy7212ZF0c74\n-----END PRIVATE KEY-----\n",
      "client_email": "ticket-resell-app@ticket-resell-app-33551.iam.gserviceaccount.com",
      "client_id": "113276533145984193429",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/ticket-resell-app%40ticket-resell-app-33551.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes =
        [
          //"https://www.googleapis.com/auth/userinfo.email",
          //"https://www.googleapis.com/auth/firebase.database",
          "https://www.googleapis.com/auth/firebase.messaging"
        ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
      scopes,
    );

    //get the access token
    auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAcountJson),
      scopes,
        client
    );

    client.close();

    return credentials.accessToken.data;

  }
  static sendNotificationToSelectedDrived(String? deviceToken, BuildContext context, String title, String body) async{

    final String serverAccessTokenKey = await getAccessToken();
    if (serverAccessTokenKey == null) {
      print('Failed to get access token.');
      return;
    }else{
      print('0000000000000000000000000000000000000000000000000000000000000000000$serverAccessTokenKey');
      print('99999999999999999999999999999999999999999999999999999999$deviceToken');
    }
    String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/ticket-resell-app-33551/messages:send';

    final Map<String, dynamic> message =
    // {
    //   'message' :
    //       {
    //         'token' : deviceToken,
    //         'notification' :
    //         {
    //           'title' : "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh",
    //           'body' : 'tgshhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh'
    //         }
    //       }
    // };
    {
      "message":{
        "token": deviceToken,
        "notification":{
          "body":body,
          "title":title
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String,String>
      {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );

    if(response.statusCode == 200){
      print(response.body);
      print("Notification send Successfully");
    } else
    {
      print("Failed Notification not send111111111111111111111111111111111111111111111: ${response.statusCode}");
      print("Response body: ${response.body}");
    }

  }


  static sendNotificationToSelectedDrivedForRequest(String? deviceToken, BuildContext context, NotificationModel notificationModel) async{

    final String serverAccessTokenKey = await getAccessToken();
    if (serverAccessTokenKey == null) {
      print('Failed to get access token.');
      return;
    }else{
      print('0000000000000000000000000000000000000000000000000000000000000000000$serverAccessTokenKey');
      print('99999999999999999999999999999999999999999999999999999999$deviceToken');
    }
    String endpointFirebaseCloudMessaging = 'https://fcm.googleapis.com/v1/projects/ticket-resell-app-33551/messages:send';

    final Map<String, dynamic> message =
    {
      "message":{
        "token": deviceToken,
        "notification":{
          "body":notificationModel.body,
          "title":notificationModel.title
        },
        "data": {
          "ticketRequestId": "${notificationModel.ticketRequestId}",
          "receiverId": notificationModel.receiverId,
          "notificationId": notificationModel.id,
          "status": notificationModel.status,
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: <String,String>
      {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverAccessTokenKey'
      },
      body: jsonEncode(message),
    );
    print("===================0000000000000000000000000000");
    print(message);

    if(response.statusCode == 200){
      print(response.body);
      print("Notification send Successfully");
    } else
    {
      print("Failed Notification not send111111111111111111111111111111111111111111111: ${response.statusCode}");
    }

  }

}