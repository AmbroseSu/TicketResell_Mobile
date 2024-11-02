
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
      "private_key_id": "802629908d0154021f50ab0372ebeed661502dc0",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCeEhz27EhgkvC8\nYIdRuuwSQipEZa4j+oqsPV5KdFd6Z0PvGFtI95UXrpp5ygb3ONlWBisqaiFVbdip\n6DtDhi4Wf0nLCg+7eLIHK/tVskwrUF8ss4EXSco2T8NRX+K/FjkvEWkFMAkR+4JH\nbCh6MSe7PEfW5JQ5ItJMBIBEMS5jHYAC0A0qFSsRhTtqJMKyxqxoGUa8y0VvQJGX\n+5HBxq/sQH2EP2v3Af/+kMlk+j+lrOP0UDMWp+wgy+Nn3hCUTfPjC4UlAUPJHUM5\n/ZhHfYXZjHmcjpNvPiPX+HtHh+T/74oHSdnraB2awoobpCrrgFi4SqO0fjBtqZN9\nMdiWBr5BAgMBAAECggEAATt0dSQSx8keIMYlnehtsVIpg/tGhhEnSjgSVhUgZAko\nrK/WsSvIF7KmBthRZoqvg+HkIvZdIcjrlHOrEm/fXXq9lvcCTViaYNoPMWFZ7MiZ\nd6wt+ndku43yq0hqozPWQKi+ML2O74sDnoC1nidn5x1dX8EWyvfQ66mUEfwFFR3q\noynisJDuh64CiwRrYdiwi1CgrsOb2ai5p5yD0FNfApxmCPxX0XLK3SmsKg8eYpUp\nB2BAlW7zc/pUE99rrS+lTOMzTAS1/p0VPOeCWa7gf110RkKseu+bqk7hnB0urgXS\nqrANGTmn0SDgAhKt1BNLAVThtwqwVFPnf3e5SelZQQKBgQDSSNzC3dXKZ6RaHnjy\nW5++U3HdzfEWuY0a6EX4PrU6reoH5/5Mj45fjIHx0KT5io2geNIEJ3nfX3MTm+56\nHDpKjC1JODIvAvwhcogEkcZQnUQs/38+5lcH3njJk1lXPWB6fv7dimBI5tMZNPov\ng3IuhJSLf8tc6ziMKBRxLX9n4QKBgQDAb1nYW4hEmXKynmuhxhL5D3aLl9eBQ6gt\nnvP4MRSGnOOri4IkZ5LfDQUQUK5ecXPJNgPYjQ4Zpuja4vnd1yboXWnBV8vOozPs\nflWUHVNRolF6fZSUoOkQGFVs3sitPwYY/tMy8Rwv4e2ZE4AeQBCL3wXQ7HnvQk+1\n6zk7SYSiYQKBgQCu38MfFuZk9X3bJ/5C5mlZGQHXiB1XXaV32/PcNyH1k43NV2PG\nfZfT5ABofa/EijGvYuqcY8vZNAJ6KzHOQM1FE3/RpTcum1fb5OgyjJwUjESW+z7x\nqxJzS9K9J5mjkDo8hIIk8J+T4Mlq7ACnJLP+9Wim/fa75i1XeTlOyZxrYQKBgF8h\n7Um/nnNDZOeW1+Dm+hQ0p8dE7p4R43+COFw3b01JHGh/FHyI05v/ZMR3DmzUK4iK\ncoZI3XKjCDTFxv770VlIbPLPQ4tJNW8x2X7arIkL9LnYgW6kyfNSBFFJJe433PzY\nZXKmreeiCoMFl+3cgBGV1Ns/PNyibKOjwOxlYPOhAoGBAK0ILg6tly72YkdkAcAJ\nZabejsazyVJ1ji1VArGW5jOQWsGmjoDG2dqfI7vhDCbAk46tSrimrc7QfvnfEmlt\nO5nc+NApmcTcGFDL9ev5TmAodJcz4ewgA4lr5BqBow07HJVX7NvHo1ou33b6v5AV\n/k93FYR3Sf3qtr1Y56tjsZiy\n-----END PRIVATE KEY-----\n",
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