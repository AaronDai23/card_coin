import 'package:card_coin/card_base/bean/country_register_info.dart';
import 'package:flutter/material.dart';

import '../../custom_widget/load_image.dart';
import '../../global_store/state.dart';
import '../../global_store/store.dart';

class CountryInfoDialog extends StatelessWidget {
  final List<CountryRegisterInfo> countryList;
  final int currentIndex;

  const CountryInfoDialog(
      {super.key, required this.countryList, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    GlobalState globalState = GlobalStore.store.getState();
    return AlertDialog(
      title: Text(globalState.languageResource!.selectCountry),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(globalState.languageResource!.cancel))
      ],
      content: Container(
        constraints: const BoxConstraints(maxHeight: 300),
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: countryList.length,
          itemBuilder: (context, index) {
            var item = countryList[index];
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(index),
              child: Card(
                color: const Color(0xFFF1F1F1),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      LoadImage(item.countryFlag ?? '',
                          width: 36.4, height: 22.4),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(child: Text(item.countryName ?? '')),
                      SizedBox(
                          width: 50,
                          child: Row(
                            children: [
                              Text('+${item.isoCode ?? ''}'),
                              currentIndex == index
                                  ? const SizedBox(
                                      width: 20,
                                      child: Icon(
                                        Icons.check_circle,
                                        size: 18,
                                        color: Colors.green,
                                      ),
                                    )
                                  : const SizedBox(
                                      width: 20,
                                    )
                            ],
                          ))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
