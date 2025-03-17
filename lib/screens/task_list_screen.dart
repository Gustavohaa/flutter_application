import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/providers/task_provider.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Tarefas'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          return taskProvider.tasks.isEmpty
              ? Center(child: Text('Nenhuma tarefa adicionada.'))
              : ListView.builder(
                  itemCount: taskProvider.tasks.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(taskProvider.tasks[index]),
                      onDismissed: (direction) {
                        taskProvider.removeTask(index);
                      },
                      background: Container(color: Colors.red),
                      child: ListTile(
                        title: Text(taskProvider.tasks[index]),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTask');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}