import 'package:flutter/material.dart';

class PopWindow extends StatefulWidget {
  final Widget child;
  final GlobalKey targetWidgetKey;
  final EdgeInsets padding;
  final useAnimation;
  final RouteObserver? routeObserver;
  final double childHeight;
  final double childWidth;

  const PopWindow(
      {Key? key,
      required this.targetWidgetKey,
      required this.child,
      required this.childHeight,
      required this.childWidth,
      this.useAnimation = false,
      this.routeObserver,
      this.padding = EdgeInsets.zero})
      : assert(useAnimation ? routeObserver != null : true,
            'if you useAnimation, the routeObserver must not null!'),
        super(key: key);

  @override
  _PopWindowState createState() => _PopWindowState();
}

class _PopWindowState extends State<PopWindow>
    with TickerProviderStateMixin, RouteAware {
  double? left;
  double? top;
  double? right;
  double? bottom;
  bool positionFinish = false;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    if (widget.useAnimation) {
      animationController = AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200));
    }
    Future(() {
      widget.routeObserver?.subscribe(this, ModalRoute.of(context)!);

      RenderBox renderBox = widget.targetWidgetKey.currentContext!
          .findRenderObject() as RenderBox;
      Offset localToGlobal = renderBox.localToGlobal(Offset.zero);
      var targetWidgetSize = renderBox.size;
      top = localToGlobal.dy - widget.childHeight - 32;
      // left = localToGlobal.dx + (targetWidgetSize.width-widget.childWidth)*0.5;
      left = localToGlobal.dx -
          (widget.childWidth - targetWidgetSize.width) -
          targetWidgetSize.width * 0.5 -
          16;

      setState(() {
        positionFinish = true;
        animationController?.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!positionFinish) {
      return Container();
    }
    return GestureDetector(
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
          ),
          Positioned(
            right: right,
            left: left,
            top: top,
            bottom: bottom,
            child: widget.useAnimation
                ? ScaleTransition(
                    scale: CurvedAnimation(
                        parent: animationController!,
                        curve: Curves.fastOutSlowIn),
                    alignment: Alignment.bottomRight,
                    child: widget.child)
                : widget.child,
          )
        ],
      ),
      onTap: () {
        animationController
            ?.reverse()
            .whenComplete(() => Navigator.of(context).pop());
      },
    );
  }

  @override
  void didPop() {
    animationController?.reverse();
  }

  @override
  void dispose() {
    widget.routeObserver?.unsubscribe(this);
    animationController?.dispose();
    super.dispose();
  }
}

enum PopDirection {
  topLeft,
  topRight,
  centerLeft,
  centerRight,
  bottomLeft,
  bottomRight,
}

class PopRoute<T> extends PopupRoute<T> {
  static const Duration _duration = Duration(milliseconds: 200);
  Widget child;

  PopRoute({required this.child});

  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  Duration get transitionDuration => _duration;
}

Future<T?> showPopWindow<T extends Object?>(
    {required BuildContext context,
    required GlobalKey targetWidgetKey,
    required Widget child,
    required double childHeight,
    required double childWidth,
    bool useAnimation = false,
    RouteObserver? routeObserver,
    PopDirection direction = PopDirection.topLeft,
    EdgeInsets padding = EdgeInsets.zero}) async {
  return Navigator.of(context).push<T>(PopRoute(
      child: PopWindow(
    targetWidgetKey: targetWidgetKey,
    childHeight: childHeight,
    childWidth: childWidth,
    useAnimation: useAnimation,
    routeObserver: routeObserver,
    padding: padding,
    child: child,
  )));
}
