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
    eventMessages.clear();
  }
}
