enum TaskStatus { notStarted, inProgress, completed }

class Task {
  String name;
  TaskStatus status;

  Task({required this.name, this.status = TaskStatus.notStarted});
}