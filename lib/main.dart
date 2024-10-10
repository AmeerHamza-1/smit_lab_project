import 'package:flutter/material.dart';
import 'package:new_proj/todo.dart';

void main() {
  runApp(const Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: TodoApp(),
    );
  }
}