import 'package:flutter/material.dart';
import 'task_controller.dart';
import 'task_dialogs.dart';
import 'task_item_widget.dart';
import '../../database/app_database.dart';
import '../login/login_screen.dart';

class TaskListScreen extends StatefulWidget {
  final AppDatabase db;
  final int userId;

  TaskListScreen({required this.db, required this.userId});

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  List<Task> tasks = [];
  late TaskController controller;

  @override
  void initState() {
    super.initState();
    controller = TaskController(
      db: widget.db,
      userId: widget.userId,
      onTasksChanged: (updatedTasks) => setState(() => tasks = updatedTasks),
      listKey: _listKey,
    );
    controller.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.blueAccent),
        title: Text(
          'Minhas Tarefas',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen(db: widget.db)),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: tasks.isEmpty
            ? Center(
                child: Text(
                  'Nenhuma tarefa adicionada.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueGrey[600],
                  ),
                ),
              )
            : AnimatedList(
                key: _listKey,
                initialItemCount: tasks.length,
                itemBuilder: (context, index, animation) => TaskItemWidget(
                  task: tasks[index],
                  index: index,
                  animation: animation,
                  onEdit: () => showEditTaskDialog(context, tasks[index], controller),
                  onDelete: () => controller.deleteTask(index),
                  onToggle: () => controller.toggleStatus(tasks[index]),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blueAccent,
        onPressed: () => showAddTaskDialog(context, controller),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Nova Tarefa",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
