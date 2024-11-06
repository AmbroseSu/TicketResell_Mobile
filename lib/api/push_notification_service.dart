
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
      "private_key_id": "3ca27808b1577ad83fde96028862004438c5f1b7",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDIAGQS/YHHrHkW\n60WYqOhntlUHwNuEnOQ6PmhxhpPpsxs/irUAz82Ru0QwPFN7tJyqotXYaRXFfKD8\nVd/Ag89j8M5yc6JbEU4rougNnxjk6j3mSpytB9BrYVuIGXyaYLvfnGUSxgdb8OuV\nf6hRpB5W/3AyEqSEap9CqKJD9sOgTpAV+C9wEV9bzP2pvkyZKPzuBZAcmiZ+7CI6\njHpiobcd+KCz+q+qIO+/RpetZSRGND8gHZGpzhVkVufvqFL1JdEQwvtXdJljWlTo\nNrMWCBwVQUrqlNmoSwAEUiF3ApVuIvjLz29+HZznlcVpOYBYvx0jcog1bOhci2n5\nfIyKPWOrAgMBAAECggEAGYYQlL/Xd8+nUGkhY58YBwxPg611a6dzajTGssjq8tB8\nXLqV6ORG0XSlpMY+HTO/0/hIntVNBaanC4I7YN/cGrQDlLr0cEzKvhTh1RiFs8kV\nBzZkZ6HvU5TZeoqjdTbSeHIGusOc8tB8hYKvd2PLdMIlOQQEt4Vn4mOPpGlx2RuT\n0y4pzaccao9+l6NSMFxc+cbzg+xs7he/sbAxjiD1FfBOaaqhenHCnUvfQMD6jyTA\nofjhSekYLYIm50+NdEnYM05gLYvd9qvfurGdZJBapmi6UmkD46Y84mu0Ua7EWwCO\nY6R8TKqklB6ZmOMgfQxRXWYU5R65uDV28E0reS9dcQKBgQDlkByi7MjvV9LaMT7g\n2s3EyKD3yM2YOLy5CdiLCLBS36exiB0HTSaDQxBBSuEPO2kePN9zm+PKbDT6uPkX\nTpmKHRyRsv5L1LYo1qd9U8UxwE/nPeXFuk9eBofQkDgXr/eJlvJ6pi7PY326NCMQ\nBVESIn7BcAd8+C3wjYL8+wqRgwKBgQDfCMK8a79hYm1/ZPjcUk0jp4heFUHfbAwy\neBiB3/4rUIv/gchmkqXunFtWK/wZXUtiohTpBrsaFt0YgBm82BV7AIya4kJtG73c\nYyQjdaqCOAbS1zgx9OrASK6Cz/GzGcYOluqcEFDLNQwAvAoFRalzqcPtHhIWYkH5\nG4g7+hQUuQKBgC/LsnqljCxw/6CYMjxEsiTvlLwiXdP8tCZei2xfMb7/e/21lj2n\n7YXU17SQb41pVDiMegWrBmFl6B3vl0UoA0XDS+h1+QY20npsPtEUOPFj1f8SXx2s\n7cto1qww6szbwVEvUWsB4KsjTtEO++HhCYEaF4QU3CpDzeTQwd4EMq4bAoGBAM2x\n7LeNv9F2z3nAi+vWU6JgblomzLvbkFwzepa9GFKmVJdvAH3pHfO0bGBK7JQQAOiU\nhyhqtsBW+c4QxqvttdHdLc/igFTUUwQgw0GY0YqLVW+6Ye9g6+guoBOw6D6/tHPc\nJ7+LJJhk8g7zXWKDXsZ3eWUEaLYQJLwz8i8ucrqxAoGBAMx5AAbmArXQdbHuJuVQ\nv/RnPfUJTMhLLQbygHK2u/Nh9bn0zIuN50KGSRI2tIU28GIAstN1qFEC5teODnrh\nAqzZy1d/xTiZdNVHNN8dzmPOLKZ26EpNROYyyKwZGc/1/2lTGBVy6ctEZw31AXTm\nZoJkznb5RLIpMWVBgjiymkrA\n-----END PRIVATE KEY-----\n",
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