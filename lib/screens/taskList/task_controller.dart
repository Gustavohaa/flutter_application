import 'package:flutter/material.dart';
import '../../database/app_database.dart';


class TaskController {
  final AppDatabase db;
  final int userId;
  final Function(List<Task>) onTasksChanged;
  final GlobalKey<AnimatedListState> listKey;

  List<Task> tasks = [];

  TaskController({
    required this.db,
    required this.userId,
    required this.onTasksChanged,
    required this.listKey,
  });

  void loadTasks() async {
    tasks = await db.getTasks(userId);
    tasks.sort(_compareTasksByDeadline);
    onTasksChanged(List.from(tasks));
  }

  void addTask(String name, DateTime? deadline) async {
    final id = await db.addTask(name, userId, deadline: deadline);
    final newTask = Task(id: id, name: name, status: 0, userId: userId, deadline: deadline);
    tasks.add(newTask);
    tasks.sort(_compareTasksByDeadline);
    onTasksChanged(List.from(tasks));
    listKey.currentState?.insertItem(tasks.indexOf(newTask));
  }

  void editTask(Task task, String newName, DateTime? newDeadline) async {
    await db.deleteTask(task.id);
    await db.addTask(newName, userId, deadline: newDeadline);
    loadTasks();
  }

  void toggleStatus(Task task) async {
    int newStatus = (task.status + 1) % 3;
    await db.updateTaskStatus(task.id, newStatus);
    loadTasks();
  }

  void deleteTask(int index) async {
    final task = tasks[index];
    listKey.currentState?.removeItem(index, (context, animation) => _buildDeletedTask(task, animation));
    await Future.delayed(Duration(milliseconds: 300));
    await db.deleteTask(task.id);
    tasks.removeAt(index);
    onTasksChanged(List.from(tasks));
  }

  Widget _buildDeletedTask(Task task, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: ListTile(
          title: Text(task.name, style: TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  int _compareTasksByDeadline(Task a, Task b) {
    if (a.deadline == null) return 1;
    if (b.deadline == null) return -1;
    return a.deadline!.compareTo(b.deadline!);
  }
}
