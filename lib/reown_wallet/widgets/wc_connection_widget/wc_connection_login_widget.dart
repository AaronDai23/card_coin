import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import 'wc_connection_model.dart';
import 'wc_connection_widget_login_info.dart';

class WCConnectionLoginWidget extends StatelessWidget {
  const WCConnectionLoginWidget({
    super.key,
    required this.title,
    required this.info,
  });

  final String title;
  final List<WCConnectionModel> info;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: StyleConstants.lightGray,
        borderRadius: BorderRadius.circular(
          StyleConstants.linear16,
        ),
      ),
      padding: const EdgeInsets.all(
        StyleConstants.linear8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          )),
          const SizedBox(height: StyleConstants.linear8),
          ...info.map(
            (e) => WCConnectionWidgetLoginInfo(
              model: e,
            ),
          ),
        ],
      ),
    );
  }

}

