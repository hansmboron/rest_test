import 'package:flutter/material.dart';

class HttpPage extends StatefulWidget {
  const HttpPage({super.key});

  @override
  State<HttpPage> createState() => _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {
  final _formKey = GlobalKey<FormState>();
  final _urlEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('http package'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Exemplos:'),
          TextButton(
            onPressed: () {
              _urlEC.text = 'https://viacep.com.br/ws/01001000/json/';
            },
            child: const Text('https://viacep.com.br/ws/01001000/json/'),
          ),
          TextButton(
            onPressed: () {
              _urlEC.text = 'https://jsonplaceholder.typicode.com/todos/';
            },
            child: const Text('https://jsonplaceholder.typicode.com/todos/'),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  autofocus: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  autocorrect: false,
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    hintText: 'Type/Paste URL',
                    suffix: SizedBox(
                      height: 24,
                      child: TextButton(
                        style: const ButtonStyle(
                          visualDensity: VisualDensity.compact,
                        ),
                        onPressed: () {
                          _urlEC.text = '';
                        },
                        child: const Text('clear', style: TextStyle(fontSize: 11)),
                      ),
                    ),
                  ),
                  controller: _urlEC,
                  validator: (value) {
                    if (value == null || value.isEmpty || !(value.contains('http://') || value.contains('https://'))) {
                      return 'Url inválida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final bool valid = _formKey.currentState?.validate() ?? false;
                    if (valid) {}
                  },
                  child: const Text('Send Request'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text('erterw'),
        ],
      ),
    );
  }
}
