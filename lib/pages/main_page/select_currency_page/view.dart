import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/custom_widget/custom_button.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:card_coin/pages/main_page/select_currency_page/item_state.dart';
import 'package:card_coin/widget/base_page_loading.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'action.dart';
import 'state.dart';

Widget buildView(
    SelectCurrencyState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  var searchText = state.searchText.toLowerCase();
  List<NetworkItemState> showList;
  if (state.searchText.isNotEmpty) {
    showList = state.coinList
        .where((element) =>
            element.bean.name.toLowerCase().contains(searchText) ||
            element.bean.symbol.toLowerCase().contains(searchText))
        .toList();
  } else {
    showList = state.coinList;
  }
  return WillPopScope(
      onWillPop: () async {
        String selectedStatusStr =
            state.coinList.map((e) => e.isSelected).join(',');
        if (selectedStatusStr == state.selectedStatusStr) {
          return true;
        } else {
          dispatch(SelectCurrencyActionCreator.onShowNotSaveTips());
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: Theme.of(viewService.context)
                  .extension<GradientTheme>()!
                  .primaryGradient,
            ),
          ),
        ),
        // body:
        body: Column(
          children: [
            // Row(
            //   children: [
            //     Expanded(
            //         child: Container(
            //       margin: EdgeInsets.all(10.0),
            //       decoration: BoxDecoration(
            //           color: Colors.grey.shade200,
            //           borderRadius: BorderRadius.circular(10.0)),
            //       child: TextField(
            //         maxLines: 1,
            //         controller: state.searchController,
            //         onChanged: (text) => dispatch(
            //             SelectCurrencyActionCreator.onTextChanged(text)),
            //         style: TextStyle(fontSize: 14),
            //         decoration: InputDecoration(
            //           hintText: languageResource.pleaseInput,
            //           hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
            //           border: OutlineInputBorder(borderSide: BorderSide.none),
            //         ),
            //       ),
            //     )),
            //   ],
            // ),
            Expanded(
                child: PageDataLoadingView(
                    onLoadSuccess: () {
                      return SmartRefresher(
                          enablePullUp: true,
                          onRefresh: () =>
                              dispatch(SelectCurrencyActionCreator.onRefresh()),
                          onLoading: () =>
                              dispatch(SelectCurrencyActionCreator.onLoading()),
                          controller: state.refreshController,
                          child: showList.isNotEmpty
                              ? ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final coinItem = showList[index];
                                    return Card(
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0)),
                                        shadowColor: const Color(0x88000000),
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: ListTile(
                                                leading: Container(
                                                  width: 40,
                                                  height: 40,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25)),
                                                  child: LoadImage(
                                                      coinItem.bean.icon),
                                                ),
                                                title: Text(coinItem.bean.name),
                                                // subtitle: Text(state.bean.id),
                                                trailing: Switch(
                                                    value: coinItem.isSelected,
                                                    onChanged: (value) => dispatch(
                                                        SelectCurrencyActionCreator
                                                            .onSwitchChanged(
                                                                coinItem
                                                                    .bean.id,
                                                                value))))));
                                  },
                                  itemCount: showList.length,
                                )
                              : EmptyListView(
                                  text: languageResource.notConfigured,
                                ));
                    },
                    loadStatus: state.loadStatus)),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 20, top: 8),
              child: CCButton(
                child: Center(child: Text(languageResource.savechanges)),
                onPressed: () =>
                    dispatch(SelectCurrencyActionCreator.onSaveClick()),
              ),
            )
          ],
        ),
      ));

  // SafeArea(
  //   child: PageDataLoadingView(
  //     onReload: () {
  //       dispatch(SelectCurrencyActionCreator.onShowLoading());
  //       dispatch(SelectCurrencyActionCreator.onLoadData());
  //     },
  //     onLoadSuccess: () {
  //       return Column(
  //         children: [
  //           Expanded(
  //             child: ListView.builder(
  //               itemBuilder: (BuildContext context, int index) {
  //                 final coinItem = state.coinList[index];
  //                 return ExpansionTile(
  //                   title: Text(coinItem.name),
  //                   leading: Container(
  //                     width: 40,
  //                     height: 40,
  //                     alignment: Alignment.center,
  //                     decoration: BoxDecoration(
  //                         color: Colors.black54,
  //                         borderRadius: BorderRadius.circular(25)),
  //                     child: LoadImage(coinItem.icon),
  //                   ),
  //                   subtitle: Padding(
  //                     padding: const EdgeInsets.only(top: 8.0),
  //                     child: Wrap(
  //                         children: coinItem.tokenNetworks
  //                             .map((e) => Stack(
  //                                   children: [
  //                                     Container(
  //                                       width: 24,
  //                                       height: 24,
  //                                       alignment: Alignment.center,
  //                                       decoration: BoxDecoration(
  //                                           color: Colors.grey.shade200,
  //                                           borderRadius:
  //                                               BorderRadius.circular(
  //                                                   12)),
  //                                       child: LoadImage(e.bean.imageUrl),
  //                                       margin: EdgeInsets.symmetric(
  //                                           horizontal: 3.0),
  //                                     ),
  //                                     if (e.isSelected)
  //                                       Positioned(
  //                                           right: 4,
  //                                           child: Container(
  //                                             width: 6,
  //                                             height: 6,
  //                                             decoration: BoxDecoration(
  //                                                 color: Colors
  //                                                     .green.shade400,
  //                                                 borderRadius:
  //                                                     BorderRadius
  //                                                         .circular(3)),
  //                                           ))
  //                                   ],
  //                                 ))
  //                             .toList()),
  //                   ),
  //                   children: coinItem.tokenNetworks
  //                       .map((e) => Padding(
  //                             padding: const EdgeInsets.only(left: 30.0),
  //                             child: Row(
  //                               mainAxisAlignment:
  //                                   MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 LoadImage(
  //                                   e.bean.imageUrl,
  //                                   width: 30,
  //                                   height: 30,
  //                                 ),
  //                                 Text(e.bean.networkId),
  //                                 Switch(
  //                                     value: e.isSelected,
  //                                     onChanged: (value) => dispatch(
  //                                         SelectCurrencyActionCreator
  //                                             .onSwitchChanged(
  //                                                 coinItem.id,
  //                                                 e.bean.networkId,
  //                                                 value)))
  //                               ],
  //                             ),
  //                           ))
  //                       .toList(),
  //                 );
  //               },
  //               itemCount: state.coinList.length,
  //             ),
  //           ),
  //           Padding(
  //             padding: EdgeInsets.only(
  //                 left: 20, right: 20, bottom: 20, top: 8),
  //             child: CCButton(
  //               child: Center(child: Text('Save changes')),
  //               onPressed: () =>
  //                   dispatch(SelectCurrencyActionCreator.onSaveClick()),
  //             ),
  //           )
  //         ],
  //       );
  //     },
  //     loadStatus: state.loadStatus,
  //     errorMsg: state.errorMsg,
  //   ),
  // ),
  // );

  //  return ExpansionTile(
  //                           title: Text(coinItem.name),
  //                           leading: Container(
  //                             width: 40,
  //                             height: 40,
  //                             alignment: Alignment.center,
  //                             decoration: BoxDecoration(
  //                                 color: Colors.black54,
  //                                 borderRadius: BorderRadius.circular(25)),
  //                             child: LoadImage(coinItem.icon),
  //                           ),
  //                           subtitle: Padding(
  //                             padding: const EdgeInsets.only(top: 8.0),
  //                             child: Wrap(
  //                                 children: coinItem.tokenNetworks
  //                                     .map((e) => Stack(
  //                                           children: [
  //                                             Container(
  //                                               width: 24,
  //                                               height: 24,
  //                                               alignment: Alignment.center,
  //                                               decoration: BoxDecoration(
  //                                                   color: Colors.grey.shade200,
  //                                                   borderRadius:
  //                                                       BorderRadius.circular(
  //                                                           12)),
  //                                               child:
  //                                                   LoadImage(e.bean.imageUrl),
  //                                               margin: EdgeInsets.symmetric(
  //                                                   horizontal: 3.0),
  //                                             ),
  //                                             if (e.isSelected)
  //                                               Positioned(
  //                                                   right: 4,
  //                                                   child: Container(
  //                                                     width: 6,
  //                                                     height: 6,
  //                                                     decoration: BoxDecoration(
  //                                                         color: Colors
  //                                                             .green.shade400,
  //                                                         borderRadius:
  //                                                             BorderRadius
  //                                                                 .circular(3)),
  //                                                   ))
  //                                           ],
  //                                         ))
  //                                     .toList()),
  //                           ),
  //                           children: coinItem.tokenNetworks
  //                               .map((e) => Padding(
  //                                     padding:
  //                                         const EdgeInsets.only(left: 30.0),
  //                                     child: Row(
  //                                       mainAxisAlignment:
  //                                           MainAxisAlignment.spaceBetween,
  //                                       children: [
  //                                         LoadImage(
  //                                           e.bean.imageUrl,
  //                                           width: 30,
  //                                           height: 30,
  //                                         ),
  //                                         Text(e.bean.networkId),
  //                                         Switch(
  //                                             value: e.isSelected,
  //                                             onChanged: (value) => dispatch(
  //                                                 SelectCurrencyActionCreator
  //                                                     .onSwitchChanged(
  //                                                         coinItem.id,
  //                                                         e.bean.networkId,
  //                                                         value)))
  //                                       ],
  //                                     ),
  //                                   ))
  //                               .toList(),
  //                         );
}
