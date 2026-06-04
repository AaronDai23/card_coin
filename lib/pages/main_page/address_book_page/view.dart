import 'package:card_coin/bean/address_book_info.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    AddressBookState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  return Scaffold(
    appBar: AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: Theme.of(viewService.context)
              .extension<GradientTheme>()!
              .primaryGradient,
        ),
      ),
      title: Text(languageResource.addressBook),
      actions: [
        TextButton(
          onPressed: () => dispatch(AddressBookActionCreator.onAdd()),
          child:
              Text(languageResource.add, style: const TextStyle(color: Colors.white)),
        ),
      ],
    ),
    body: SafeArea(
      child: BasePageLoadingView(
        errorMsg: state.errorMsg,
        loadStatus: state.loadStatus,
        buildBody: (bool isLoadSuccess) {
          return !isLoadSuccess
              ? const SizedBox()
              : state.items.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      itemCount: state.items.length,
                      itemBuilder: (_, index) {
                        AddressBookInfo item = state.items[index];
                        return GestureDetector(
                          onTap: () {
                            dispatch(AddressBookActionCreator.onEdit(index));
                          },
                          onLongPress: () {
                            dispatch(AddressBookActionCreator.onDelete(index));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: Colors.black),
                            ),
                            child: DefaultTextStyle(
                              style: const TextStyle(color: Colors.black),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${languageResource.titleName}${item.name}'),
                                  const SizedBox(height: 10),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(languageResource.titleWalletAddress),
                                      GestureDetector(
                                        onTap: () {
                                          dispatch(AddressBookActionCreator
                                              .onCopyAddress(item.address));
                                        },
                                        child: const Icon(Icons.copy, size: 20),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Text(item.address),
                                  const SizedBox(height: 10),
                                  Text(languageResource.titleRemarks),
                                  Text(item.remark),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(
                        height: 10,
                        width: 100,
                      ),
                    )
                  : EmptyListView(
                      text: languageResource.nullList,
                    );
        },
      ),
    ),
  );
}
