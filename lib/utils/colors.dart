import 'package:flutter/material.dart';
import 'package:mi_task/models/task_model.dart';

extension PriorityColors on Priority {
  Color get color {
    switch (this) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }
}
