import 'package:flutter/material.dart';
import 'package:simple_overlay/simple_overlay.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple overlay demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simple Overlay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  bool showFirstOverlay = false;
  bool showSecondOverlay = false;

  @override
  void initState() {
    super.initState();
    // Configure params
    OverlayManager.instance
      ..backgroundColor = Colors.brown.withValues(alpha: 0.7)
      ..borderRadius = 10
      ..padding = EdgeInsets.all(10);
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => setState(() {
                showFirstOverlay = true;
              }),
              child: Text('show one overlay'),
            ),
            AnchoredOverlay(
              offset: Offset(-0.5, 1.25),
              parentKey: ValueKey('SecondOverlay'),
              showOverlay: showSecondOverlay,
              onOverlayTap: () {
                setState(() {
                  showSecondOverlay = false;
                  showFirstOverlay = false;
                });
              },
              overlayBuilder: (_) => Material(
                color: Colors.white,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    'Tap here to show multiple overlays',
                  ),
                ),
              ),
              child: ElevatedButton(
                onPressed: () => setState(() {
                  showSecondOverlay = true;
                  showFirstOverlay = true;
                }),
                child: Text('show multiple overlays'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: AnchoredOverlay(
        offset: Offset(-0.85, -2.25),
        parentKey: ValueKey('FirstOverlay'),
        showOverlay: showFirstOverlay,
        onOverlayTap: () {
          setState(() {
            showFirstOverlay = false;
          });
        },
        overlayBuilder: (_) => Material(
          color: Colors.white,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Tap here to increment value',
            ),
          ),
        ),
        child: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
