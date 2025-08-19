// import 'package:flutter/material.dart';
// import 'package:mi_task/models/task_model.dart';

// class TaskCard extends StatelessWidget {
//   final Task task;
//   final VoidCallback onTap;
//   final VoidCallback onDelete;

//   const TaskCard({
//     super.key,
//     required this.task,
//     required this.onTap,
//     required this.onDelete,
//   });

//   Color _priorityColor(Priority priority) {
//     switch (priority) {
//       case Priority.high:
//         return Colors.red;
//       case Priority.medium:
//         return Colors.orange;
//       case Priority.low:
//         return Colors.green;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: ListTile(
//         onTap: onTap,
//         title: Text(
//           task.title,
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 4),
//             Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 // Priority badge
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                   decoration: BoxDecoration(
//                     color: _priorityColor(task.priority).withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     task.priority.name.toUpperCase(),
//                     style: TextStyle(
//                       color: _priorityColor(task.priority),
//                       fontWeight: FontWeight.bold,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 10),
//                 // Progress
//                 Text(
//                   task.progress.name,
//                   style: const TextStyle(
//                     fontSize: 12,
//                     fontStyle: FontStyle.italic,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         trailing: IconButton(
//           icon: const Icon(Icons.delete, color: Colors.red),
//           onPressed: onDelete,
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:mi_task/models/task_model.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback onView;
  final VoidCallback onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onView,
    required this.onDelete,
  });

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
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          task.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(task.description, maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 6),
            Row(
              children: [
                // Priority badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(
                      color: _priorityColor(task.priority),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Progress
                Text(
                  task.progress.name,
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
              onPressed: onView,
              tooltip: "View details",
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Delete task",
            ),
          ],
        ),
      ),
    );
  }
}
