import 'package:flutter/material.dart';
// import 'package:network_capture/db/app_db.dart';
// import 'package:network_capture/http/capture_http_overrides.dart';
// import 'package:network_capture/view/network_list_widget.dart';

class DeveloperWidget extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const DeveloperWidget(
      {super.key, required this.navigatorKey, required this.child});

  @override
  State<StatefulWidget> createState() {
    return _DeveloperWidgetState();
  }
}

class _DeveloperWidgetState extends State<DeveloperWidget> {
  Offset _offset = const Offset(70, 50);

  @override
  void initState() {
    super.initState();
    // HttpOverrides.global = CaptureHttpOverrides();
    // AppDb.instance.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Overlay(
        initialEntries: [
          OverlayEntry(
            builder: (c) {
              return widget.child;
            },
          ),
          OverlayEntry(
            builder: (c) {
              return Positioned(
                left: _offset.dx,
                top: _offset.dy,
                child: Draggable(
                  childWhenDragging: Container(),
                  feedback: _developerWidget(),
                  child: _developerWidget(),
                  onDragEnd: (DraggableDetails detail) {
                    setState(() {
                      _offset = detail.offset;
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _developerWidget() {
    return Container(
      child: Card(
        color: Colors.blue.withOpacity(0.5),
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              TextButton(
                  onPressed: () async {
                    // NetworkListWidget.showDialog();
                  },
                  child: const Text(
                    "网络",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
