import 'dart:async';

import 'package:flutter/material.dart';

import 'component/Image.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFFFFFFB)),
          useMaterial3: true,
        ),
        initialRoute: PAGE_START,
        onGenerateRoute: buildRouteFactory,
        routes: routes);
  }
}

class PageStartPage extends StatefulWidget {
  const PageStartPage({super.key});

  @override
  State<PageStartPage> createState() => _PageStartPageState();
}

class _PageStartPageState extends State<PageStartPage> {
  String imageTag = '${PAGE_START}/';
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  void _incrementCounter() {
    _loadingTimer?.cancel();
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timer.tick >= 6) {
        timer.cancel();
        Navigator.of(context).pushNamed(PAGE_MAIN_TAB);
      }
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(child: Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: screenWidth(context),
            height: screenHeight(context),
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFB),
            ),
            child: buildImage('${imageTag}start_bg'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 222,
              ),
              SizedBox(width: 85, height: 85, child: buildImage('${imageTag}page_start'),),
              const Spacer(
                flex: 1,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                child: SizedBox(
                  height: 6,
                  child: LinearProgressIndicator(
                      color: const Color(0xFF5099B4),
                      backgroundColor: const Color(0x24504D4D),
                      borderRadius: BorderRadius.circular(3),
                      value: null),
                ),
              ),
              const SizedBox(height: 62)
            ],
          ),
        ],
      ),
    ), onWillPop: () async {
      return false;
    });
  }
}
