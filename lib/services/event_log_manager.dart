import 'package:alfa_tool/models/event_log.dart';
import 'package:get/get.dart';

//todo: 命名要用service 因為他本來就是service。 為不同的controller 服務，綁的頁面不一樣，應該要獨立。
class EventLogManager extends GetxService {
  //todo: 再用一個getter 包裝，外面是唯讀的。
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
