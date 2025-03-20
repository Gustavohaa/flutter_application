import 'package:flutter/material.dart';
import '../model/task_model.dart';

class AddTaskScreen extends StatelessWidget {
  final Function(Task) onTaskAdded;

  AddTaskScreen({required this.onTaskAdded});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Tarefa', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Nome da Tarefa',
                labelStyle: TextStyle(color: Colors.blueGrey[800]),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  onTaskAdded(Task(name: _controller.text));
                  Navigator.pop(context);
                }
              },
              child: Text('Salvar', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
