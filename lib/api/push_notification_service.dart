
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
      "private_key_id": "7e6c4fd52c7e74beba92f15be08bdba88215fe4e",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQCiwVkggHJwC5Qg\n+PwcvlfYLrO3LqR63jt8Ui3rVK12VkQCbf8VtgzLKNY5FlI0ejjqqjaf3Vk0hAAH\nZpkMy7c/NaEZ/2dW59oSpfr6lKYsiP1XZbyICyWhs2Iq/SxDq5RbvnHhPuEaqb81\na7HxxvOEbS+VN0uHCW8WumwTbHRWL8WDwKcOMKIpap2gISlszreR5JMweHtt9Kae\nSPj6ciMvCf5kRS+Eon93osxUueTZV5FZMirmwJrLaQw2cr9gBGvcuqrEFcxpJ/mQ\n+/Mn7t3yoaj/l8dGApXs977nlVmR21EdspuqFC38nyBm4kqTN9oDVTJpDF/jx/nw\n41Jjf5UvAgMBAAECggEAKZLS9erpkHZcsal4GM2EOdwAGxAmgp4musRxJ1Y7culp\nOOepC34zuWdmhTGO8QmxZTvydRaA9Vmsejd6a9rTpalIzA/B8WCLA01zlTOIWQLr\nF7qMlIGobKwaLNn7xxNac67rfvplXL60cWxfiV9lD9QmHesAd29w+XDIL5P6CZOE\n1hERQAD/9hEkzWC/g5o9JJnNhFOU0rmFb2OaFQbBeVFlaEHz+04QxO7GEc9iK+WP\nYFkugxH0yc7BBKQsMhWqW5wjTqkeHJ4IJGmrsCPy9VQr7HJa8e7+8yxnpuNpJBZo\nbrelWHfYCX/JpUock/0rpyq3LihDuugOtoPExc6V0QKBgQDZg2nuUP4L9M3C7P2/\npEJeoHceZ8ToLV7LuqEDuWrrOIc34xCuPrVHysiwn+BPw9GPNVZg+qGTbmlD+Icw\n025iLQnemIrq82AzHrqV/ddW9S6X+qTV7nBYDRz6NFTpC2UtCx86DRCz62SF14nw\nuCL1g2vkgC2i0MKN+yeBNCjY3wKBgQC/jZZPRGxWpl7FDaEl1aRl/WUDWBSEprGz\nJWWc7n+VfT7IWFaz002E8m5b5Pe9LRPgygAYPtRxZU9R45nmEBQjftMD5ez3/VgR\npZYuTd+pxpI8YuhyPmS54HIOrAhmj/cCKPpILES+fLx0qiAldoYJrXgPU/pVzZcG\nbQVsCHu9sQKBgQDCjLIhALxaAVpRMRw9XzQl4yzoOzR53qrdWk5OQHgLcAIx0JzI\n3TnTvuMGZ9mAPsufZbue/k2qyqTIsPBqkZI3qcUcHiCSyaCP2LpXEjabhq1oLj1l\nQ+GkQAZdHJWd5B1YzovdpnX8F11QAVtVvb03D5dfR+6JpGOADtZk0DyAzQKBgGAy\n6iba9RG7MeMCikim944k6OL6DCvmT13pzRM4D6jyomIZQ0nCN68p1VSfM++0wMPm\njo+eljBwsZotlK+eqY599dmCUjTk7aLHJxoQD+CCkhRzk8s0HH/hAUbvDLT9Xg6e\np7sxSEDmAfsRKV3HHV+k16PTB+ipfExE2jE8PXCxAoGAJmNfswrh1tloKAxRLptm\nMhboI9KrWuTuMAX+coJmBJE2NMNK6wP4g1R+XKFD5GMIyfCL+rA2wpx41iHTLQDV\nYLDiSCDJMWgoUat9N9U/ie6mQ6zl+nodg1JdF5MUmFAugzzKTOp1BU4wt2uNc1mv\nhrKaAAmJVZqOnnUI5V2AY+0=\n-----END PRIVATE KEY-----\n",
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