import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../database/app_database.dart';
import 'task_controller.dart';

Future<void> _showTaskDialog({
  required BuildContext context,
  required String title,
  required IconData dialogIcon,
  required String nameHint,
  required String actionText,
  required Function(String, DateTime?) onConfirmed,
  String? initialName,
  DateTime? initialDeadline,
}) {
  final nameController = TextEditingController(text: initialName);
  DateTime? selectedDate = initialDeadline;
  final primaryColor = const Color(0xFF1976D2); 

  return showDialog(
    context: context,
    builder: (_) => StatefulBuilder(
      builder: (context, setState) {
        final gradientColors = selectedDate == null
            ? [Colors.white, Colors.white]
            : [primaryColor.withOpacity(0.9), primaryColor];

        return Theme(
          data: ThemeData.light().copyWith(
            dialogTheme: DialogTheme(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 16,
            ),
          ),
          child: AlertDialog(
            backgroundColor: Colors.grey[50],
            title: Row(
              children: [
                Icon(dialogIcon, color: primaryColor),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: nameHint,
                    prefixIcon: Icon(
                      dialogIcon == Icons.task_alt ? Icons.edit_note : Icons.task,
                      color: primaryColor,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    hintStyle: TextStyle(color: Colors.grey[600]),
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(colors: gradientColors),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ElevatedButton.icon(
                    icon: Icon(
                      Icons.calendar_month,
                      color: selectedDate == null ? primaryColor : Colors.white,
                    ),
                    label: Text(
                      selectedDate == null
                          ? (title == "Nova Tarefa" ? "Selecionar prazo" : "Selecionar novo prazo")
                          : DateFormat('dd/MM/yyyy HH:mm').format(selectedDate!),
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedDate == null ? primaryColor : Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: selectedDate == null ? primaryColor : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        builder: (context, child) => Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: ColorScheme.light(
                              primary: primaryColor,
                              onPrimary: Colors.white,
                            ),
                            dialogBackgroundColor: Colors.white,
                          ),
                          child: child!,
                        ),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (context, child) => Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: primaryColor,
                                onPrimary: Colors.white,
                              ),
                              dialogBackgroundColor: Colors.white,
                            ),
                            child: child!,
                          ),
                        );
                        if (time != null) {
                          setState(() {
                            selectedDate = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancelar", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            onConfirmed(nameController.text, selectedDate);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    ),
  );
}

void showAddTaskDialog(BuildContext context, TaskController controller) =>
    _showTaskDialog(
      context: context,
      title: "Nova Tarefa",
      dialogIcon: Icons.task_alt,
      nameHint: "Nome da tarefa",
      actionText: "Adicionar",
      onConfirmed: controller.addTask,
    );

void showEditTaskDialog(BuildContext context, Task task, TaskController controller) =>
    _showTaskDialog(
      context: context,
      title: "Editar Tarefa",
      dialogIcon: Icons.edit_note,
      nameHint: "Novo nome da tarefa",
      actionText: "Salvar",
      initialName: task.name,
      initialDeadline: task.deadline,
      onConfirmed: (name, date) => controller.editTask(task, name, date),
    );
