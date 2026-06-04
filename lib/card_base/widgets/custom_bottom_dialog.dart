import 'package:card_coin/global_store/store.dart';
import 'package:flutter/material.dart';
import '../../custom_widget/load_image.dart';
import 'custom_widget_button.dart';

///自定义List bottom sheet
///
/// [children] 内容列表
/// [title] 头部标题
/// [enableActionButton] 是否显示右侧按钮
/// [buttonText] 右侧按钮文本设置
/// [onConfirm] 右侧按钮点击事件
class ZenggeCustomListBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;
  final List<Widget> children;
  final String title;
  final bool enableActionButton;
  final String buttonText;
  final VoidCallback? onConfirm;
  final BuildContext context;

  const ZenggeCustomListBottomSheet({
    required this.scrollController,
    required this.bottomSheetOffset,
    required this.children,
    required this.context,
    this.enableActionButton = false,
    this.buttonText = '',
    this.title = '',
    this.onConfirm,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return _BottomSheetContainer(
      topPadding: MediaQuery.of(context).padding.top,
      bottomSheetOffset: bottomSheetOffset,
      header: _BottomSheetHeader(
        title: title,
        enableActionButton: enableActionButton,
        onConfirm: onConfirm,
        buttonText: buttonText,
      ),
      content: ListView(
        controller: scrollController,
        children: children,
      ),
    );
  }
}

///Radio列表
///
/// [list] 字行串类型列表数据
/// [title] 头部标题
/// [enableActionButton] 是否显示右侧按钮
/// [buttonText] 右侧按钮文本设置
/// [initIndex] 初始选中Index
/// [onRadioValueChanged] 选中项变化时回调方法
class ZenggeSingleChoiceBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;
  final List<String> list;
  final String title;
  final bool enableActionButton;
  final String buttonText;
  final ValueChanged<int?>? onConfirm;
  final ValueChanged<int?>? onRadioValueChanged;
  final int? initIndex;
  final BuildContext context;

  const ZenggeSingleChoiceBottomSheet(
      {super.key,
      required this.list,
      required this.context,
      required this.scrollController,
      required this.bottomSheetOffset,
      this.onConfirm,
      this.title = '',
      this.enableActionButton = false,
      this.buttonText = '',
      this.initIndex,
      this.onRadioValueChanged});

  @override
  State<StatefulWidget> createState() {
    return _ZenggeSingleChoiceBottomSheetState();
  }
}

class _ZenggeSingleChoiceBottomSheetState
    extends State<ZenggeSingleChoiceBottomSheet> {
  int? _radioGroupA;

  @override
  void initState() {
    _radioGroupA = widget.initIndex ?? 0;
    super.initState();
  }

  void _handleRadioValueChanged(int? value) {
    widget.onRadioValueChanged?.call(value);
    setState(() {
      _radioGroupA = value;
    });
  }

  @override
  Widget build(BuildContext _) {
    return _BottomSheetContainer(
        topPadding: MediaQuery.of(widget.context).padding.top,
        header: _BottomSheetHeader(
          title: widget.title,
          enableActionButton: widget.enableActionButton,
          onConfirm: () {
            widget.onConfirm?.call(_radioGroupA);
          },
          buttonText: widget.buttonText,
        ),
        content: ListView.separated(
            controller: widget.scrollController,
            itemBuilder: (BuildContext context, int index) {
              return RadioListTile(
                controlAffinity: ListTileControlAffinity.trailing,
                contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
                value: index,
                groupValue: _radioGroupA,
                onChanged: (int? index) => _handleRadioValueChanged(index),
                title: Text(widget.list[index]),
                subtitle: null,
                selected: _radioGroupA == index,
              );
            },
            separatorBuilder: (BuildContext context, int index) => Divider(
                  color: const Color.fromARGB(13, 255, 255, 255),
                  height: index == widget.list.length - 1 ? 0 : 1,
                ),
            itemCount: widget.list.length),
        bottomSheetOffset: widget.bottomSheetOffset);
  }
}

class ZenggeMultiSelectBottomSheet extends StatefulWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;
  final List<String> list;
  final ValueChanged<List<int>>? onConfirm;
  final String title;
  final bool enableActionButton;
  final String allSelection;
  final String invertSelection;
  final String buttonText;
  final BuildContext context;

  const ZenggeMultiSelectBottomSheet({
    super.key,
    required this.list,
    required this.scrollController,
    required this.bottomSheetOffset,
    required this.context,
    this.title = '',
    this.onConfirm,
    this.allSelection = 'Select All',
    this.invertSelection = 'Invert Select',
    this.enableActionButton = false,
    this.buttonText = '',
  });

  @override
  State<StatefulWidget> createState() {
    return _ZenggeMultiSelectBottomSheetState();
  }
}

class _ZenggeMultiSelectBottomSheetState
    extends State<ZenggeMultiSelectBottomSheet> {
  late List<Map> list;

  @override
  void initState() {
    list = widget.list.map((e) => {'name': e, 'isSelected': false}).toList();
    super.initState();
  }

  void _handleValueChanged(int value) {
    setState(() {
      list[value]['isSelected'] = !list[value]['isSelected'];
    });
  }

  @override
  Widget build(BuildContext context) {
    // print('widget.bottomSheetOffset:${widget.bottomSheetOffset}');
    return _BottomSheetContainer(
        topPadding: MediaQuery.of(widget.context).padding.top,
        header: _BottomSheetHeader(
          title: widget.title,
          enableActionButton: widget.enableActionButton,
          onConfirm: () {
            List<int> results = [];
            for (int i = 0; i < list.length; i++) {
              if (list[i]['isSelected']) {
                results.add(i);
              }
            }
            widget.onConfirm?.call(results);
          },
          buttonText: widget.buttonText,
        ),
        content: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 10.0),
              child: Row(
                children: [
                  NavigatorTextButton(
                    text: widget.allSelection,
                    onPressed: () => setState(() {
                      for (var element in list) {
                        element['isSelected'] = true;
                      }
                    }),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  NavigatorTextButton(
                      text: widget.invertSelection,
                      onPressed: () => setState(() {
                            for (var element in list) {
                              element['isSelected'] = !element['isSelected'];
                            }
                          })),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                  controller: widget.scrollController,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      contentPadding:
                          const EdgeInsets.only(left: 30.0, right: 15.0),
                      title: Text(list[index]['name']),
                      subtitle: null,
                      trailing: SizedBox(
                        width: 26.0,
                        height: 26.0,
                        child: list[index]['isSelected']
                            ? const LoadAssetImage(
                                'multiple_selection',
                              )
                            : const LoadAssetImage(
                                'unchecked',
                              ),
                      ),
                      onTap: () => _handleValueChanged(index),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        color: Color.fromARGB(13, 255, 255, 255),
                        height: 1,
                      ),
                  itemCount: widget.list.length),
            ),
          ],
        ),
        bottomSheetOffset: widget.bottomSheetOffset);
  }
}

///单选列表
/// [list] ListSelectBottomSheetItem 类型的列表数据
/// [title] 头部标题
/// [currentIndex] 当前选中item 的index
class ZenggeListSelectBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;
  final List<ListSelectBottomSheetItem> list;
  final String title;
  final int? currentIndex;
  final BuildContext context;

  const ZenggeListSelectBottomSheet({
    super.key,
    required this.list,
    required this.scrollController,
    required this.bottomSheetOffset,
    required this.context,
    this.title = '',
    this.currentIndex,
  });

  @override
  Widget build(BuildContext _) {
    return _BottomSheetContainer(
        topPadding: MediaQuery.of(context).padding.top,
        header: _BottomSheetHeader(
          title: title,
        ),
        content: ListView.separated(
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
                onTap: () => Navigator.of(context).pop(index),
                title: Row(
                  children: [
                    Text(list[index].name),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      list[index].subTitle,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18),
                    ),
                  ],
                ),
                trailing: currentIndex == index
                    ? const LoadAssetImage(
                        'icon_check',
                        width: 22,
                        height: 22,
                      )
                    : null,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  height: 1,
                ),
            itemCount: list.length),
        bottomSheetOffset: bottomSheetOffset);
  }
}

class ListSelectBottomSheetItem {
  final String name;
  final String subTitle;
  final String? detailText;

  ListSelectBottomSheetItem(this.name, {this.subTitle = '', this.detailText});
}

//单选左侧有图标的列表
/// [list] ListSelectBottomSheetItem 类型的列表数据
/// [title] 头部标题
/// [currentIndex] 当前选中item 的index
class ZenggeListSelectIconBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final double bottomSheetOffset;
  final List<ListSelectBottomSheetIconItem> list;
  final String title;
  final int? currentIndex;
  final BuildContext context;

  const ZenggeListSelectIconBottomSheet({
    super.key,
    required this.list,
    required this.scrollController,
    required this.bottomSheetOffset,
    required this.context,
    this.title = '',
    this.currentIndex,
  });

  @override
  Widget build(BuildContext _) {
    return _BottomSheetContainer(
        topPadding: MediaQuery.of(context).padding.top,
        header: _BottomSheetHeader(
          title: title,
        ),
        content: ListView.separated(
            controller: scrollController,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
                onTap: () => Navigator.of(context).pop(index),
                title: Row(
                  children: [
                    LoadImage(list[index].icon),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(list[index].name),
                    const SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
                trailing: currentIndex == index
                    ? const LoadAssetImage(
                        'icon_check',
                        width: 22,
                        height: 22,
                      )
                    : null,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  height: 1,
                ),
            itemCount: list.length),
        bottomSheetOffset: bottomSheetOffset);
  }
}

class ListSelectBottomSheetIconItem {
  final String icon;
  final String name;
  ListSelectBottomSheetIconItem(this.name, this.icon);
}

class NormalCustomListBottomSheet extends StatelessWidget {
  final List<Widget> children;
  final String title;
  final bool enableActionButton;
  final String buttonText;
  final VoidCallback? onBacktrack;
  final VoidCallback? onConfirm;
  final BuildContext context;
  final ScrollController? controller;
  final bool isHideHeader;

  const NormalCustomListBottomSheet({
    required this.children,
    this.enableActionButton = false,
    required this.context,
    this.controller,
    this.buttonText = '',
    this.title = '',
    this.onBacktrack,
    this.onConfirm,
    this.isHideHeader = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext _) {
    return _NormalBottomSheetContainer(
      topPadding: MediaQuery.of(context).padding.top,
      header: isHideHeader
          ? const SizedBox()
          : _BottomSheetHeader(
              title: title,
              enableActionButton: enableActionButton,
              onBacktrack: onBacktrack,
              onConfirm: onConfirm,
              buttonText: buttonText,
            ),
      children: children,
    );
  }
}

class NormalSingleChoiceBottomSheet extends StatefulWidget {
  final List<String> list;
  final String title;
  final bool enableActionButton;
  final String buttonText;
  final ValueChanged<int?>? onConfirm;
  final ValueChanged<int?>? onRadioValueChanged;
  final int? initIndex;
  final BuildContext context;
  final ScrollController? controller;

  const NormalSingleChoiceBottomSheet(
      {super.key,
      required this.list,
      this.onConfirm,
      this.title = '',
      this.enableActionButton = false,
      this.buttonText = '',
      this.initIndex,
      this.controller,
      required this.context,
      this.onRadioValueChanged});

  @override
  State<StatefulWidget> createState() {
    return _NormalSingleChoiceBottomSheetState();
  }
}

class _NormalSingleChoiceBottomSheetState
    extends State<NormalSingleChoiceBottomSheet> {
  int? _radioGroupA;

  @override
  void initState() {
    _radioGroupA = widget.initIndex ?? 0;
    super.initState();
  }

  void _handleRadioValueChanged(int? value) {
    widget.onRadioValueChanged?.call(value);
    setState(() {
      _radioGroupA = value;
    });
  }

  @override
  Widget build(BuildContext _) {
    return _NormalBottomSheetContainer(
        controller: widget.controller,
        header: _BottomSheetHeader(
          title: widget.title,
          enableActionButton: widget.enableActionButton,
          onConfirm: () {
            widget.onConfirm?.call(_radioGroupA);
          },
          buttonText: widget.buttonText,
        ),
        children: widget.list
            .asMap()
            .entries
            .map((e) => Column(
                  children: [
                    RadioListTile(
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding:
                          const EdgeInsets.only(left: 30.0, right: 15.0),
                      value: e.key,
                      activeColor: Colors.black,
                      groupValue: _radioGroupA,
                      onChanged: (int? index) =>
                          _handleRadioValueChanged(index),
                      title: Text(e.value),
                      subtitle: null,
                      selected: _radioGroupA == e.key,
                    ),
                    const Divider(
                        color: Color.fromARGB(13, 255, 255, 255), height: 1)
                  ],
                ))
            .toList());
  }
}

///自适应选择列表
class NormalListSelectBottomSheet extends StatelessWidget {
  final List<ListSelectBottomSheetItem> list;
  final String title;
  final int? currentIndex;
  final BuildContext context;
  final ScrollController? controller;

  const NormalListSelectBottomSheet(
      {super.key,
      required this.list,
      this.title = '',
      this.currentIndex,
      this.controller,
      required this.context});

  @override
  Widget build(BuildContext _) {
    return _NormalBottomSheetContainer(
      controller: controller,
      header: _BottomSheetHeader(
        title: title,
      ),
      children: list.asMap().entries.map((e) {
        int index = e.key;
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
              onTap: () => Navigator.of(context).pop(index),
              title: Row(
                children: [
                  Text(
                    list[index].name,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    list[index].subTitle,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16),
                  ),
                ],
              ),
              trailing: currentIndex == index
                  ? const LoadAssetImage(
                      'icon_check',
                      width: 22,
                      height: 22,
                    )
                  : null,
              subtitle: list[index].detailText != null
                  ? Text(
                      list[index].detailText!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFFa5a5a5), fontSize: 16),
                    )
                  : null,
            ),
            index != list.length - 1
                ? const Divider(height: 1)
                : const SizedBox()
          ],
        );
      }).toList(),
    );
  }
}

///自适应选择列表
class NormalListSelectBottomIconSheet extends StatelessWidget {
  final List<ListSelectBottomSheetIconItem> list;
  final String title;
  final int? currentIndex;
  final BuildContext context;
  final ScrollController? controller;

  const NormalListSelectBottomIconSheet(
      {super.key,
      required this.list,
      this.title = '',
      this.currentIndex,
      this.controller,
      required this.context});

  @override
  Widget build(BuildContext _) {
    return _NormalBottomSheetContainer(
      controller: controller,
      header: _BottomSheetHeader(
        title: title,
      ),
      children: list.asMap().entries.map((e) {
        int index = e.key;
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
              onTap: () => Navigator.of(context).pop(index),
              title: Row(
                children: [
                  LoadImage(
                    list[index].icon,
                    width: 20,
                    height: 30,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(list[index].name),
                  const SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
              trailing: currentIndex == index
                  ? Icon(
                      Icons.done,
                      color: Colors.grey[800],
                    )
                  : null,
            ),
            index != list.length - 1
                ? const Divider(height: 1)
                : const SizedBox()
          ],
        );
      }).toList(),
    );
  }
}

///自适应多选列表
class NormalMultiSelectBottomSheet extends StatefulWidget {
  final List<String> list;
  final String title;
  final bool enableActionButton;
  final String buttonText;
  final ValueChanged<List<int>>? onConfirm;
  final bool showHeader;
  final String allSelection;
  final String invertSelection;
  final BuildContext context;
  final ScrollController? controller;

  const NormalMultiSelectBottomSheet(
      {super.key,
      required this.list,
      required this.context,
      this.title = '',
      this.onConfirm,
      this.controller,
      this.enableActionButton = false,
      this.buttonText = '',
      this.allSelection = 'Select All',
      this.invertSelection = 'Invert Select',
      this.showHeader = true});

  @override
  State<StatefulWidget> createState() {
    return _NormalMultiSelectBottomSheetState();
  }
}

class _NormalMultiSelectBottomSheetState
    extends State<NormalMultiSelectBottomSheet> {
  late List<Map> list;

  @override
  void initState() {
    list = widget.list.map((e) => {'name': e, 'isSelected': false}).toList();
    super.initState();
  }

  void _handleValueChanged(int value) {
    setState(() {
      list[value]['isSelected'] = !list[value]['isSelected'];
    });
  }

  @override
  Widget build(BuildContext _) {
    return _NormalBottomSheetContainer(
      header: widget.showHeader
          ? _BottomSheetHeader(
              title: widget.title,
              enableActionButton: widget.enableActionButton,
              onConfirm: () {
                List<int> results = [];
                for (int i = 0; i < list.length; i++) {
                  if (list[i]['isSelected']) {
                    results.add(i);
                  }
                }
                widget.onConfirm?.call(results);
              },
              buttonText: widget.buttonText,
            )
          : null,
      subHeader: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Row(
          children: [
            ElevatedButton(
              onPressed: () => setState(() {
                for (var element in list) {
                  element['isSelected'] = true;
                }
              }),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF313138),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(widget.allSelection),
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            ElevatedButton(
              onPressed: () => setState(() {
                for (var element in list) {
                  element['isSelected'] = !element['isSelected'];
                }
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF313138),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(widget.invertSelection),
              ),
            )
          ],
        ),
      ),
      children: list.asMap().entries.map((e) {
        int index = e.key;
        return Column(
          children: [
            ListTile(
              contentPadding: const EdgeInsets.only(left: 30.0, right: 15.0),
              title: Text(list[index]['name']),
              subtitle: null,
              trailing: SizedBox(
                width: 26.0,
                height: 26.0,
                child: list[index]['isSelected']
                    ? const LoadAssetImage(
                        'multiple_selection',
                      )
                    : const LoadAssetImage(
                        'unchecked',
                      ),
              ),
              onTap: () => _handleValueChanged(index),
            ),
            index < list.length - 1
                ? const Divider(
                    color: Color.fromARGB(13, 255, 255, 255), height: 1)
                : const SizedBox()
          ],
        );
      }).toList(),
    );
  }
}

class MenuSelectBottomSheet extends StatelessWidget {
  final List<Widget> list;
  final Widget? title;
  final int? isCheck;

  const MenuSelectBottomSheet(
      {super.key, required this.list, this.title, this.isCheck});

  @override
  Widget build(BuildContext context) {
    var globalState = GlobalStore.store.getState();
    var newList = List.from(list);
    newList.add(Text(
      globalState.languageResource!.cancel,
      style: const TextStyle(color: Color(0xFFa5a5a5), fontSize: 16),
    ));
    if (title != null) {
      newList.insert(0, title);
    }

    return CustomMenuBottomSheet(
      child: ListBody(
          children: newList.asMap().entries.map((e) {
        if (e.key == newList.length - 1) {
          return Column(
            children: [
              const Divider(height: 1),
              ListTile(
                onTap: () => Navigator.of(context).pop(),
                title: Center(child: e.value),
              ),
              const SizedBox(height: 6.0)
            ],
          );
        } else {
          return Column(
            children: [
              const Divider(height: 1),
              e.key == 0 ? const SizedBox(height: 10.0) : const SizedBox(),
              InkWell(
                onTap: (title != null && e.key == 0)
                    ? null
                    : () {
                        int clickIndex = title != null ? e.key - 1 : e.key;
                        Navigator.of(context).pop(clickIndex);
                      },
                child: ListTile(
                  title: Row(
                    children: [
                      const SizedBox(width: 25, height: 25),
                      Expanded(child: Center(child: e.value)),
                      SizedBox(
                        width: 25,
                        height: 25,
                        child: title == null
                            ? Visibility(
                                visible: e.key == isCheck,
                                child: const SizedBox(
                                  width: 25,
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 18,
                                    color: Colors.green,
                                  ),
                                ),
                              )
                            : e.key != 0
                                ? Visibility(
                                    visible: e.key - 1 == isCheck,
                                    child: const SizedBox(
                                      height: 25,
                                      width: 25,
                                      child: LoadAssetImage(
                                        'icon_check',
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }).toList()),
    );
  }
}

class ContentBottomSheet extends StatelessWidget {
  final String? title;
  final String? subTitle;
  final Widget content;
  final String cancel;

  const ContentBottomSheet({
    super.key,
    required this.cancel,
    this.title,
    required this.content,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Material(
          color: const Color(0xFF212125),
          borderRadius: BorderRadius.circular(16.0),
          child: SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(
                  height: 20,
                ),
                title == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          '$title',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                subTitle == null
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        child: Text(
                          '$subTitle',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 14, color: Color(0xFFbebebe)),
                        ),
                      ),
                const SizedBox(height: 10),
                content,
                Divider(
                  height: 1,
                  color: const Color(0xFFFFFFFF).withOpacity(0.05),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    child: Text(
                      cancel,
                      style: const TextStyle(color: Color(0xFFa5a5a5)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomMenuBottomSheet extends StatelessWidget {
  final Widget child;

  const CustomMenuBottomSheet({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
          child: SingleChildScrollView(
            child: IntrinsicWidth(
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// 隐藏水波纹配置
class NoShadowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return child;
      case TargetPlatform.android:
        return GlowingOverscrollIndicator(
          showLeading: false,
          showTrailing: false,
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return GlowingOverscrollIndicator(
          //不显示头部水波纹
          showLeading: false,
          //不显示尾部水波纹
          showTrailing: false,
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
    }
  }
}

const double _kContainerBorderRadius = 14.0;

///外部框架
class _BottomSheetContainer extends StatelessWidget {
  final _BottomSheetHeader header;
  final Widget content;
  final double bottomSheetOffset;
  final double topPadding;

  const _BottomSheetContainer({
    required this.header,
    this.topPadding = 0.0,
    required this.content,
    required this.bottomSheetOffset,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: Material(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32.0),
            topRight: Radius.circular(32.0),
          ),
          color: const Color(0xFF121216),
          child: Column(
            children: [
              Visibility(
                visible: bottomSheetOffset > 0.1,
                child: header,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: Material(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(_kContainerBorderRadius),
                    ),
                    color: const Color(0xFF1c1c20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: _kContainerBorderRadius,
                      ),
                      child: ScrollConfiguration(
                        behavior: NoShadowScrollBehavior(),
                        child: content,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///头部
class _BottomSheetHeader extends StatelessWidget {
  final String title;
  final bool enableActionButton;
  final String buttonText;
  final VoidCallback? onBacktrack;
  final VoidCallback? onConfirm;

  const _BottomSheetHeader({
    this.enableActionButton = false,
    this.buttonText = '',
    this.title = '',
    this.onBacktrack,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 6, top: 10.0, right: 20.0, bottom: 10.0),
        child: Row(
          children: [
            NavigatorIconButton.close(
              onPressed: () {
                Navigator.of(context).pop();
                onBacktrack?.call();
              },
            ),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            Visibility(
              visible: enableActionButton,
              child: ElevatedButton(
                onPressed: onConfirm == null ? null : () => onConfirm?.call(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(25, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 80.0),
                  child: Text(
                    buttonText != '' ? buttonText : '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

const double _kContainerHorizontalPadding = 10;
const double _kContainerVerticalPadding = 20;

///Normal 外部框架
class _NormalBottomSheetContainer extends StatelessWidget {
  final Widget? header;
  final Widget? subHeader;
  final double topPadding;
  final List<Widget> children;
  final ScrollController? controller;

  const _NormalBottomSheetContainer({
    this.header,
    this.subHeader,
    this.controller,
    this.topPadding = 0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32.0),
          topRight: Radius.circular(32.0),
        ),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            header == null
                ? Container(
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0),
                      ),
                    ),
                  )
                : header!,
            subHeader != null
                ? Padding(
                    padding: const EdgeInsets.only(
                      left: _kContainerHorizontalPadding,
                      top: 20.0,
                      right: _kContainerHorizontalPadding,
                      bottom: 0.0,
                    ),
                    child: Material(
                      color: Colors.blue,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14),
                      ),
                      child: subHeader!,
                    ),
                  )
                : Container(),
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(
                  left: _kContainerHorizontalPadding,
                  top: subHeader != null ? 0 : _kContainerVerticalPadding,
                  right: _kContainerHorizontalPadding,
                  bottom: _kContainerVerticalPadding,
                ),
                child: Material(
                  color: Colors.grey.withAlpha(50),
                  borderRadius: subHeader != null
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(_kContainerBorderRadius),
                          bottomRight: Radius.circular(_kContainerBorderRadius),
                        )
                      : const BorderRadius.all(
                          Radius.circular(_kContainerBorderRadius),
                        ),
                  child: ScrollConfiguration(
                    behavior: NoShadowScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: ListBody(children: children),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomModeDialog extends AlertDialog {
  final String cancelText;
  final List<String> actionList;

  const BottomModeDialog(
      {super.key, required this.actionList, this.cancelText = 'Cancel'});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListView.builder(
                itemCount: actionList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context, index),
                        child: Container(
                          alignment: Alignment.center,
                          height: 32,
                          child: Text(
                            actionList[index],
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      index != actionList.length - 1
                          ? const Divider()
                          : const SizedBox()
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                alignment: Alignment.center,
                height: 42,
                margin: const EdgeInsets.only(bottom: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  cancelText,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
