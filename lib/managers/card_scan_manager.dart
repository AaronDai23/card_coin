


class ScanError{
  int code;
  String errorMsg;

  ScanError(this.code, { this.errorMsg = ''});

}

abstract class CompletionResult<T>{
  T success();
  ScanError failure();
}

class ScanSuccessResult<T> implements CompletionResult<T>{
  ScanSuccessResult();

  @override
  ScanError failure() {
    // TODO: implement failure
    throw UnimplementedError();
  }

  @override
  T success() {
    // TODO: implement success
    throw UnimplementedError();
  }


}

// typedef CompletionCallback<T> = CompletionResult<T> Function(T element);

// class CardSession{
//   String? cardId;
//   String? initialMessage;
//
//   CardSession(this.cardId, {this.initialMessage});
// }

// abstract class CardSessionRunnable{
//   // void prepare(CompletionCallback? callback);
//   void run(CardSession cardSession,CompletionCallback? callback,);
// }

class CardScanManager{
  // void startSessionWithRunnable(CardSessionRunnable runnable,{String? cardId,String? initialMessage,CompletionCallback? callback}){
  //   var cardSession = makeSession(cardId, initialMessage);
  //   // runnable.run(cardSession);
  // }

  // CardSession makeSession(String? cardId,String? initialMessage){
  //   return CardSession(cardId,initialMessage: initialMessage);
  // }
}