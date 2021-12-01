import 'dart:async';

import 'package:exesices_app/switch_map.dart';

void main() async {
  var subscription = switchMap<int, String>(numbers(), (arg) => chars(arg))
      .listen(print);

  Future.delayed(Duration(seconds: 2), () => subscription.pause());
  Future.delayed(Duration(seconds: 5), () => subscription.resume());
  Future.delayed(Duration(seconds: 10), () => subscription.cancel());
}

Stream<int> numbers() async* {
  var n = 1;

  while (true) {
    yield n;

    n += 1;

    await Future.delayed(Duration(seconds: 5));
  }
}

Stream<String> chars(int n) async* {
  while (true) {
    await Future.delayed(Duration(seconds: 1));

    yield '$n A';
  }
}
