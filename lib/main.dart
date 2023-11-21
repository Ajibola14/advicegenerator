import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:udemy1/api/advice_api.dart';
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
  late Future getAdvice;

  @override
  void initState() {
    super.initState();
    getAdvice = AdviceApi(Client()).getAdvice();
    getAdvice.then((value) {
      setState(() {
        advice = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const HSLColor.fromAHSL(1, 217, 0.19, 0.24).toColor(),
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
                  color: const HSLColor.fromAHSL(1, 217, 0.19, 0.38).toColor(),
                ),
                height: 300,
                width: 350,
                child: FutureBuilder(
                  future: getAdvice,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Spacer(
                                flex: 2,
                              ),
                              Text(
                                "ADVICE # ${advice.id.toString()}",
                                style: TextStyle(
                                    color:
                                        const HSLColor.fromAHSL(1, 150, 1, 0.66)
                                            .toColor()),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Text(
                                " \"${advice.body}\"",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: const HSLColor.fromAHSL(
                                            1, 193, 0.38, 0.86)
                                        .toColor(),
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800),
                              ),
                              const Spacer(
                                flex: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: Divider(
                                          thickness: 2,
                                          color: const HSLColor.fromAHSL(
                                                  1, 218, 0.23, 0.16)
                                              .toColor())),
                                  SvgPicture.asset(
                                      "images/pattern-divider-mobile.svg"),
                                  Expanded(
                                      child: Divider(
                                          thickness: 2,
                                          color: const HSLColor.fromAHSL(
                                                  1, 218, 0.23, 0.16)
                                              .toColor())),
                                ],
                              ),
                              const SizedBox(
                                height: 50,
                              )
                            ]),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )),
            Positioned(
              bottom: -45,
              child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    AdviceApi(Client()).getAdvice().then((value) {
                      setState(() {
                        advice = value;
                      });
                    });
                  },
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor:
                        const HSLColor.fromAHSL(1, 150, 1, 0.66).toColor(),
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
}
