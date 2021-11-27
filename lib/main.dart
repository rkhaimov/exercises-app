import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

void main() {
  runApp(VanillaApp());
}

class VanillaApp extends StatefulWidget {
  @override
  _VanillaAppState createState() => _VanillaAppState();
}

class _VanillaAppState extends State<VanillaApp> {
  BluetoothCharacteristic? characteristic;
  HeartRateNotifier notifier = HeartRateNotifier();

  @override
  Widget build(BuildContext context) {
    var c = characteristic;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Center(
          child: c == null
              ? FloatingActionButton(
                  child: Icon(Icons.connected_tv),
                  onPressed: connectToPolar,
                )
              : StreamBuilder<List<int>>(
                  stream: c.value,
                  builder: (context, snapshot) {
                    var data = snapshot.data;

                    if (data == null) {
                      return Text(
                        '--',
                        style: TextStyle(
                            fontSize: 80, fontWeight: FontWeight.bold),
                      );
                    }

                    if (data.length == 0) {
                      return Text(
                        '--',
                        style: TextStyle(
                            fontSize: 80, fontWeight: FontWeight.bold),
                      );
                    }

                    var rate = data.last;

                    notifier.accept(rate);

                    return Text(
                      '$rate',
                      style:
                          TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                    );
                  }),
        ),
      ),
    );
  }

  connectToPolar() {
    return FlutterBlue.instance.state.listen((blState) {
      if (blState == BluetoothState.on) {
        FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));

        var found = false;

        FlutterBlue.instance.scanResults.listen((scanned) async {
          if (found) {
            return;
          }

          var polar = scanned.firstWhere(
              (element) => element.device.id.id == 'A0:9E:1A:20:91:EE');

          found = true;

          polar.device.connect();

          var devices = await FlutterBlue.instance.connectedDevices;

          if (devices.length == 0) {
            return;
          }

          var services = await devices.first.discoverServices();

          var service = services.firstWhere((element) =>
              element.uuid.toString() ==
              '0000180d-0000-1000-8000-00805f9b34fb');

          var characteristic = service.characteristics.firstWhere((element) =>
              element.uuid.toString() ==
              '00002a37-0000-1000-8000-00805f9b34fb');

          characteristic.setNotifyValue(true);

          setState(() {
            this.characteristic = characteristic;
          });
        });

        return;
      }
    });
  }
}

class HeartRateNotifier {
  AudioCache player = AudioCache();
  bool _locked = false;

  accept(int rate) {
    if (rate < 120) {
      return;
    }

    if (_locked) {
      return;
    }

    _locked = true;
    player.play('bong.mp3');

    Timer(Duration(seconds: 10), () => _locked = false);
  }
}
