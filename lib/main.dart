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
  dynamic timeL, timeR;
  Stopwatch stR = Stopwatch();
  Stopwatch stL = Stopwatch();
  bool isPlayingL = false;
  bool isPlayingR = false;
  bool isRunning = false;
  bool buttonState = false;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {
      setState(() {});
    });
    stL.reset();
    stR.reset();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isRunning) {
      timeL = stL.elapsed;
      timeR = stR.elapsed;
    }
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
                      child: isRunning
                          ? Text(
                              '${timeL.inHours.toString().padLeft(2, '0')}:${(timeL.inMinutes%60).toString().padLeft(2, '0')}:${(timeL.inSeconds%60).toString().padLeft(2, '0')}',
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
                    color: isPlayingL ? Colors.pink : Colors.blue,
                    onPressed: () {
                      if (isRunning == false) {
                        isRunning = true;
                        isPlayingL = true;
                        stL.start();
                        buttonState = false;
                      } else if (buttonState == true && isRunning == true) {
                        isPlayingL = true;
                        stL.start();
                        buttonState = false;
                      } else if (isRunning == true && isPlayingL == true) {
                        isPlayingL = false;
                        isPlayingR = true;
                        stL.stop();
                        stR.start();
                      }
                    },
                    child: isPlayingL
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
                    child: isRunning
                        ? Text(
                            '${timeR.inHours.toString().padLeft(2, '0')}:${(timeR.inMinutes%60).toString().padLeft(2, '0')}:${(timeR.inSeconds%60).toString().padLeft(2, '0')}',
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
                  color: isPlayingR ? Colors.pink : Colors.blue,
                  onPressed: () {
                    if (isRunning == false) {
                      isRunning = true;
                      isPlayingR = true;
                      buttonState = false;
                      stR.start();
                    } else if (buttonState == true && isRunning == true) {
                      isPlayingR = true;
                      stR.start();
                      buttonState = false;
                    } else if (isRunning == true && isPlayingR == true) {
                      isPlayingR = false;
                      isPlayingL = true;
                      stR.stop();
                      stL.start();
                    }
                  },
                  child: isPlayingR
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
        child: buttonState ? const Icon(Icons.stop) : const Icon(Icons.pause),
        onPressed: () {
          if (buttonState == false) {
            stL.stop();
            stR.stop();
            isPlayingL = false;
            isPlayingR = false;
            buttonState = true;
          } else if (buttonState == true) {
            stL.stop();
            stR.stop();
            stL.reset();
            stR.reset();
            isRunning = false;
            isPlayingL = false;
            isPlayingR = false;
          }
        },
      ),
    );
  }
}
