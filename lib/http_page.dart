import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HttpPage extends StatefulWidget {
  const HttpPage({super.key});

  @override
  State<HttpPage> createState() => _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {
  http.Response? response;
  String? error;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _urlEC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('http package'),
      ),
      body: Scrollbar(
        child: ListView(
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
            TextButton(
              onPressed: () {
                _urlEC.text = 'http://127.0.0.1:8080';
              },
              child: const Text('http://127.0.0.1:8080'),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
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
                            setState(() {
                              response = null;
                              error = null;
                            });
                          },
                          child: const Text('clear', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    ),
                    controller: _urlEC,
                    validator: (value) {
                      if (value == null || value.isEmpty || !(value.contains('http://') || value.contains('https://'))) {
                        return 'Invalid URL';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      onPressed: () async {
                        final bool valid = _formKey.currentState?.validate() ?? false;
                        if (valid) {
                          await _sendRequest();
                        }
                      },
                      child: const Text('Send Request'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Visibility(
              visible: isLoading,
              replacement: const SizedBox(height: 4),
              child: const LinearProgressIndicator(),
            ),
            const SizedBox(height: 12),
            SelectableText.rich(
              TextSpan(text: 'request: ', children: [
                TextSpan(
                  text: '${response?.request?.toString()}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'statusCode: ', children: [
                TextSpan(
                  text: '${response?.statusCode}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'reasonPhrase: ', children: [
                TextSpan(
                  text: '${response?.reasonPhrase}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'contentLength: ', children: [
                TextSpan(
                  text: '${response?.contentLength} bytes',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'persistentConnection: ', children: [
                TextSpan(
                  text: '${response?.persistentConnection}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'headers: ', children: [
                TextSpan(
                  text: '${response?.headers}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            SelectableText.rich(
              TextSpan(text: 'body: ', children: [
                TextSpan(
                  text: '${response?.body}',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                ),
              ]),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Visibility(
              visible: error != null,
              child: SelectableText.rich(
                TextSpan(text: 'Error: ', children: [
                  TextSpan(
                    text: '$error',
                    style: TextStyle(fontWeight: FontWeight.normal, color: Colors.red.shade800),
                  ),
                ]),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendRequest() async {
    error = null;
    response = null;
    final client = http.Client();
    setState(() => isLoading = true);

    try {
      final Uri url = Uri.parse(_urlEC.text);
      response = await client.get(url);
    } on Exception catch (e) {
      error = e.toString();
    } finally {
      client.close();
    }

    setState(() => isLoading = false);
  }
}
