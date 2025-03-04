import 'package:flutter/material.dart';
import 'package:simple_multiple_overlays/simple_overlay.dart';

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
      ..backgroundColor = Colors.black.withValues(alpha: 0.7)
      ..borderRadius = 10
      ..padding = EdgeInsets.all(5);
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              offset: Offset(0, 4.75),
              parentKey: ValueKey('SecondOverlay'),
              showOverlay: showSecondOverlay,
              useCenter: true,
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
