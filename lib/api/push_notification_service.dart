
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
      "private_key_id": "5e0f94653cbd4e5d0450ad7acfcbb5055c8d5a55",
      "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDXzcjSWhY+OkOE\nFUGfy96C1XbAv4B9+ncL9qFBxqNItw05oZ+4qWcw943zLqQ/14PF+y4XDm9j9tPM\nE+fLDoNYnii2buqEsjzUbooVdWmbK1ye40a1c4dAbhbFNrVA8cYUyTGrV4D3XEUW\nTkJErCr+lsGASNH6sUn2CZ51me8LzEhlWAouDDZWIfkaXH+2auhEy/WgseT62D+T\nVxecDbkldD8F7VUwgsylE5HE+HbJwAWYB8QGRYqjL0AaeAYQyM3RlGcDoP+E/nBX\n5AcZPqOAJ408GkDdlszTIo9/guwBYEqp6ptza6pwLNZblpeogfsFPlvi+YpUeTWt\ng049+S4TAgMBAAECggEAHQG7EZMsVDbupk1ZIcp8YSeiK6xR8Bz/bWs8J6Q0hGye\naXWxC1gx16IewWYui6pDOxRVEKJPFKeztkWirWeI/htcK5FjEm0GwiMNim7awBGn\nBHBWK8OYlW92vhFpcY5N6rNUasx7OER9wM7KF4Lw0IGhBsZC+yhjYZ/PXc1QFUyj\n3iw8QeOjRThAtS28UqUzF1w2oXAQSGVodNqRY3q01U8Sb1uLgjUX4pEmXeAejms9\ncZF38OndNJiXLyy9lpQAdpbkClI4UkVOz5Wrxgeomlu65umN1DwQ2RQX75285YsC\nDGE0rEPVGzvM/pc1f545GpO///gxZhxq7E8WZFW4QQKBgQD0eiVGJiNyrdmZfGRd\nZmSd6HInI4mLJ+N72HneFwomQwes6i6ZELG8VS3zx7ZSEFvANSRu0qiutWrySfqs\nJljFs3LUeqyqR5VFLjygZGa1YxIKGNCJe1NB1PVyARA6hhK8B8Zpj4XHmV/o6tZM\nhvivZRY1CXibmskGQjZGyircIQKBgQDh+arzR+A+pgAwCAeb7C8ofPpIYbQkr9SC\nzLT/OLJPQjZoevM5Jxfw9wbddUvHevHyxVmRZ8EQ3WlKa8t5fvs0XFdCWVg6BjwB\nUVZlsq4uDDgHhZ4liCmlo0ZIIphXeJLwJsTuR7zP1MTXhFUc/KL+W5Oh37AlcFBm\nCHanRtDjswKBgHhP1CAdjLxXCgsayFmelk2Pov3X40x0KOM9uVuugvQpcJGL/bqe\nGJnSYXbjBbqFCmIgxPk0+oZgCW2LMq2dgXppwU0HwglaiP8ure9Q+aqyQqJta9L8\nuhBfuRqNo2rpqDaYrPAuDWwY8rYxO50VnzTRzofzTUNmfR9zXjqgK0+BAoGBANao\no3KscWExsXXu+sNsDbQJXHtLjKNY/6csrDbRddiCjkqbmNZOw5hcIIJYfR7GNHWo\ncJgGlkjd+rn+QfBs5lXr7dwSIRQlffTGfirnHDyT0NmcXQlMGjvFKOs3Kb3VxMcq\nHOI49Sv78uzDQVLizjaPaWNYqOw3j7gNDCGEzMOvAoGBANlHsX/4qtiFOvrqLU+4\nb8ojcnYF0Iyxfi1TAX/WmPdJBGSBDn9WtI0wlMHq0h5rydOvoJq7y3Up0nCr/zJm\n21CI/JVSWdQO2nA3xjBBchSyhF2kIu7se+4iABJnLYpHe9J5VNjomvDhBaAElssv\nMUzLyAhmIa4VxaCpOnwLLwur\n-----END PRIVATE KEY-----\n",
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