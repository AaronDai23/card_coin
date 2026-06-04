import 'package:card_coin/pages/main_page/lightning_net_detail_page/bean/send_invoice_info.dart';
import 'package:fish_redux/fish_redux.dart';

//TODO replace with your own action
enum SendLightningInvoiceAction { action, scanQRCode, validateAddress, updateInvoiceInfo, updateLoading, sendClick }

class SendLightningInvoiceActionCreator {
  static Action onUpdateLoading(bool isLoading) {
    return Action(SendLightningInvoiceAction.updateLoading, payload: isLoading);
  }

  static Action onScanQRCode() {
    return const Action(SendLightningInvoiceAction.scanQRCode);
  }

  static Action onValidateAddress(String address) {
    return Action(SendLightningInvoiceAction.validateAddress, payload: address);
  }

  static Action onUpdateInvoiceInfo(SendInvoiceInfo? invoiceInfo) {
    return Action(SendLightningInvoiceAction.updateInvoiceInfo, payload: invoiceInfo);
  }

  static Action onSendClick() {
    return const Action(SendLightningInvoiceAction.sendClick);
  }
}
