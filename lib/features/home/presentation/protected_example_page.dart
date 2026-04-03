import 'package:flutter/material.dart';

/// Пример экрана, на который имеет смысл пускать только через [pushIfAuthenticated].
class ProtectedExamplePage extends StatelessWidget {
  const ProtectedExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Только для авторизованных')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Содержимое закрытого раздела.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
