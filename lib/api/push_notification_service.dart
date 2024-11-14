
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
      "private_key_id": "cc8ad94f04471e837859b525bda3745f57205e0e",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC5a/YdNsegXwDG\nVu7JGeU/Gqe/1Pbswq2jHaSFwEcAD2OLa6OgIzcKpo9R3sQR+LTSZUAMpGsRRvmv\n4xDYj34Zl3Ghsy3yPJ6fv3bno7TTPmQ6aRSRkstkRLCuX1l8ud42cPwNNvvidhNX\nCLEQc/SpERYf53MnvwtLxAvc1YKLwtiffeDMZqUKqT4HPV3x/67fca9ilRk9Iwk+\nwnhRDffEO60gOvsPPnbXRKHBuHGvq0V0VnNhzNxtJMTGlra9O8c7BIhW8VYC5nT0\nfmROOqhRkZx4OdyjdfSTOZnPsG2BB5J+nupCweo4fZLtYugj9QOFNH38NgWTGNGY\nQoiRTT/nAgMBAAECggEAWfgkJd24ND0Uu6hf2c1KWnm9DowvugbmSMDv3QREjydo\nZjR24xNjODREU3XTTmMOng4J63h2CR6WtbzoJiROC+3bcZnm/+RhFWNKNzBMY7mg\n2WS2WcJQFVltH1bdrXLkeycMbf8Rbjtbu/3YKIMTIlvLj/R2gEEnIn7AQMmKu/Qd\npnMnGBrW3UA3+TiztkvO0JkNUS8aqWXQkpOC0uVTmSvsLivWmbQxbuwgdCjwJqoq\nc/x85s1sgS5U5xcmGuBoOIwgb98QvYUijJ8ymGVPcmrcLEEspzeU4Cq6Wfo7iYgE\n7Aby/BTaMQOW9aJJ8WR3eK1VjsUx9QWla23zlKBRZQKBgQDrZX6WpCI7ix+o4KBZ\n1LuUfbmnALx36IDu+7BDCHT/ZfM0WKhmbVqeWJbzdB9oJCzSfzNFUlvmLk+LJcm6\nts+TWocJEZxTOqyDn6RxOW0e+bbA3aPoqAgWbcHrhkVUhn4J19SGFA+HC+EhPpWH\nb9HEP4BtCLW/bTPvfe0cZoFFvQKBgQDJprAUvpwZBndXsLJ2he8FZRz7X/R6WKib\ninc98lTysl+xybvltUHMGKJ0nYkYS+es6E401yl6xFWuaZgrANPX3mkQtMIZ+5nq\nXJoZiI+ZAOQ+cTUs6F4sNJj0AIA0qXkODxz/L3NrLnbns1MZVs01i9MErWyJWfKI\ngDeSSAdccwKBgDR0bX0MHkS+f9OWGqVp7lLsoU5Br73YpcKbe2+0lr3C7isgBoas\nn6DhhOHDYqxGQ2a0yawM6kWk1Dzhss5UpnTjm2u97OPvEzpRfMduUI6yfrMDsN7L\ncuHsm2Xsic6IGdX/rnAiUEN7tjM+SvvfQxNEQ04IvtdlcklP+mJ1xSDRAoGAd9bc\nJjfxRN4W5sJYDSAjoK0qwCmSfXNbILT1kJcH7QQc4uflBurlo4mwYmWNKCdUE+or\nMDP+rrsnwHN4v3XKcCv5fLgv8okYO7O00R/bVy60dneJBptB/Dt1+uyhRKrDCpvo\nu69ThIsklyZ3aEOxyPTD/6+hJS+Td5Pbcs/jsAkCgYBygbzSKa44DwjP/5is1AYm\nVBX2eV7NhqIIaKZVEpVqRXuxIzKrh/ljfMbcORao1SiH+o7HJz/Z399ebWp5NnWm\n2MYIiWj9h00OB5ZmIdBEOWycAbbNC47mKmQvz1oYTEx/QxZgc3FTSCHrT7MXROnb\n+kClK56+pdxLAEmmiNK4rQ==\n-----END PRIVATE KEY-----\n",
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