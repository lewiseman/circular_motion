import 'package:flutter/material.dart';
import 'package:circular_motion/circular_motion.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Motion',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Circular Motion',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SizedBox(
            width: 390,
            height: 390,
            child: SafeArea(
              // Here's the magic.
              child: CircularMotion(
                behavior: HitTestBehavior.translucent,
                centerWidget: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text('center'),
                  ),
                ),
                children: List.generate(
                  6,
                  (index) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.primaries[index],
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('$index'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
