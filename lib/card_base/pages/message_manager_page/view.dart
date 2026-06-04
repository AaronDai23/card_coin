import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:common_utils/common_utils.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../widget/base_page_loading.dart';
import '../../bean/notice_message_bean.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MessageManagerState state, Dispatch dispatch, ViewService viewService) {
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
        title: Text(languageResource.messageCenter),
        actions: [
          if (state.list.isNotEmpty)
            TextButton(
                onPressed: () => dispatch(
                    MessageManagerActionCreator.onUpdateEdit(!state.isEdit)),
                child: Text(state.isEdit
                    ? languageResource.cancel
                    : languageResource.manager))
        ],
      ),
      body: BasePageLoadingView(
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg,
          onReload: () {
            dispatch(MessageManagerActionCreator.onShowLoading());
            dispatch(MessageManagerActionCreator.onLoadData());
          },
          buildBody: (isSuccess) {
            if (isSuccess) {
              return state.list.isNotEmpty
                  ? Column(
                      children: [
                        Expanded(
                          child: SmartRefresher(
                            enablePullUp: true,
                            enablePullDown: true,
                            controller: state.refreshController,
                            onRefresh: () {
                              state.currentPage = 1;
                              dispatch(
                                  MessageManagerActionCreator.onLoadData());
                            },
                            onLoading: () {
                              dispatch(MessageManagerActionCreator.onLoadData(
                                  isLoadMore: true));
                            },
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                              itemBuilder: (context, index) {
                                NoticeMessage noticeMessage = state.list[index];
                                var createTime = noticeMessage.createTime ?? 0;
                                var monthDate = DateUtil.formatDateMs(
                                    createTime,
                                    format: 'MM-dd');
                                return ListTile(
                                  horizontalTitleGap: 5.0,
                                  onTap: () {
                                    if (state.isEdit) {
                                      dispatch(MessageManagerActionCreator
                                          .onUpdateItemSelect(noticeMessage.id!,
                                              !noticeMessage.isSelected));
                                    } else {
                                      Navigator.of(viewService.context)
                                          .pushNamed('noticeDetailPage',
                                              arguments: {
                                            'noticeId': noticeMessage.id!
                                          });
                                    }
                                  },
                                  leading: state.isEdit
                                      ? IconButton(
                                          onPressed: null,
                                          icon: noticeMessage.isSelected
                                              ? const Icon(
                                                  Icons.check_box,
                                                  color: Colors.red,
                                                )
                                              : const Icon(
                                                  Icons.check_box_outline_blank,
                                                  color: Colors.grey,
                                                ))
                                      : null,
                                  title: Row(
                                    children: [
                                      Visibility(
                                        visible:
                                            noticeMessage.status == 'CREATED',
                                        child: Container(
                                          width: 10.0,
                                          height: 10.0,
                                          margin:
                                              const EdgeInsets.only(right: 6.0),
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5.0))),
                                        ),
                                      ),
                                      Expanded(
                                          child: Text(
                                        noticeMessage.title ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      Text(
                                        monthDate,
                                        style: const TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 4.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            noticeMessage.content ?? '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style:
                                                const TextStyle(fontSize: 14.0),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          size: 18.0,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: state.list.length,
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          color: Colors.white,
                          duration: const Duration(milliseconds: 200),
                          height: state.isEdit ? 70.0 : 0.0,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () => dispatch(
                                      MessageManagerActionCreator
                                          .onSelectAllClick()),
                                  icon: Icon(
                                    state.isAllSelected
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: state.isAllSelected
                                        ? Colors.red
                                        : Colors.grey,
                                  )),
                              const Spacer(),
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        dispatch(MessageManagerActionCreator
                                            .onSetMessagesRead());
                                      },
                                      icon: const Icon(Icons.flag,
                                          color: Colors.grey)),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        dispatch(MessageManagerActionCreator
                                            .onDeleteMessages());
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.grey))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  : const EmptyListView();
            } else {
              return const SizedBox();
            }
          }));
}
