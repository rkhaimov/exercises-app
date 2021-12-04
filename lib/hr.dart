import 'package:flutter_blue/flutter_blue.dart';
import 'package:rxdart/rxdart.dart';

class HR {
  var _output$ = new BehaviorSubject<HRAction>();

  ValueStream<HRAction> get output$ {
    return _output$;
  }

  onInit() {
    FlutterBlue.instance.setLogLevel(LogLevel.emergency);

    FlutterBlue.instance.state.distinct().switchMap<List<int>>((value) {
      if (value != BluetoothState.on) {
        _output$.add(StatusAction('Waiting for Bluetooth'));

        return Stream.empty();
      }

      _output$.add(StatusAction('Scanning Started'));

      return Stream.fromFuture(
              FlutterBlue.instance.startScan(timeout: Duration(seconds: 4)))
          .switchMap((event) {
            _output$.add(StatusAction('Searching for POLAR'));

            return FlutterBlue.instance.scanResults
                .expand((results) => results);
          })
          .where((result) => result.device.id.id == 'A0:9E:1A:20:91:EE')
          .asyncMap((polar) async {
            _output$.add(StatusAction('POLAR found'));

            var connections = await FlutterBlue.instance.connectedDevices;

            await Future.wait(connections
                .where((c) => c.id.id == 'A0:9E:1A:20:91:EE')
                .map((c) => c.disconnect()));

            await polar.device.connect();

            return polar;
          })
          .asyncMap((polar) async {
            _output$.add(StatusAction('POLAR Connected'));

            var services = await polar.device.discoverServices();

            var service = services.firstWhere((element) =>
                element.uuid.toString() ==
                '0000180d-0000-1000-8000-00805f9b34fb');

            var characteristic = service.characteristics.firstWhere((element) =>
                element.uuid.toString() ==
                '00002a37-0000-1000-8000-00805f9b34fb');

            characteristic.setNotifyValue(true);

            return characteristic;
          })
          .switchMap((characteristic) => characteristic.value);
    }).listen((hr) {
      if (hr.isEmpty) {
        return;
      }

      _output$.add(HRReceivedAction(hr.last));
    });
  }

  dispose() {
    _output$.close();
  }
}

class HRReceivedAction extends HRAction<int> {
  int _hr;

  HRReceivedAction(this._hr);

  @override
  // TODO: implement payload
  int get payload => _hr;
}

class StatusAction extends HRAction<String> {
  String _status;

  StatusAction(this._status);

  @override
  // TODO: implement payload
  String get payload => this._status;
}

abstract class HRAction<TPayload> {
  TPayload get payload;
}
