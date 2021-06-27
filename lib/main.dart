import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Hangman',
      home: MyHomePage(title: 'Flutter Hangman'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<String> _keys = "abcdefghijklmnopqrstu_vwxyz_".split("");

  final List<String> _wordList = ["color", "winter", "tornado", "football"];
  Random _random = Random();
  List<String>? _allGuesses = [];
  String? _displayWord = "";
  String? _repeatedGuess = "";
  List<String>? _splitWord = [];
  Color _keyColor = Colors.grey;
  int _selectedIndex = 0;
  int _chances = 6;
  bool _isGameover = false;

  @override
  void initState() {
    super.initState();
    int _randomNumber = _random.nextInt(_wordList.length);
    _displayWord = _wordList[_randomNumber];
    _splitWord = _displayWord!.split('');
    _allGuesses = [];
  }

  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => MyHomePage(title: widget.title),
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.bottomCenter,
              color: !_isGameover ? Colors.white : Colors.black54,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _splitWord!
                          .map((e) => _blankSquares(
                              title: _allGuesses!.contains(e) ? e : ""))
                          .toList(),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 220.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Text(
                              "You Guessed:",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 14.0, letterSpacing: 1),
                            ),
                            Text(
                              "${_allGuesses!.toList().join()}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 26.0,
                                  letterSpacing: 10,
                                  fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        Text(
                          !_isGameover ? "Chances:\n$_chances" : "😭",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 7,
                    children: List.generate(_keys.length, (index) {
                      return KeyButton(
                        text: _keys[index],
                        onTap: !_isGameover
                            ? () {
                                setState(() {
                                  if (_allGuesses!.contains(_keys[index])) {
                                    _repeatedGuess =
                                        "You have already guessed letter '${_keys[index]}'";

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(_repeatedGuess!)));
                                  } else {
                                    _allGuesses?.add(_keys[index]);
                                  }
                                  _selectedIndex = index;
                                  if (!_displayWord!
                                      .contains(_allGuesses!.last)) {
                                    _chances--;
                                    if (_chances == 0) {
                                      _isGameover = true;
                                    }
                                  }
                                });
                              }
                            : null,
                      );
                    }),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: Center(
                      child: Text(
                        "Developed By @AxinTriplet",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              top: 130.0,
              left: 70.0,
              child: Image.asset(
                "assets/images/hangStick.png",
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeIn,
              child: Visibility(
                visible: _chances < 6 ? true : false,
                child: Positioned(
                  top: 164.0,
                  left: 204.0,
                  child: Image.asset(
                    "assets/images/head.png",
                  ),
                ),
              ),
            ),
            Visibility(
              visible: _chances < 5 ? true : false,
              child: Positioned(
                top: 185.0,
                left: 214.0,
                child: Image.asset(
                  "assets/images/body.png",
                ),
              ),
            ),
            Visibility(
              visible: _chances < 4 ? true : false,
              child: Positioned(
                top: 190.0,
                left: 214.0,
                child: Image.asset(
                  "assets/images/right_arm.png",
                ),
              ),
            ),
            Visibility(
              visible: _chances < 3 ? true : false,
              child: Positioned(
                top: 191.0,
                left: 201.0,
                child: Image.asset(
                  "assets/images/left_arm.png",
                ),
              ),
            ),
            Visibility(
              visible: _chances < 2 ? true : false,
              child: Positioned(
                top: 233.0,
                left: 214.0,
                child: Image.asset(
                  "assets/images/right_feet.png",
                ),
              ),
            ),
            Visibility(
              visible: _chances < 1 ? true : false,
              child: Positioned(
                top: 234.0,
                left: 201.0,
                child: Image.asset(
                  "assets/images/left_feet.png",
                ),
              ),
            ),
            Positioned(
              top: 16.0,
              left: MediaQuery.of(context).size.width / 3.4,
              child: Image.asset(
                "assets/images/title.png",
              ),
            ),
            Positioned(
                top: 3.0,
                left: 10.0,
                child: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.replay_circle_filled_outlined,
                      color: Colors.black45,
                    ))),
            _isGameover
                ? Positioned(
                    top: MediaQuery.of(context).size.width + 30.0,
                    left: MediaQuery.of(context).size.width / 7,
                    child: Container(
                      width: 300.0,
                      height: 150.0,
                      decoration: BoxDecoration(color: Colors.grey[900]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Game Over!!! 🥴",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold),
                          ),
                          MaterialButton(
                            color: Colors.black,
                            onPressed: _reset,
                            child: Text(
                              "Play Again",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _blankSquares({String? title}) {
    return Container(
      width: 40.0,
      height: 60.0,
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2.0,
            color: Colors.black,
          ),
        ),
      ),
      child: Text(
        title!,
        style: TextStyle(fontSize: 30.0),
      ),
    );
  }
}

class KeyButton extends StatelessWidget {
  final String? text;
  final void Function()? onTap;

  const KeyButton({
    Key? key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Center(
        child: Text(
          text!,
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
