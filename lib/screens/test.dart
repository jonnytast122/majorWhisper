import 'package:flutter/material.dart';
import 'package:widget_arrows/widget_arrows.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: MyHomePage(),
      );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showArrows = true;

  @override
  Widget build(BuildContext context) => ArrowContainer(
        child: Scaffold(
          appBar: AppBar(
            title: ArrowElement(
              show: showArrows,
              color: Colors.red,
              id: 'title',
              targetId: 'rect2',
              targetAnchor: Alignment.topCenter,
              sourceAnchor: Alignment.bottomCenter,
              child: Text('Arrows everywhere'),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ArrowElement(
                      show: showArrows,
                      id: 'rect1',
                      targetIds: ['fab', 'title'],
                      sourceAnchor: Alignment.bottomCenter,
                      color: Colors.green,
                      child: Container(
                        width: 150,
                        height: 100,
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            'Rectangle 1',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ArrowElement(
                      show: showArrows,
                      id: 'rect2',
                      targetId: 'rect1',
                      targetAnchor: Alignment.centerRight,
                      sourceAnchor: Alignment.centerLeft,
                      child: Container(
                        width: 150,
                        height: 100,
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            'Rectangle 2',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          floatingActionButton: ArrowElement(
            id: 'fab',
            child: FloatingActionButton(
              onPressed: () => setState(() {
                showArrows = !showArrows;
              }),
              tooltip: 'hide/show',
              child: Icon(Icons.remove_red_eye),
            ),
          ),
        ),
      );
}
