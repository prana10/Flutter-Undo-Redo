import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var undoController = UndoHistoryController();
  var controller = TextEditingController();

  String dataDrag = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TextFormField(
              undoController: undoController,
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Enter your name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                undoController.undo();
              },
              child: const Text('Undo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                undoController.redo();
              },
              child: const Text('Redo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text('undo drag card'),
            ),
            const SizedBox(height: 20),
            Draggable<String>(
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  dataDrag = "";
                });
              },
              data: controller.text,
              onDragCompleted: () {
                setState(() {
                  controller.clear();
                });
              },
              onDragEnd: (details) {
                setState(() {
                  dataDrag = controller.text;
                });
              },
              feedback: FadeTransition(
                opacity: const AlwaysStoppedAnimation(0.5),
                child: Item(
                  controller: controller,
                ),
              ),
              child: DragTarget<String>(
                onAcceptWithDetails: (details) {
                  setState(() {
                    dataDrag = details.data;
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return Item(
                    controller: controller,
                  );
                },
              ),
            ),
            const SizedBox(height: 72),
            Draggable<String>(
              onDraggableCanceled: (velocity, offset) {
                setState(() {
                  controller.clear();
                });
              },
              data: dataDrag,
              feedback: Container(
                padding: const EdgeInsets.all(10),
                color: Colors.grey[200],
                child: Text(
                  dataDrag.isEmpty ? '' : dataDrag,
                  style: const TextStyle(
                    decoration: TextDecoration.none,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
              onDragCompleted: () {
                setState(() {
                  dataDrag = "";
                });
              },
              onDragEnd: (details) {
                setState(() {
                  controller.text = dataDrag;
                });
              },
              child: DragTarget<String>(
                onAcceptWithDetails: (details) {
                  setState(() {
                    dataDrag = details.data;
                  });
                },
                builder: (
                  BuildContext context,
                  List<Object?> candidateData,
                  List<dynamic> rejectedData,
                ) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey[200],
                    child: Text(
                      dataDrag.isEmpty ? '' : dataDrag,
                      style: const TextStyle(
                        decoration: TextDecoration.none,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  const Item({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        return Container(
          padding: const EdgeInsets.all(10),
          color: Colors.grey[200],
          child: Text(
            controller.text,
            style: const TextStyle(
              decoration: TextDecoration.none,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        );
      },
    );
  }
}
