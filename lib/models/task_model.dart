// import 'package:flutter/foundation.dart';

// /// Task Priority
// enum Priority { high, medium, low }

// /// Task Progress State
// enum Progress { planning, inProcess, onHold, complete }

// /// SubTask Model (checkbox items inside a task)
// class SubTask {
//   final String title;
//   final bool isDone;

//   const SubTask({
//     required this.title,
//     this.isDone = false,
//   });

//   SubTask copyWith({String? title, bool? isDone}) {
//     return SubTask(
//       title: title ?? this.title,
//       isDone: isDone ?? this.isDone,
//     );
//   }
// }

// /// Task Model
// class Task {
//   final String id;
//   final String title;
//   final String description;
//   final Priority priority;
//   final Progress progress;
//   final List<SubTask> subTasks;
//   final DateTime createdAt;

//   Task({
//     required this.id,
//     required this.title,
//     required this.description,
//     this.priority = Priority.medium,
//     this.progress = Progress.planning,
//     this.subTasks = const [],
//     DateTime? createdAt,
//   }) : createdAt = createdAt ?? DateTime.now();

//   Task copyWith({
//     String? id,
//     String? title,
//     String? description,
//     Priority? priority,
//     Progress? progress,
//     List<SubTask>? subTasks,
//     DateTime? createdAt,
//   }) {
//     return Task(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       priority: priority ?? this.priority,
//       progress: progress ?? this.progress,
//       subTasks: subTasks ?? this.subTasks,
//       createdAt: createdAt ?? this.createdAt,
//     );
//   }
// }
import 'package:hive/hive.dart';

part 'task_model.g.dart';

/// Task Priority
@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  high,
  @HiveField(1)
  medium,
  @HiveField(2)
  low,
}

/// Task Progress State
@HiveType(typeId: 1)
enum Progress {
  @HiveField(0)
  planning,
  @HiveField(1)
  inProcess,
  @HiveField(2)
  onHold,
  @HiveField(3)
  complete,
}

/// SubTask Model
@HiveType(typeId: 2)
class SubTask {
  @HiveField(0)
  final String title;
  @HiveField(1)
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
@HiveType(typeId: 3)
class Task {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final Priority priority;
  @HiveField(4)
  final Progress progress;
  @HiveField(5)
  final List<SubTask> subTasks;
  @HiveField(6)
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
