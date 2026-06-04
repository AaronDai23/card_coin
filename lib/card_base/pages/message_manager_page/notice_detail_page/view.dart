import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';

import '../../../../widget/base_page_loading.dart';
import '../../../utils/routes_util.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    NoticeDetailState state, Dispatch dispatch, ViewService viewService) {
  final languageResource = state.languageResource!;
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: Text(languageResource.messageDetail),
      ),
      body: BasePageLoadingView(
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg,
          onReload: () {
            dispatch(NoticeDetailActionCreator.onShowLoading());
            dispatch(NoticeDetailActionCreator.onLoadData());
          },
          buildBody: (isSuccess) {
            if (isSuccess) {
              var dateStr =
                  DateUtil.formatDateMs(state.noticeDetail?.createTime ?? 0);
              return SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.noticeDetail?.title ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      dateStr,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const Divider(
                      height: 20,
                    ),
                    Text(
                      state.noticeDetail?.content ?? '',
                    ),
                    if (state.noticeDetail?.actionButton?.isNotEmpty ?? false)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: ElevatedButton(
                              onPressed: () {
                                var noticeDetail = state.noticeDetail!;
                                String targetName = noticeDetail.actions ?? '';
                                String type = noticeDetail.actionType ?? '';
                                String title =
                                    noticeDetail.actionTypeName ?? '';
                                RoutesUtil.pushName(targetName,
                                    type: type, title: title);
                              },
                              child:
                                  Text(state.noticeDetail!.actionButton ?? '')),
                        ),
                      )
                  ],
                ),
              );
            } else {
              return const SizedBox();
            }
          }));
}
