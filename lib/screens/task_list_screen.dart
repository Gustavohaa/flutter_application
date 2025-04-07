import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database/app_database.dart';
import 'login_screen.dart';

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

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // === CRUD ===
  void loadTasks() async {
    final loadedTasks = await widget.db.getTasks(widget.userId);
    loadedTasks.sort(_compareTasksByDeadline);
    setState(() => tasks = loadedTasks);
  }

  void addTask(String name, DateTime? deadline) async {
    final id = await widget.db.addTask(name, widget.userId, deadline: deadline);
    final newTask = Task(id: id, name: name, status: 0, userId: widget.userId, deadline: deadline);
    setState(() {
      tasks.add(newTask);
      tasks.sort(_compareTasksByDeadline);
      _listKey.currentState?.insertItem(tasks.indexOf(newTask));
    });
  }

  void editTask(Task task, String newName, DateTime? newDeadline) async {
    await widget.db.deleteTask(task.id);
    await widget.db.addTask(newName, task.userId, deadline: newDeadline);
    loadTasks();
  }

  void toggleStatus(Task task) async {
    int newStatus = (task.status + 1) % 3;
    await widget.db.updateTaskStatus(task.id, newStatus);
    loadTasks();
  }

  void deleteTask(int index) async {
    final task = tasks[index];

    _listKey.currentState?.removeItem(
      index,
      (context, animation) => FadeTransition(
        opacity: animation,
        child: SizeTransition(
          sizeFactor: animation,
          axisAlignment: 0.0,
          child: Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(
                task.name,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              subtitle: task.deadline != null
                  ? Text(
                      "Prazo: ${DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!)}",
                      style: TextStyle(color: Colors.redAccent),
                    )
                  : null,
            ),
          ),
        ),
      ),
      duration: Duration(milliseconds: 300),
    );

    await Future.delayed(Duration(milliseconds: 300));
    await widget.db.deleteTask(task.id);
    setState(() => tasks.removeAt(index));
  }

  int _compareTasksByDeadline(Task a, Task b) {
    if (a.deadline == null) return 1;
    if (b.deadline == null) return -1;
    return a.deadline!.compareTo(b.deadline!);
  }

  // === Layout e Lógica da Tela ===
  void showAddTaskDialog() {
    final nameController = TextEditingController();
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text("Nova Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(hintText: "Nome da tarefa"),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(
                  selectedDate == null
                      ? "Selecionar prazo"
                      : DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!),
                ),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setModalState(() {
                        selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    addTask(nameController.text, selectedDate);
                    Navigator.pop(context);
                  },
                  child: Text("Adicionar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showEditTaskDialog(Task task) {
    final nameController = TextEditingController(text: task.name);
    DateTime? selectedDate = task.deadline;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: Text("Editar Tarefa"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(hintText: "Novo nome da tarefa"),
              ),
              SizedBox(height: 12),
              ElevatedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text(
                  selectedDate == null
                      ? "Selecionar novo prazo"
                      : DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!),
                ),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setModalState(() {
                        selectedDate = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );
                      });
                    }
                  }
                },
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancelar"),
                ),
                ElevatedButton(
                  onPressed: () {
                    editTask(task, nameController.text, selectedDate);
                    Navigator.pop(context);
                  },
                  child: Text("Salvar"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        elevation: 3,
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: ListTile(
          title: Text(
            task.name,
            style: TextStyle(
              fontSize: 18,
              color: Colors.blueGrey[900],
              decoration: task.status == 2 ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.status == 0
                    ? "Não iniciada"
                    : task.status == 1
                        ? "Em progresso"
                        : "Concluída",
                style: TextStyle(
                  color: task.status == 2
                      ? Colors.green
                      : task.status == 1
                          ? Colors.orange
                          : Colors.grey,
                ),
              ),
              if (task.deadline != null)
                Text(
                  "Prazo: ${DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!)}",
                  style: TextStyle(color: Colors.redAccent),
                ),
            ],
          ),
          leading: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: IconButton(
              key: ValueKey(task.status),
              icon: _getStatusIcon(task.status),
              onPressed: () => toggleStatus(task),
            ),
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blueGrey),
                onPressed: () => showEditTaskDialog(task),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => deleteTask(index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Icon _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icon(Icons.circle_outlined, color: Colors.grey);
      case 1:
        return Icon(Icons.timelapse, color: Colors.orange);
      case 2:
        return Icon(Icons.check_circle, color: Colors.green);
      default:
        return Icon(Icons.circle, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciador de Tarefas'),
        backgroundColor: Colors.blueAccent,
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
      body: tasks.isEmpty
          ? Center(
              child: Text(
                'Nenhuma tarefa adicionada.',
                style: TextStyle(fontSize: 18, color: Colors.blueGrey[800]),
              ),
            )
          : AnimatedList(
              key: _listKey,
              initialItemCount: tasks.length,
              itemBuilder: (context, index, animation) =>
                  _buildTaskItem(tasks[index], index, animation),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: showAddTaskDialog,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text("Nova Tarefa", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
