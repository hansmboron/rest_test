import 'package:flutter/material.dart';
import 'dio_page.dart';
import 'get_connect_page.dart';
import 'http_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST Test'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HttpPage()));
            },
            child: const Text('http package'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const DioPage()));
            },
            child: const Text('dio package'),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const GetConnectPage()));
            },
            child: const Text('get(GetConnect) package'),
          ),
        ],
      ),
    );
  }
}
