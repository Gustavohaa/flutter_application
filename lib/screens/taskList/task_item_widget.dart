import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/app_database.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final int index;
  final Animation<double> animation;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const TaskItemWidget({
    required this.task,
    required this.index,
    required this.animation,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
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
                _getStatusText(task.status),
                style: TextStyle(color: _getStatusColor(task.status)),
              ),
              if (task.deadline != null)
                Text(
                  "Prazo: ${DateFormat('dd/MM/yyyy HH:mm').format(task.deadline!)}",
                  style: TextStyle(color: Colors.redAccent),
                ),
            ],
          ),
          leading: IconButton(
            icon: _getStatusIcon(task.status),
            onPressed: onToggle,
          ),
          trailing: Wrap(
            spacing: 4,
            children: [
              IconButton(icon: Icon(Icons.edit, color: Colors.blueGrey), onPressed: onEdit),
              IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: onDelete),
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

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.grey;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(int status) {
    switch (status) {
      case 0:
        return "Não iniciada";
      case 1:
        return "Em progresso";
      case 2:
        return "Concluída";
      default:
        return "";
    }
  }
}
