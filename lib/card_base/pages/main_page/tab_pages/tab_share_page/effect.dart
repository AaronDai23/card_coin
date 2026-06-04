import 'package:fish_redux/fish_redux.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:oktoast/oktoast.dart';
import '../../../../../http/address.dart';
import '../../../../../http/http_manager.dart';
import '../../../../bean/link_bean.dart';
import 'action.dart';
import 'state.dart';

Effect<TabShareState>? buildEffect() {
  return combineEffects(<Object, Effect<TabShareState>>{
    Lifecycle.initState: _onInit,
    TabShareAction.loadDomain: _onLoadDomain,
    TabShareAction.saveImage: _onSaveImage,
  });
}

Future<void> _onInit(Action action, Context<TabShareState> ctx) async {
  ctx.dispatch(TabShareActionCreator.onLoadDomain());
}

Future<void> _onSaveImage(Action action, Context<TabShareState> ctx) async {
  final languageResource = ctx.state.languageResource!;

  try {
    await ImageGallerySaver.saveImage(action.payload,
        quality: 60,
        name: 'share${DateTime.now().millisecondsSinceEpoch.toString()}');
    showToast(languageResource.saveRqSuccess);
  } catch (error) {
    showToast(languageResource.getSaveFailure(error.toString()));
  }
}

Future<void> _onLoadDomain(Action action, Context<TabShareState> ctx) async {
  Map<String, dynamic> params = {};
  var domainResult = await HttpManager.getInstance()
      .post(NetworkAddress.domainUrl, null, data: params);
  if (domainResult.isSuccess) {
    var domainResponse = LinkDomainResponse.fromJson(domainResult.data);
    ctx.dispatch(TabShareActionCreator.onLoadSuccess(domainResponse));
  } else {
    ctx.dispatch(TabShareActionCreator.onLoadFailure(domainResult.message));
  }
}
