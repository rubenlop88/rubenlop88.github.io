import 'package:flutter/material.dart';

class CounterWidget extends StatefulWidget {
  const CounterWidget({super.key});

  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Material(
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color(0xFF01589B)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () => setState(() => count--),
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Flutter Counter'),
                Text('${count}', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => count++),
            ),
          ],
        ),
      ),
    );
  }
}
