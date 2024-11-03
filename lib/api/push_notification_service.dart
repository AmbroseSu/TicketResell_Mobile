
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
      "private_key_id": "6e0ad2a18bbb3d3416ce32d853ab929baea66a62",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQC8qlnRv+uWEpFl\nB0G/yIMF2NkLSBiSHlKsTd6wOwCwGp5ptOeOtpKy9k3LTPxJFWrm/pAd3LFekEIO\nPQIU/syeMCkAGU0t5Ucw0aA/+vf8yItlGUfXlegpOAL/Lx70+BWcYBzZYMJp3k+m\nEV3DSBTHrNhhFb4emqpAUrkRU+NJC+n1X4q8LqerbI4IXxCNetvNUhTk3hUouM1M\nXV2FtHDbH5TalK2Tf56xICE3Et6qeSdYX4VSgoGgjtRWXTzTXMw1ULpYBqDsthsU\ncCNI7gop0ijrZfY0LLdjwp7IvdRuxn+VpDmN4xbLcrWcAUkgEP9b5sOamYj2Uamc\ndz0/xHOBAgMBAAECggEAPaCJoW3HByj+jFk//WUCg4TvdPNybzxvdfAjxz4mvd+c\nElxw7RmvNr0k8T0vBbJ0zoqlydNersyBf0Qna3NFpICHzAv3vX+w7v3ykiOpIM3j\nVr1Yzc+eW+R7eh7KxmtJJ+DvW4RzTQC81LrEfXcMrqLDtYbUKQwNg+BhqorT6fZl\nMAMNYS3aLHE+RS55T8sz+vwtebf+fK3re7xwuMn41nMe534VeuUUd5a6ojU6RKOe\nM/aNeF1XhAVAtPQyMWyXe/IxPdOy9NQvE3Yu1m2nDvM8B1vl91+7Ug5mjNGCqLAR\n0QtIs0/mqCECZpVY5y8apsVWqwhPIiyBm0zqBH2a3wKBgQD4Ar1yI7WBIo0UM1xt\n4ET+84FtfcdOIPX3wr8ViXF188zD8foE2Vp7lqstvoZ7MgRmuR8QhG6E4RzVqcI2\nxk5B++u7YfopKb9fg3ApkD+p3VjN65k5qGA9eMdGNZGRVD7SbX34kLMx501TDO34\nNCrel2ColLzLXEwagZ6QFMu11wKBgQDCvjXnTNnzI8oUad8w1c2YCjDjy0JT3NTY\n+UfvlgJA687zxaTRbxHBEO+Co06yAMuh3TGAyEfN+V5i4iUEIVdCnd+B/Uc9dsNW\nJS+Ewr0B6N5ql4XtQWcrCWOzLmeNYYrYZzLzZs8E7vXfslyfFNUhjWzvDaXA+WBk\nUF8/LObGZwKBgQCg/6Zb4jKBkhxjcLQf3+bqWsk6etxXK66BGDtTj9XH7GyRBxR2\n8WJ7uGOHXpeOgfm5dZNk9ZOJT1mYmospY7KJwzBUhFYRQripGHpHgQzTCI4Nn1Po\nyhUv0qgKO9wzq6zcjZepNMYfLzhTIaGZ7sOlnD9zMJseqNv+mQaGIfncIQKBgQC6\nK5Tkdje1lPVO5peT3BEb1EJAwsO54FcqxcTbahDld4j0ynFyNjhG1aXiwbQtv0zs\nhMUaVF0wr8Bnz8GLXURKTxqo7jT4sVy0MgBnbrO566EVTZ2e3vN91RAW77nXEvTl\nRGMVBafLE5bCL4UUH5pQ5R7KucVH4h8gRyWHA6nq6QKBgQCg3mFmmWaTExDfSc+U\nGliDmfzlwRlMOLuzzS+ZRmZqeIFhl5fx2zzcmgTOfVRHDUgKMtAyIAJIZ7Yk5Wyh\nVVEr2MWtGaLEDc6f2h4wn5PYzKyxH2VVTzoXWl9OGQdZgHlhIek3nj+b1+9D9AJy\nJVUSd0FdtbnaMfnmNqO5u7xjmw==\n-----END PRIVATE KEY-----\n",
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