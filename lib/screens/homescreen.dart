
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mi_task/models/task_model.dart';
// import 'package:mi_task/providers/task_provider.dart';
// import 'package:mi_task/widgets/task_card.dart';
// import 'add_task_screen.dart';
// import 'task_detail_screen.dart';

// class Homescreen extends ConsumerWidget {
//   const Homescreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final tasks = ref.watch(taskProvider);

//     // Helper: filter tasks by progress
//     List<Task> filterTasks(Progress progress) {
//       return tasks.where((task) => task.progress == progress).toList();
//     }

//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Task Manager"),
//           centerTitle: true,
//           bottom: const TabBar(
//             isScrollable: true,
//             tabs: [
//               Tab(text: "Planning"),
//               Tab(text: "In Process"),
//               Tab(text: "On Hold"),
//               Tab(text: "Complete"),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildTaskList(filterTasks(Progress.planning), ref, context),
//             _buildTaskList(filterTasks(Progress.inProcess), ref, context),
//             _buildTaskList(filterTasks(Progress.onHold), ref, context),
//             _buildTaskList(filterTasks(Progress.complete), ref, context),
//           ],
//         ),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (_) => const AddTaskScreen()),
//             );
//           },
//           child: const Icon(Icons.add),
//         ),
//       ),
//     );
//   }

//   Widget _buildTaskList(List<Task> tasks, WidgetRef ref, BuildContext context) {
//     if (tasks.isEmpty) {
//       return const Center(
//         child: Text(
//           "No tasks here.",
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       );
//     }
//     return ListView.builder(
//       itemCount: tasks.length,
//       itemBuilder: (context, index) {
//         final task = tasks[index];
// return TaskCard(
//   task: task,
//   onView: () {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => TaskDetailScreen(task: task),
//       ),
//     );
//   },
//   onDelete: () {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Task"),
//         content: const Text(
//           "Are you sure you want to delete this task?\nThis action cannot be undone.",
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             onPressed: () {
//               ref.read(taskProvider.notifier).deleteTask(task.id);
//               Navigator.pop(context);

//               ScaffoldMessenger.of(context).showSnackBar(
//                 const SnackBar(
//                   content: Text("Task deleted"),
//                   backgroundColor: Colors.red,
//                 ),
//               );
//             },
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//   },
// );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mi_task/models/task_model.dart';
import 'package:mi_task/providers/task_provider.dart';
import 'package:mi_task/screens/category_detail_screen.dart';
import 'package:mi_task/widgets/task_card.dart';
import 'task_detail_screen.dart';
import 'add_task_screen.dart';

class Homescreen extends ConsumerStatefulWidget {
  const Homescreen({super.key});

  @override
  ConsumerState<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends ConsumerState<Homescreen> {
  String _searchQuery = "";
  Priority? _filterPriority;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);

    // 🔹 Apply search + filter
    final filteredTasks = tasks.where((task) {
      final matchesSearch = task.title.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPriority = _filterPriority == null || task.priority == _filterPriority;
      return matchesSearch && matchesPriority;
    }).toList();

    // 🔹 Get recent 3 by priority (highest first)
    final recentPriorityTasks = filteredTasks
      ..sort((a, b) => a.priority.index.compareTo(b.priority.index));
    final topThree = recentPriorityTasks.take(3).toList();

    // 🔹 Group counts by progress
    final planningCount = tasks.where((t) => t.progress == Progress.planning).length;
    final inProcessCount = tasks.where((t) => t.progress == Progress.inProcess).length;
    final onHoldCount = tasks.where((t) => t.progress == Progress.onHold).length;
    final completeCount = tasks.where((t) => t.progress == Progress.complete).length;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Text(""),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Greeting
              const Text(
                "Hello there 👋",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // 🔹 Search + Filter row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search tasks...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<Priority?>(
                    value: _filterPriority,
                    hint: const Text("Filter"),
                    items: [
                      const DropdownMenuItem(value: null, child: Text("All")),
                      ...Priority.values.map(
                        (p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.name.toUpperCase()),
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _filterPriority = val;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 🔹 Recent Priority Tasks
              const Text("Recent Priority Tasks",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              SizedBox(
                height: 160,
                child: topThree.isEmpty
                    ? Center(
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            child: const Text(
                              "No priority tasks yet.\nNew tasks will appear here.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      )
                    : PageView.builder(
                        itemCount: topThree.length,
                        controller: PageController(viewportFraction: 0.85),
                        itemBuilder: (context, index) {
                          final task = topThree[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => TaskDetailScreen(task: task),
                              ),
                            ),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(task.title,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 6),
                                    Text(
                                      task.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Spacer(),
                                    Text(
                                      "Priority: ${task.priority.name}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 25),

              // 🔹 Todo List Grid
              const Text("Todo List",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildCategoryCard("Planning", planningCount, Icons.event_note,
                      Progress.planning),
                  _buildCategoryCard("In Process", inProcessCount, Icons.work,
                      Progress.inProcess),
                  _buildCategoryCard("On Hold", onHoldCount, Icons.pause_circle,
                      Progress.onHold),
                  _buildCategoryCard("Completed", completeCount,
                      Icons.check_circle, Progress.complete),
                ],
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
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

  Widget _buildCategoryCard(
      String title, int count, IconData icon, Progress progress) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Icon(icon, size: 28, color: Colors.blue),
            ),
            const Spacer(),
            Text(title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 6),
            Text("$count tasks"),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    // Navigate to a filtered list screen
                    final tasks = ref.read(taskProvider).where((t) => t.progress == progress).toList();
                    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => CategoryDetailScreen(category: progress),
  ),
);

                  },
                  icon: const Icon(Icons.remove_red_eye, size: 18),
                  label: const Text("View"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
