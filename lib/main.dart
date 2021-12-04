import 'package:exesices_app/hr.dart';
import 'package:exesices_app/notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(VanillaApp());
}

class VanillaApp extends StatefulWidget {
  @override
  _VanillaAppState createState() => _VanillaAppState();
}

class _VanillaAppState extends State<VanillaApp> {
  var hr = HR();
  var notifier = HeartRateNotifier();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    hr.onInit();
    notifier.onInit(hr.output$);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: StreamBuilder<HRAction>(
            stream: hr.output$,
            builder: (context, snapshot) {
              var action = snapshot.data;

              if (action is StatusAction) {
                return Text(action.payload);
              }

              if (action is HRReceivedAction) {
                return Text('HR connected');
              }

              return Text('Initializing');
            },
          ),
          centerTitle: true,
        ),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<HRAction>(
                  stream: hr.output$,
                  builder: (context, snapshot) {
                    var data = snapshot.data;

                    if (data is HRReceivedAction) {
                      return Text(
                        '${data.payload}',
                        style: TextStyle(
                            fontSize: 80, fontWeight: FontWeight.bold),
                      );
                    }

                    return Text(
                      '--',
                      style:
                          TextStyle(fontSize: 80, fontWeight: FontWeight.bold),
                    );
                  }),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: StreamBuilder<RangeValues>(
                  stream: notifier.range$,
                  builder: (context, snapshot) {
                    var values = snapshot.data;

                    if (values == null) {
                      return Text('');
                    }

                    return RangeSlider(
                        min: 60,
                        max: 120,
                        divisions: 6,
                        labels: RangeLabels('${values.start}', '${values.end}'),
                        values: values,
                        onChanged: notifier.setRange);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    hr.dispose();
  }
}
