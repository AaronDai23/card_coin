import 'package:card_coin/reown_wallet/utils/blockchain_utils.dart';
import 'package:card_coin/reown_wallet/utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:reown_walletkit/reown_walletkit.dart';

import '../../card_base/widgets/check_list_dialog.dart';
import '../widgets/wc_connection_widget/wc_connection_model.dart';
import '../widgets/wc_connection_widget/wc_connection_widget.dart';

class ConnectionWidgetBuilder {
  static List<WCConnectionWidget> buildFromRequiredNamespaces(
    Map<String, Namespace> generatedNamespaces,
  ) {
    final List<WCConnectionWidget> views = [];
    for (final key in generatedNamespaces.keys) {
      final namespaces = generatedNamespaces[key]!;
      final chains = NamespaceUtils.getChainsFromAccounts(namespaces.accounts);
      final chainNames = chains.map((e) => BlockchainUtils.getChainMetadata(e).name).toList();
      final List<WCConnectionModel> models = [];
      // If the chains property is present, add the chain data to the models
      models.add(
        WCConnectionModel(
          title: StringConstants.chains,
          elements: chainNames,
        ),
      );
      models.add(
        WCConnectionModel(
          title: StringConstants.methods,
          elements: namespaces.methods,
        ),
      );
      if (namespaces.events.isNotEmpty) {
        models.add(
          WCConnectionModel(
            title: StringConstants.events,
            elements: namespaces.events,
          ),
        );
      }

      views.add(
        WCConnectionWidget(
          title: key,
          info: models,
        ),
      );
    }

    return views;
  }

  static List<WCConnectionWidget> buildFromNamespaces(
    String topic,
    Map<String, Namespace> namespaces,
    BuildContext context,
  ) {
    final List<WCConnectionWidget> views = [];
    for (final key in namespaces.keys) {
      final ns = namespaces[key]!;
      final List<WCConnectionModel> models = [];
      // If the chains property is present, add the chain data to the models
      models.add(
        WCConnectionModel(
          title: StringConstants.accounts,
          elements: ns.accounts,
        ),
      );
      models.add(
        WCConnectionModel(
          title: StringConstants.methods,
          elements: ns.methods,
        ),
      );

      if (ns.events.isNotEmpty) {
        models.add(
          WCConnectionModel(
            title: StringConstants.events,
            elements: ns.events,
          ),
        );
      }

      views.add(
        WCConnectionWidget(
          title: key,
          info: models,
        ),
      );
    }

    return views;
  }


  static Widget buildFromRequiredNamespaces2(BuildContext context,Map<String, Namespace> generatedNamespaces,){
    final List<String> chainNames = [];
    for (final key in generatedNamespaces.keys) {
      final namespaces = generatedNamespaces[key]!;
      final chains = NamespaceUtils.getChainsFromAccounts(namespaces.accounts);
      final list = chains.map((e) => BlockchainUtils.getChainMetadata(e).name).toList();
      chainNames.addAll(list);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('切换并使用以下网络'),
                  const SizedBox(height: 4,),
                  Wrap(
                    children: chainNames
                        .map((e) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3,vertical: 4),
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade300),
                        child: Text(e)))
                        .toList(),
                  )
                ],
              ),
            ),
            TextButton(onPressed: () {
              showDialog(context: context, builder: (_){
                return CheckListDialog(list: chainNames.map((e) => CheckItem(e,isSelected: true)).toList(),);
              });
            }, child: const Text("编辑"))
          ],
        ),
      ),
    );
  }
}
