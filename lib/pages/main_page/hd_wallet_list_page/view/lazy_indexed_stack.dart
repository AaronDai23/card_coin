import 'package:flutter/widgets.dart';

class LazyIndexedStack extends StatefulWidget {
  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final int index;

  //reuse the created view
  final bool reuse;

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;

  const LazyIndexedStack({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.reuse = true,
    required this.itemBuilder,
    this.itemCount = 0,
  }) : super(key: key);

  @override
  _LazyIndexedStackState createState() => _LazyIndexedStackState();
}

class _LazyIndexedStackState extends State<LazyIndexedStack> {
  late List<Widget> _children;
  late List<bool> _loaded;

  @override
  void initState() {
    _loaded = [];
    _children = [];
    for (int i = 0; i < widget.itemCount; ++i) {
      if (i == widget.index) {
        _children.add(widget.itemBuilder(context, i));
        _loaded.add(true);
      } else {
        _children.add(Container());
        _loaded.add(false);
      }
    }
    super.initState();
  }

  @override
  void didUpdateWidget(LazyIndexedStack oldWidget) {
    // 处理 itemCount 增减（例如 tab 列表动态加载后长度变化）
    if (widget.itemCount > _children.length) {
      for (int i = _children.length; i < widget.itemCount; ++i) {
        _children.add(Container());
        _loaded.add(false);
      }
    } else if (widget.itemCount < _children.length) {
      _children = _children.sublist(0, widget.itemCount);
      _loaded = _loaded.sublist(0, widget.itemCount);
    }

    for (int i = 0; i < widget.itemCount; ++i) {
      if (i == widget.index) {
        if (!_loaded[i]) {
          _children[i] = widget.itemBuilder(context, i);
          _loaded[i] = true;
        } else {
          if (widget.reuse) {
            return;
          }
          _children[i] = widget.itemBuilder(context, i);
        }
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: _children,
    );
  }
}
