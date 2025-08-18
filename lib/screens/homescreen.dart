import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';
import 'package:mi_task/screens/task_detail_screen.dart';
import 'package:mi_task/widgets/task_card.dart';
import 'add_task_screen.dart';

class Homescreen extends ConsumerWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        centerTitle: true,
      ),
      body: tasks.isEmpty
          ? const Center(
              child: Text(
                "No tasks yet. Add one!",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
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
    );
  }
}
