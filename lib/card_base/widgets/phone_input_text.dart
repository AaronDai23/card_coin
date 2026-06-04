import 'package:card_coin/card_base/bean/country_register_info.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';
import '../../global_store/state.dart';
import '../../global_store/store.dart';
import 'country_info_dialog.dart';

class PhoneInputText extends StatefulWidget {
  final ValueChanged<int>? onCountryChanged;
  final List<CountryRegisterInfo> countryList;
  final int selectedIndex;
  final TextEditingController controller;

  const PhoneInputText(
      {super.key,
      required this.controller,
      required this.countryList,
      this.onCountryChanged,
      this.selectedIndex = 0});
  @override
  State<StatefulWidget> createState() => _PhoneInputTextState();
}

class _PhoneInputTextState extends State<PhoneInputText> {
  late CountryRegisterInfo currentCountry;

  _showCountryListDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return CountryInfoDialog(
            countryList: widget.countryList,
            currentIndex: widget.selectedIndex,
          );
        });
    if (result != null) {
      widget.onCountryChanged?.call(result);
    }
  }

  @override
  void didUpdateWidget(covariant PhoneInputText oldWidget) {
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      setState(() {
        currentCountry = widget.countryList[widget.selectedIndex];
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    currentCountry = widget.countryList[widget.selectedIndex];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = GlobalStore.store.getState();
    return Row(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _showCountryListDialog,
          child: Row(
            children: [
              const Icon(Icons.arrow_drop_down_rounded),
              LoadImage(
                currentCountry.countryFlag ?? '',
                width: 36.4,
                height: 22.4,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                '+${currentCountry.isoCode}',
                style: TextStyle(color: Colors.grey.withOpacity(0.8)),
              ),
            ],
          ),
        ),
        Expanded(
          child: TextField(
            maxLines: 1,
            controller: widget.controller,
            keyboardType: TextInputType.phone,
            maxLength: 20,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
                hintText: globalState.languageResource!.enterPhoneNo,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                counterText: ''),
          ),
        ),
      ],
    );
  }
}
