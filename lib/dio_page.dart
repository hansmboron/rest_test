import 'package:flutter/material.dart';

class DioPage extends StatefulWidget {
  const DioPage({super.key});

  @override
  State<DioPage> createState() => _DioPageState();
}

class _DioPageState extends State<DioPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dio package'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
