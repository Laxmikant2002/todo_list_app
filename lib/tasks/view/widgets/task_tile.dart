import 'package:flutter/material.dart';
import 'package:todo_list_app/core/constants/app_colors.dart';
import '../../model/task.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskTile({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => onToggle(),
          activeColor: AppColors.primary,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted
                ? AppColors.textHint
                : AppColors.textPrimary,
          ),
        ),
        subtitle: task.description != null ? Text(task.description!) : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: AppColors.primary),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.error),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
