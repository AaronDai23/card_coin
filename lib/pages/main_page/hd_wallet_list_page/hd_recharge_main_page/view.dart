import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:card_coin/pages/main_page/hd_wallet_list_page/view/lazy_indexed_stack.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../app.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    HdRechargeMainState state, Dispatch dispatch, ViewService viewService) {
  var languageResource = state.languageResource!;
  bool isPasswordSet = state.isPasswordSet;
  int loadType = state.loadType;

  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: Text(
          loadType == 0 ? languageResource.recharge : languageResource.send,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          onTap: () {
            Navigator.of(viewService.context).pop();
          },
        ),
        // actions: [
        //   TextButton(
        //       onPressed: () => Navigator.of(viewService.context).pushNamed(
        //           'transactionDetailPage',
        //           arguments: {'wallet': state.info}),
        //       child: Text(
        //         languageResource.transactionRecord,
        //         style: TextStyle(color: Colors.white),
        //       ))
        // ],
      ),
      body: Column(children: [
        Container(
          width: double.infinity,
          height: 60.0,
          color: Colors.white,
          padding: const EdgeInsets.only(bottom: 0),
          child: TabBar(
            // key: ValueKey(state.tabList.map((e) => e.name).join()),
            // tabAlignment: TabAlignment.center,
            labelPadding: const EdgeInsets.all(0),
            controller: state.tabController,
            // indicator: BoxDecoration(),
            labelColor: const Color(0xFF5c75ff),
            unselectedLabelColor: Colors.grey[500],
            labelStyle: const TextStyle(fontSize: 20.0),
            unselectedLabelStyle: const TextStyle(fontSize: 20.0),
            isScrollable: true,
            onTap: (int index) {
              if (state.currentIndex != index) {
                dispatch(HdRechargeMainActionCreator.onJump(index));
              }
            },
            tabs: state.tabList.map((e) {
              return Tab(text: "  ${e.name}  ");
            }).toList(),
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey[200],
        ),
        Expanded(
            child: Stack(
          children: [
            LazyIndexedStack(
              reuse: false,
              index: state.currentIndex,
              itemBuilder: (c, i) {
                var item = state.tabList[i];
                Map<String, dynamic> params = {};
                if (loadType == 0) {
                  params = {
                    'currencyInfo': state.info.networkLists![state.currentIndex]
                  };
                } else {
                  params = {
                    'currencyInfo':
                        state.info.networkLists![state.currentIndex],
                    'isPasswordSet': isPasswordSet
                  };
                }
                return AppRoute.global.buildPage(item.page, params);
              },
              itemCount: state.tabList.length,
            )
          ],
        )),
      ]));
}
