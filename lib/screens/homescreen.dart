// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mi_task/models/task_model.dart';
// import 'package:mi_task/providers/task_provider.dart';
// import 'package:mi_task/screens/task_detail_screen.dart';
// import 'package:mi_task/widgets/task_card.dart';
// import 'add_task_screen.dart';

// class Homescreen extends ConsumerWidget {
//   const Homescreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final tasks = ref.watch(taskProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Task Manager"),
//         centerTitle: true,
//       ),
//       body: tasks.isEmpty
//           ? const Center(
//               child: Text(
//                 "No tasks yet. Add one!",
//                 style: TextStyle(fontSize: 18, color: Colors.grey),
//               ),
//             )
//           : ListView.builder(
//               itemCount: tasks.length,
//               itemBuilder: (context, index) {
//                 final task = tasks[index];
//                 return TaskCard(
//                   task: task,
//                   onTap: () {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => TaskDetailScreen(task: task),
//     ),
//   );
// },

//                   onDelete: () {
//                     ref.read(taskProvider.notifier).deleteTask(task.id);
//                   },
//                 );
//               },
//             ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddTaskScreen()),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';
import 'package:mi_task/widgets/task_card.dart';
import 'add_task_screen.dart';
import 'task_detail_screen.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    // Helper: filter tasks by progress
    List<Task> filterTasks(Progress progress) {
      return tasks.where((task) => task.progress == progress).toList();
    }

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Task Manager"),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Planning"),
              Tab(text: "In Process"),
              Tab(text: "On Hold"),
              Tab(text: "Complete"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTaskList(filterTasks(Progress.planning), ref, context),
            _buildTaskList(filterTasks(Progress.inProcess), ref, context),
            _buildTaskList(filterTasks(Progress.onHold), ref, context),
            _buildTaskList(filterTasks(Progress.complete), ref, context),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTaskScreen()),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks, WidgetRef ref, BuildContext context) {
    if (tasks.isEmpty) {
      return const Center(
        child: Text(
          "No tasks here.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TaskDetailScreen(task: task),
              ),
            );
          },
          onDelete: () {
            ref.read(taskProvider.notifier).deleteTask(task.id);
          },
        );
      },
    );
  }
}
