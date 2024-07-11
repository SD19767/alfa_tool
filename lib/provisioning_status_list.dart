import 'dart:ui';
import 'package:alfa_tool/provisioning_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProvisioningStatusList extends StatefulWidget {
  final bool isDarkMode;
  final RxList<EventLog> eventMessages;
  final VoidCallback onComplete;
  final ProvisioningState provisioningState;

  ProvisioningStatusList(
      {required this.isDarkMode,
      required this.eventMessages,
      required this.onComplete,
      required this.provisioningState});

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
        padding: const EdgeInsets.only(bottom: 36.0),
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
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidthPadding = screenWidth / 6;
    double screenHeightPadding = screenHeight / 4;
    return Container(
      padding: EdgeInsets.only(
          left: screenWidthPadding,
          right: screenWidthPadding,
          top: screenHeightPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
              children: List.generate(_messages.length, (index) {
                return _buildItem(
                    context, _messages[index], widget.isDarkMode, index);
              }),
            ),
          ),
          SizedBox(height: 24),
          AnimatedOpacity(
            opacity: widget.provisioningState == ProvisioningState.complete
                ? 1.0
                : 0.0,
            duration: Duration(milliseconds: 300),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: widget.isDarkMode
                        ? CupertinoColors.systemIndigo.withOpacity(0.6)
                        : CupertinoColors.systemIndigo.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CupertinoButton(
                    onPressed: widget.onComplete,
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: widget.isDarkMode
                            ? CupertinoColors.white
                            : CupertinoColors.black,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 24)
        ],
      ),
    );
  }
}

class EventMessage {
  final String message;
  final EventLogType type;

  EventMessage({required this.message, required this.type});
}
