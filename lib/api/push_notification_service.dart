
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
      "private_key_id": "ef98b1ed1c29bb28e00283428c2fef02244220a8",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDIrnftvZGgcpHr\no6k+Clu7My1kqYieB1m4OMye2Bl2SjR5II8Ed6sD46gYkhm4LA+aoHzawllClBMl\n3n/f7YICJ7oLTmFB+z3zoVD4dAbiahNKqmDP+xTRXwYBbolq4af7eVGYuRZHoXQ2\n98txMwh7kU0hydMXrMXDZNdidMLyG6J03gvbh96clEFXx2Jire+ccOlsqPEi50g5\nM2ESY3leNGuveYzWUq96f9qTpgockmBwDLt2LDpfkxW/9e4mUtdzqnJ9DuwCzKfz\n+6ysdMbjBtgKdHyD3rHidDUBJwUjbywwVCpxUuOaZbDcUyOvLD/AVoul2UB4Rc/J\nxAX9Ym75AgMBAAECggEAKK+uouWnK7duvC5/NpPVCzwR/PGeQCPPXdkuKxo291OO\nFeyy8j3szyoNv4WHb16Hf1sAVT3H6QaqZygYFudJT3SMdJRchYsRgV54Uxb6+lZ1\nONMYM7J9AwHX7txhQekkLIjpMSR9TuJ99FMCzR2Cn8LSt4H6qTcfFUFRpaV0jK8P\nPg2lpTYczb+1alLZ4z+dLn7xrv93D2R6VcV/CKg9nv9Ot43yLYvWUxkG2AamL/sG\nUPQ09iETbBFsOBPKxRpkStTdnN4hRfNNGEn/WhcKIH8RlI1Mimat1q0ZX1waQUbd\n0491mPncfqfzRSx3IspF8xzLvLYsKpYy7+sgfcT3MQKBgQD6reBIRn7wL7mB8MSK\nPl+bk3LdoH5SBaSowZDRaIlCp+4bhrSj7Xaq5hsxSRwFDg0XvVkZDGB9h46w0T1U\nw9CrkV0fmVeylRl2AG3aeJHLo5/i/rJLf4v0QSBi8a+sZTCF8q/ikfAcIuhbVj0+\naOJg25Kr/un7M/LFCpc1C+AtrQKBgQDM8OsUsuJR8RLef6X+J1I7Lbtl8t71h4HS\n4tIAC28pQlPYEizv7rxOldTamCMNlHDurupQz63EVfzMLKoEW2BoeWji4Ggheme0\n0gcYHuqqLmerKhs45yEpiZxq4IXS1Jx/KMA2/II2uTNZs8q1weDQILC0ty2tt7n0\nuO5sAX3X/QKBgQCDm1u/tjsYkIW9IZGd3qdFP4Ezt/n5x/qtmooUVuSROSb6Dpux\n4I7HpG0sT+zE/p6DEya+zs+tt8iDLicb5H4eRP/2AgSXvk2StSD3bQtmNS5Q91TV\n7E2m27ZMHAUV5j42ZLZQpjvAGdeRdFJM/LW1EjIL2JYxCxHuvuOptuVoNQKBgDzT\nSEJFcWx2i24kHqUXEI3l3de9RLVEuaBYl5FR03VAbVgU1OeFSLheOeWC/+xY4UfF\n/F9ttBowly4WF4PhhvSbDClCB0XgaYU+TMK48lb+HOCtR5UU7D/CyvzhlHZliekn\ntBzdxtvtDbOS7BgT6eB7w1Zvg4wqmnNqq8C8lJgVAoGAB42gm6NyOxjE1s6evMGo\nVjZI/DiMsvCZxczINmOs7fBlFGnNvQ0JPbk9nYfr8Owtquk2ah/fNuUaEwdawCPy\nUhMgyPBTk6pv+r0q/PB34IpdlegplavtQkpnJnPSh1p1cVIfAVrNmlURqfQRuKnM\nAoy9ATOwzDbsSqXOMzXhcg8=\n-----END PRIVATE KEY-----\n",
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