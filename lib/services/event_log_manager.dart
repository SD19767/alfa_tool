import 'package:alfa_tool/models/event_log.dart';
import 'package:get/get.dart';

class EventLogManager extends GetxController {
  var eventMessages = <EventLog>[].obs;
  var logs = <EventLog>[].obs;

  void addEventLog(String eventMessage, String message, EventLogType type) {
    var eventLog = EventLog(eventMessage, message, type);
    eventMessages.add(eventLog);
    logs.add(eventLog);
  }

  void clearEventMessages() {
    for (var i = eventMessages.length - 1; i >= 0; i--) {
      var aa = eventMessages[i].eventMessage;
      print('Alvin Test event messages: $aa');
    }
    eventMessages.clear();
  }
}
