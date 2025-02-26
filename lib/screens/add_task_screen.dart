import 'package:flutter/material.dart';

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adicionar Tarefa')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Nome da Tarefa'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: (){},
              child: Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
