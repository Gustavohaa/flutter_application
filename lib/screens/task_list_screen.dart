import 'package:flutter/material.dart';
import '../model/task_model.dart';
import 'add_task_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final GlobalKey<AnimatedListState> animated = GlobalKey<AnimatedListState>();
  List<Task> tasks = [];

  void addTask(Task task) {
    setState(() {
      tasks.add(task);
    });
    animated.currentState?.insertItem(tasks.length - 1);
  }

  void removeTask(int index) {
  final removedTask = tasks[index];

  animated.currentState?.removeItem(
    index,
    (context, animation) => FadeTransition( 
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 0.0,
        child: ListTile(
          title: Text(
            removedTask.name,
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
        ),
      ),
    ),
    duration: Duration(milliseconds: 300),
  );

  Future.delayed(Duration(milliseconds: 300), () {
    setState(() {
      tasks.removeAt(index);
    });
  });
}

  void updateTaskStatus(int index) {
    setState(() {
      tasks = List.from(tasks);
      if (tasks[index].status == TaskStatus.notStarted) {
        tasks[index].status = TaskStatus.inProgress;
      } else if (tasks[index].status == TaskStatus.inProgress) {
        tasks[index].status = TaskStatus.completed;
      } else {
        tasks[index].status = TaskStatus.notStarted;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Tarefas', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'Nenhuma tarefa adicionada.',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey[800]),
              ),
            )
          : AnimatedList(
              key: animated,
              initialItemCount: tasks.length,
              itemBuilder: (context, index, animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: _buildTaskItem(index),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(onTaskAdded: addTask),
            ),
          );
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTaskItem(int index) {
    final task = tasks[index];
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ListTile(
        title: Text(
          task.name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.blueGrey[900],
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        leading: AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: IconButton(
            key: ValueKey<TaskStatus>(task.status),
            icon: _getStatusIcon(task.status),
            onPressed: () => updateTaskStatus(index),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => removeTask(index),
        ),
      ),
    );
  }

  Icon _getStatusIcon(TaskStatus status) {
    switch (status) {
      case TaskStatus.notStarted:
        return Icon(Icons.circle_outlined, color: Colors.grey);
      case TaskStatus.inProgress:
        return Icon(Icons.timelapse, color: Colors.orange);
      case TaskStatus.completed:
        return Icon(Icons.check_circle, color: Colors.green);
    }
  }
}
