
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../../http/address.dart';
import '../../../../http/http_manager.dart';
import '../../../../widget/base_page_loading.dart';
import '../../../bean/member_level_bean.dart';

class PrivilegeDetailView extends StatefulWidget {
  final String privilegeId;

  const PrivilegeDetailView(this.privilegeId, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return PrivilegeDetailViewState();
  }
}

class PrivilegeDetailViewState extends State<PrivilegeDetailView> {
  LoadType status = LoadType.loading;
  PrivilegeDetail? privilegeDetail;
  @override
  void initState() {
    Map<String, dynamic> params = {'privilegeId': widget.privilegeId};
    HttpManager.getInstance().get(NetworkAddress.privilegeUrl, queryParameters: params).then((result) {
      if (result.isSuccess) {
        setState(() {
          privilegeDetail = PrivilegeDetail.fromJson(result.data);
          status = LoadType.loadSuccess;
        });
      } else {
        setState(() {
          status = LoadType.loadFailure;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding:
          const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
      semanticLabel: '',
      content: Container(
        width: MediaQuery.of(context).size.width*0.8,
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height*0.5),
        color: Colors.white,
        child: status == LoadType.loadSuccess?SingleChildScrollView(
            child: Html(data: privilegeDetail?.description??'',)):const SizedBox(width:30.0,height:30.0,child: Center(child: CircularProgressIndicator())),
      ),
      actions: [
        SizedBox(
            width: 200,
            height: 40,
            child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK')))
      ],
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.symmetric(vertical: 10.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0))),
    );
  }
}
