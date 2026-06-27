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
  final displayTypes =
      _buildDisplayTypes(state.assetSummaryInfo?.assetTypeData);
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
            final typeData = state.assetSummaryInfo?.assetTypeData ?? [];
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

                  /// --- 资产概览，数据非空时展示 ---
                  if (typeData.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: typeData
                          .map(
                            (item) => Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: _AssetSummary(data: item),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                  const SizedBox(height: 24),

                  /// Exchange & Cash Out 始终展示
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTopActionButton(
                        icon: Icons.currency_exchange,
                        text: 'Exchange',
                        onTap: () =>
                            dispatch(MyAssetActionCreator.onPushExchange()),
                      ),
                      const SizedBox(width: 12),
                      _buildTopActionButton(
                        icon: Icons.payments_outlined,
                        text: 'Cash Out',
                        onTap: () =>
                            dispatch(MyAssetActionCreator.onPushCashOut()),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                          ...displayTypes.expand((item) {
                            return [
                              const SizedBox(width: 8),
                              _buildCategoryBtn(item, state, dispatch),
                            ];
                          }).toList(),
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

List<AssetTypeData> _buildDisplayTypes(List<AssetTypeData>? sourceTypes) {
  final origin = sourceTypes ?? const <AssetTypeData>[];
  return origin
      .where((item) => (item.assetType?.toUpperCase() ?? '') != 'ALL')
      .toList();
}

Widget _buildTopActionButton({
  required IconData icon,
  required String text,
  required VoidCallback onTap,
}) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: Color(0xFF2E9E44),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
