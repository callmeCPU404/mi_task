import 'package:flutter/foundation.dart';

/// Task Priority
enum Priority { high, medium, low }

/// Task Progress State
enum Progress { planning, inProcess, onHold, complete }

/// SubTask Model (checkbox items inside a task)
class SubTask {
  final String title;
  final bool isDone;

  const SubTask({
    required this.title,
    this.isDone = false,
  });

  SubTask copyWith({String? title, bool? isDone}) {
    return SubTask(
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }
}

/// Task Model
class Task {
  final String id;
  final String title;
  final String description;
  final Priority priority;
  final Progress progress;
  final List<SubTask> subTasks;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.priority = Priority.medium,
    this.progress = Progress.planning,
    this.subTasks = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    String? description,
    Priority? priority,
    Progress? progress,
    List<SubTask>? subTasks,
    DateTime? createdAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      progress: progress ?? this.progress,
      subTasks: subTasks ?? this.subTasks,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
