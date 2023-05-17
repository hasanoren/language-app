import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'words.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: HomeScreen());
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? mainWord;
  Words words = Words();
  late Map<String, String> mixedWords;
  bool isTrue = false;
  int _selectedContainerIndex = -1;
  Color boxColor1 = Colors.blue;

  late List<String> keyList;
  late List<String> valueList;
  bool isShuffled = false;
  late Duration _duration;
  late Timer _timer;
  int sayac = 0;

  @override
  void initState() {
    super.initState();
    mainWordAndValueList();

    startTimer();

    //key list'inden ilk 4 key'i rastgele seçer
  }

  void startTimer() {
    _duration = Duration(seconds: 5);
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_duration.inSeconds > 0) {
        _duration -= Duration(seconds: 1);
      } else {
        _duration = Duration(seconds: 5);
        mainWordAndValueList();
      }
      setState(() {});
    });
  }

  bool isRightWord(int index) {
    return valueList[index] == mixedWords[mainWord];
  }

  void mainWordAndValueList() {
    mixedWords =
        words.shuffleMap(); //methodu kullanarak kelime map'ini mix yapar
    keyList = mixedWords.keys.toList(); //karışık key list
    valueList = mixedWords.values.toList(); //karışık value list
    mainWord = keyList[Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HomeScreen"),
      ),
      body: Column(
        children: [
          keyBox(mainWord: mainWord ?? ""),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: 4,
              itemBuilder: (BuildContext ctx, index) {
                return InkWell(
                  onTap: () {
                    _selectedContainerIndex = index; //seçilen index'i belirler
                    setState(() {
                      if (isRightWord(index)) {
                        _timer.cancel();
                        sayac = 1;
                        isTrue = true;
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            mainWordAndValueList();
                            startTimer();
                            sayac = 0;
                            isTrue = false;
                          });
                        });
                      } else if (!isRightWord(index)) {
                        _timer.cancel();

                        sayac = 2;
                        Timer(
                          Duration(seconds: 2),
                          () {
                            startTimer();
                            setState(() {});
                            mainWordAndValueList();
                            sayac = 0;
                          },
                        );
                      }
                    });
                  },
                  child: valueBox(
                      valueWord: valueList[index],
                      boxColor: sayac == 0
                          ? Colors.blue
                          : (sayac == 1 && _selectedContainerIndex == index
                              ? Colors.green
                              : sayac == 2 && _selectedContainerIndex == index
                                  ? Colors.red
                                  : Colors.blue)),
                );
              },
            ),
          ),
          countDown(context),
        ],
      ),
    );
  }

  Container countDown(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 100),
      child: Text(
        _duration.inSeconds.toString(),
        style:
            Theme.of(context).textTheme.headline2?.copyWith(color: Colors.red),
      ),
    );
  }
}

class keyBox extends StatelessWidget {
  const keyBox({
    Key? key,
    required this.mainWord,
  }) : super(key: key);

  final String mainWord;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      padding: EdgeInsets.all(20),
      color: Colors.blueGrey,
      child: Text(
        mainWord,
        style: Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(color: Colors.yellow),
      ),
    );
  }
}

class valueBox extends StatefulWidget {
  const valueBox({
    Key? key,
    required this.boxColor,
    required this.valueWord,
  }) : super(key: key);

  final Color boxColor;
  final String valueWord;

  @override
  State<valueBox> createState() => _valueBoxState();
}

class _valueBoxState extends State<valueBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: widget.boxColor, borderRadius: BorderRadius.circular(15)),
      child: Text(
        widget.valueWord,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
