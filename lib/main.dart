import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:udemy1/model/advice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Advice advice;

  @override
  void initState() {
    super.initState();
    _getAdvice().then((value) {
      setState(() {
        advice = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HSLColor.fromAHSL(1, 217, 0.19, 0.24).toColor(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: HSLColor.fromAHSL(1, 217, 0.19, 0.38).toColor(),
                ),
                height: 300,
                width: 350,
                child: FutureBuilder(
                  future: _getAdvice(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Spacer(
                                flex: 2,
                              ),
                              Text(
                                "ADVICE # ${advice.id.toString()}",
                                style: TextStyle(
                                    color: HSLColor.fromAHSL(1, 150, 1, 0.66)
                                        .toColor()),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Text(
                                " \"${advice.body}\"",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: HSLColor.fromAHSL(1, 193, 0.38, 0.86)
                                        .toColor(),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800),
                              ),
                              Spacer(
                                flex: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Divider(
                                          thickness: 2,
                                          color: HSLColor.fromAHSL(
                                                  1, 218, 0.23, 0.16)
                                              .toColor())),
                                  SvgPicture.asset(
                                      "images/pattern-divider-mobile.svg"),
                                  Expanded(
                                      child: Divider(
                                          thickness: 2,
                                          color: HSLColor.fromAHSL(
                                                  1, 218, 0.23, 0.16)
                                              .toColor())),
                                ],
                              ),
                              SizedBox(
                                height: 50,
                              )
                            ]),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                )),
            Positioned(
              bottom: -45,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    print("from red");
                    _getAdvice().then((value) {
                      setState(() {
                        advice = value;
                      });
                    });
                  },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        HSLColor.fromAHSL(1, 150, 1, 0.66).toColor(),
                    child: SvgPicture.asset(
                      "images/icon-dice.svg",
                      height: 35,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future<Advice> _getAdvice() async {
    const url = "https://api.adviceslip.com/advice";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body)['slip'];
    Advice gotAdvice = Advice(id: json['id'], body: json['advice']);

    return gotAdvice;
  }
}
