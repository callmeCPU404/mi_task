import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

final _uuid = const Uuid();

/// Notifier to manage list of tasks
class TaskNotifier extends StateNotifier<List<Task>> {
  TaskNotifier() : super([]);

  /// Add a new Task
  void addTask({
    required String title,
    required String description,
    Priority priority = Priority.medium,
    Progress progress = Progress.planning,
    List<SubTask> subTasks = const [],
  }) {
    final newTask = Task(
      id: _uuid.v4(),
      title: title,
      description: description,
      priority: priority,
      progress: progress,
      subTasks: subTasks,
    );
    state = [...state, newTask];
  }

  /// Update existing task
  void updateTask(String id, Task updatedTask) {
    state = [
      for (final task in state)
        if (task.id == id) updatedTask else task
    ];
  }

  /// Delete a task
  void deleteTask(String id) {
    state = state.where((task) => task.id != id).toList();
  }

  /// Toggle subtask completion
  void toggleSubTask(String taskId, int subTaskIndex) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(
            subTasks: [
              for (int i = 0; i < task.subTasks.length; i++)
                if (i == subTaskIndex)
                  task.subTasks[i]
                      .copyWith(isDone: !task.subTasks[i].isDone)
                else
                  task.subTasks[i],
            ],
          )
        else
          task
    ];
  }

  /// Change progress state
  void updateProgress(String taskId, Progress newProgress) {
    state = [
      for (final task in state)
        if (task.id == taskId)
          task.copyWith(progress: newProgress)
        else
          task
    ];
  }
}

/// Riverpod Provider
final taskProvider =
    StateNotifierProvider<TaskNotifier, List<Task>>((ref) => TaskNotifier());
