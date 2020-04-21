import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        //brightness: Brightness.dark,
        primaryColor: Colors.grey,
      ),
      home: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Flutter Count Up Chess Clock App'),
          ),
          child: SafeArea(child: MyHomePage())),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer timer;
  static int number = 2;
  dynamic time = List<dynamic>.generate(number, (int index) => null);
  List<Stopwatch> st =
      List<Stopwatch>.generate(number, (int index) => Stopwatch());
  int mode = -1;
  int old = -100;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(milliseconds: 300), (Timer timer) {
      if (mode != -1 && mode != -2) {
        setState(() {
        });
      }
    });

    for (int i = 0; i < number; i++) {
      setState(() {
        st[i].reset();
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void changeTimer() {
    if (0 <= old) {
      st[old].stop();
      st[mode].start();
    } else {
      st[mode].start();
    }
  }

  void modeChange() {
    switch (mode) {
      case -1: //not working, stop
        for (int i = 0; i < number; i++) {
          st[i].stop();
          st[i].reset();
        }
        break;
      case -2: //pause
        for (int i = 0; i < number; i++) {
          st[i].stop();
        }
        break;
      case -3: //reset
        for (int i = 0; i < number; i++) {
          st[i].reset();
        }
        setState(() {
          mode = -1;
        });
        break;
      default:
        changeTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < number; i++) {
      time[i] = st[i].elapsed;
    }
    //print(mode);
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Center(
                      child: mode != -1
                          ? Text(
                              '${time[0].inHours.toString().padLeft(2, '0')}:${(time[0].inMinutes % 60).toString().padLeft(2, '0')}:${(time[0].inSeconds % 60).toString().padLeft(2, '0')}',
                              style: Theme.of(context).textTheme.headline2,
                            )
                          : Text(
                              '00:00:00',
                              style: Theme.of(context).textTheme.headline2,
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  CupertinoButton(
                    color: st[0].isRunning ? Colors.pink : Colors.blue,
                    onPressed: () {
                      setState(() {
                        old = mode;
                        mode = 0;
                        modeChange();
                      });
                    },
                    child: mode == 0
                        ? const Text('Running')
                        : const Text('Stopping'),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  child: Center(
                    child: mode != -1
                        ? Text(
                            '${time[1].inHours.toString().padLeft(2, '0')}:${(time[1].inMinutes % 60).toString().padLeft(2, '0')}:${(time[1].inSeconds % 60).toString().padLeft(2, '0')}',
                            style: Theme.of(context).textTheme.headline2,
                          )
                        : Text(
                            '00:00:00',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                CupertinoButton(
                  color: st[1].isRunning ? Colors.pink : Colors.blue,
                  onPressed: () {
                    setState(() {
                      old = mode;
                      mode = 1;
                      modeChange();
                    });
                  },
                  child: st[1].isRunning
                      ? const Text('Running')
                      : const Text('Stopping'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CupertinoButton(
        color: Colors.red,
        child: mode == -2 ? const Icon(Icons.stop) : const Icon(Icons.pause),
        onPressed: () {
          if (0 <= mode) {
            setState(() {
              old = mode;
              mode = -2;
              modeChange();
            });
          } else if (mode == -2) {
            setState(() {
              old = mode;
              mode = -3;
              modeChange();
            });
          }
        },
      ),
    );
  }
}
