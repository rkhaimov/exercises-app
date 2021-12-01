import 'dart:async';

Stream<T> switchMap<S, T>(
    Stream<S> source, Stream<T> Function(S arg) createTarget) {
  return source.transform(StreamTransformer<S, T>((input, _) {
    late StreamSubscription<S> subscription;
    StreamSubscription<T>? prev;

    var controller = StreamController<T>(onPause: () {
      subscription.pause();
      prev?.pause();
    }, onResume: () {
      subscription.resume();
      prev?.resume();
    }, onCancel: () {
      subscription.cancel();
      prev?.cancel();
    });

    subscription = input.listen((n) {
      prev?.cancel();
      prev = createTarget(n).listen(controller.add);
    }, onDone: controller.close);

    return controller.stream.listen(null);
  }));
}
