class EventLog {
  String eventMessage;
  String message;
  EventLogType type;
  EventLog(this.eventMessage, this.message, this.type);
}

enum EventLogType { success, failure, info, stop }
