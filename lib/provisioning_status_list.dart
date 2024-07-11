import 'package:alfa_tool/provisioning_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProvisioningStatusList extends StatefulWidget {
  final bool isDarkMode;
  final RxList<EventLog> eventMessages;

  ProvisioningStatusList({
    required this.isDarkMode,
    required this.eventMessages,
  });

  @override
  _ProvisioningStatusListState createState() => _ProvisioningStatusListState();
}

class _ProvisioningStatusListState extends State<ProvisioningStatusList>
    with TickerProviderStateMixin {
  List<EventMessage> _messages = [];
  List<AnimationController> _animationControllers = [];
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initializeMessages(widget.eventMessages);
    widget.eventMessages.listen((_) => _updateMessages(widget.eventMessages));
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _initializeMessages(List<EventLog> eventLogs) {
    _messages = eventLogs
        .map((eventLog) => EventMessage(
              message: eventLog.message,
              type: eventLog.type,
            ))
        .toList();
    _initializeAnimations();
  }

  void _updateMessages(List<EventLog> eventLogs) {
    setState(() {
      List<EventMessage> newMessages = eventLogs
          .map((eventLog) => EventMessage(
                message: eventLog.message,
                type: eventLog.type,
              ))
          .toList();

      int oldLength = _messages.length;
      _messages = newMessages;
      _initializeAnimations(fromIndex: oldLength);
    });
  }

  void _initializeAnimations({int fromIndex = 0}) {
    for (var i = fromIndex; i < _messages.length; i++) {
      AnimationController controller = AnimationController(
        duration: Duration(milliseconds: 500),
        vsync: this,
      );
      Animation<double> animation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      );
      _animationControllers.add(controller);
      _animations.add(animation);
      controller.forward();
    }
  }

  Widget _buildItem(
      BuildContext context, EventMessage event, bool isDarkMode, int index) {
    IconData icon;
    Color color;

    switch (event.type) {
      case EventLogType.success:
        icon = Icons.check_circle;
        color = isDarkMode ? Colors.blue : Colors.green;
        break;
      case EventLogType.failure:
        icon = Icons.error;
        color = isDarkMode ? Colors.red : Colors.redAccent;
        break;
      case EventLogType.info:
        icon = Icons.info;
        color = isDarkMode ? Colors.yellow : Colors.orange;
        break;
      case EventLogType.stop:
        icon = Icons.stop_circle;
        color = isDarkMode ? Colors.grey : Colors.grey;
        break;
      default:
        icon = Icons.circle;
        color = isDarkMode ? Colors.grey : Colors.grey;
    }

    return FadeTransition(
      opacity: _animations[index],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            SizedBox(width: 12.0),
            Expanded(
              child: Text(
                event.message,
                style: TextStyle(
                  color: isDarkMode
                      ? CupertinoColors.white
                      : CupertinoColors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenWidthPadding = screenWidth / 6;
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidthPadding, vertical: 160),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(_messages.length, (index) {
          return _buildItem(
              context, _messages[index], widget.isDarkMode, index);
        }),
      ),
    );
  }
}

class EventMessage {
  final String message;
  final EventLogType type;

  EventMessage({required this.message, required this.type});
}
