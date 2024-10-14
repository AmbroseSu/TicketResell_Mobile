import 'package:ticket_resell/models/message.dart';

class Chat {
  String? id;
  List<String>? participants;
  List<Message>? messages;
  int? unreadCount;

  Chat({
   required this.id,
   required this.participants,
   required this.messages,
    this.unreadCount = 0,
});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    participants = List<String>.from(json['paracipants']);
    messages = List.from(json['messages']).map((m) => Message.fromJson(m)).toList();
    // messages = (json['messages'] != null)
    //     ? List.from(json['messages']).map((m) => Message.fromJson(m)).toList()
    //     : [];
    unreadCount = json['unreadCount'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['paracipants'] = participants;
    data['messages'] = messages?.map((m) => m.toJson()).toList();
    data['unreadCount'] = unreadCount;
    return data;
  }

}