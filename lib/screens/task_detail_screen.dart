import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';

class TaskDetailScreen extends ConsumerWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  Color _priorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatedTask =
        ref.watch(taskProvider).firstWhere((t) => t.id == task.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                updatedTask.title,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Priority badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _priorityColor(updatedTask.priority).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  updatedTask.priority.name.toUpperCase(),
                  style: TextStyle(
                    color: _priorityColor(updatedTask.priority),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                updatedTask.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Progress Dropdown
              DropdownButtonFormField<Progress>(
                value: updatedTask.progress,
                decoration: const InputDecoration(
                  labelText: "Progress",
                  border: OutlineInputBorder(),
                ),
                items: Progress.values.map((p) {
                  return DropdownMenuItem(
                    value: p,
                    child: Text(p.name),
                  );
                }).toList(),
                onChanged: (newProgress) {
                  if (newProgress != null) {
                    ref
                        .read(taskProvider.notifier)
                        .updateProgress(updatedTask.id, newProgress);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Subtasks
              const Text(
                "Subtasks",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              if (updatedTask.subTasks.isEmpty)
                const Text("No subtasks added."),
              ...List.generate(updatedTask.subTasks.length, (index) {
                final subTask = updatedTask.subTasks[index];
                return CheckboxListTile(
                  value: subTask.isDone,
                  title: Text(
                    subTask.title,
                    style: TextStyle(
                      decoration: subTask.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  onChanged: (_) {
                    ref
                        .read(taskProvider.notifier)
                        .toggleSubTask(updatedTask.id, index);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
