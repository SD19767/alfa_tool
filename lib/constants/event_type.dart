enum EventType {
  channelCreate("channelCreate"),
  onProvisioningStart("onProvisioningStart"),
  onProvisioningScanResult("onProvisioningScanResult"),
  onProvisioningStop("onProvisioningStop"),
  onProvisioningError("onProvisioningError"),
  onSyncStart("onSyncStart"),
  onSyncStop("onSyncStop"),
  onSyncError("onSyncError"),
  stopProvisioning("stopProvisioning"),
  undefine("undefine");

  final String methodName;
  const EventType(this.methodName);
  static EventType fromMethodName(String methodName) {
    return EventType.values.firstWhere((e) => e.methodName == methodName);
  }
}
