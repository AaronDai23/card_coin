import 'package:card_coin/card_base/bean/asset_summary_info.dart';
import 'package:card_coin/custom_widget/load_image.dart';
import 'package:fish_redux/fish_redux.dart';
import 'package:flutter/material.dart';
import 'package:card_coin/card_base/widgets/gradient_theme.dart';
import 'package:super_tooltip/super_tooltip.dart';
import '../../../widget/base_page_loading.dart';
import 'action.dart';
import 'state.dart';

Widget buildView(
    MyAssetState state, Dispatch dispatch, ViewService viewService) {
  final allAssets = state.assetSummaryInfo?.assetListData ?? [];
  final filtered = state.selectedType == 'ALL'
      ? allAssets
      : allAssets.where((e) => e.assetType == state.selectedType).toList();
  return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: Theme.of(viewService.context)
                .extension<GradientTheme>()!
                .primaryGradient,
          ),
        ),
        title: const Text("My Asset"),
      ),
      body: PageDataLoadingView(
          loadStatus: state.loadStatus,
          errorMsg: state.errorMsg,
          onReload: () {
            // dispatch(ScanWalletActionCreator.onShowLoading());
          },
          onLoadSuccess: () {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 12),
                  const Text('Total Asset', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(
                    state.assetSummaryInfo?.usdDisplayAmount ?? "",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),

                  /// --- 资产概览，宽度和列表一致 ---
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: state.assetSummaryInfo!.assetTypeData!
                        .map(
                          (item) => Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              // 去掉左右 padding，只保留上下间距
                              child: _AssetSummary(data: item),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 24),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 4),
                          _buildCategoryBtn(
                            AssetTypeData(
                                assetType: 'ALL', assetTypeName: 'All'),
                            state,
                            dispatch,
                          ),
                          const SizedBox(width: 8),
                          ...state.assetSummaryInfo?.assetTypeData
                                  ?.where((item) => item.assetType != 'ALL')
                                  .expand((item) {
                                return [
                                  const SizedBox(width: 8),
                                  _buildCategoryBtn(item, state, dispatch),
                                ];
                              }).toList() ??
                              [],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// 资产列表
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: filtered.length + 1,
                      itemBuilder: (context, index) {
                        if (index < filtered.length) {
                          final tooltipController = SuperTooltipController();
                          final item = filtered[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 6,
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(children: [
                                              LoadImage(
                                                item.imageUrl ?? '',
                                                width: 20,
                                                height: 20,
                                              ),
                                              const SizedBox(width: 8),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        item.assetTypeName ??
                                                            "",
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 16)),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        ConstrainedBox(
                                                          constraints:
                                                              const BoxConstraints(
                                                            maxWidth:
                                                                120, // 👈 这里设置最大宽度
                                                          ),
                                                          child: Text(
                                                            item.name ?? "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 4),
                                                        SuperTooltip(
                                                          controller:
                                                              tooltipController,
                                                          content: Text(
                                                            item.description ??
                                                                "",
                                                            softWrap: true,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              await tooltipController
                                                                  .showTooltip();
                                                            },
                                                            child: const Icon(
                                                              Icons.info,
                                                              size: 15,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Text("",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))
                                                  ],
                                                ),
                                              )
                                            ]),
                                          ]),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text("", maxLines: 1),
                                          Text(
                                              "${item.balance!} ${item.symbol!}",
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Text(item.usdDisplayAmount ?? "",
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  color: Colors.grey)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          // 总金额行
                          // 最后一行显示总金额
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 5),
                              child: Text(
                                state.selectedShowPrice,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  /// 底部按钮
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 45,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            dispatch(MyAssetActionCreator.onInvestmentPage(
                                state.uid));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Invest Detail'),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () {
                            dispatch(MyAssetActionCreator.onPushWalletPage(
                                state.uid));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Wallet'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
          onLoadFailure: () => Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    const Text('Total Asset', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    const Text(
                      "0.0",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 24),

                    /// 底部按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 45,
                          width: 140,
                          child: ElevatedButton(
                            onPressed: () {
                              // dispatch(
                              //     MyAssetActionCreator.onInvestmentPage(state.uid));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Invest Detail'),
                          ),
                        ),
                        SizedBox(
                          height: 45,
                          width: 140,
                          child: ElevatedButton(
                            onPressed: () {
                              // dispatch(
                              //     MyAssetActionCreator.onPushWalletPage(state.uid));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Wallet'),
                          ),
                        ),
                      ],
                    ),
                  ]))));
}

class _AssetSummary extends StatelessWidget {
  final AssetTypeData data;
  const _AssetSummary({required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("${data.assetTypeName}",
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          "${data.usdDisplayAmount}",
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

Widget _buildCategoryBtn(
    AssetTypeData item, MyAssetState state, Dispatch dispatch) {
  final bool isSelected = state.selectedType == item.assetType;
  return GestureDetector(
    onTap: () {
      dispatch(MyAssetActionCreator.onSelectType(item.assetType!));
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.black : Colors.white,
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        item.assetTypeName ?? '',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
